#!/usr/bin/perl

use Test::More 'no_plan';

use strict;
use warnings;

use lib "t/lib";
use Test::Protobuf;

use Protobuf;
use Protobuf::Types;

use FindBin qw($Bin);
use lib "$Bin/autogen";

BEGIN { use_ok("AppEngine::Service::MemcacheProto") };

# scalar non-aggregates (e.g. "required string" or "optional int32")
{
    my $i1 = AppEngine::Service::MemcacheGetResponse::Item->new;
    $i1->set_key("key1");
    $i1->set_value("value1");
    $i1->set_flags(123);

    # get a single field
    $i1->merge_from_string("\x12\x05key_b");
    is($i1->key, "key_b", "i1 got new key");
    is($i1->value, "value1", "i1 got new key");

    my $i2 = AppEngine::Service::MemcacheGetResponse::Item->new;
    $i2->set_key("key2");
    $i2->set_value("value2");

    $i1->merge_from_string($i2->serialize_to_string);
    is($i1->key, "key2", "i1 got i2's key");
    is($i1->value, "value2", "i1 got i2's value");
    is($i1->flags, 123, "i1 still has its own flags");
}

# repeated non-aggregates (e.g. "repeated string" or "repeated int32")
{
    my $get = AppEngine::Service::MemcacheGetRequest->new;
    is($get->serialize_to_string, "");
    $get->add_key("foo");
    $get->add_key("bar");
    is($get->keys->[0], "foo");
    is($get->keys->[1], "bar");
    is($get->key_size, 2);
    bin_is($get->serialize_to_string, "\n\x03foo\n\x03bar");

    my $get2 = AppEngine::Service::MemcacheGetRequest->new;

    # add a foo
    $get2->add_key("foo");
    bin_is($get2->serialize_to_string, "\n\x03foo", "just a foo");

    # kill it.
    $get2->clear;
    bin_is($get2->serialize_to_string, "", "is cleared");

    # add it back.
    $get2->add_key("foo");

    # and append a bar.  (foo should still be there)
    $get2->merge_from_string("\n\x03bar");
    is($get2->key_size, 2);
    is($get2->keys->[0], "foo");
    is($get2->keys->[1], "bar");

    # but this should clear it and set it to just bar
    $get2->parse_from_string("\n\x03bar");
    is($get2->key_size, 1);
    is($get2->keys->[0], "bar");

    # round-trips:
    $get2->parse_from_string($get->serialize_to_string);
    bin_is($get2->serialize_to_string, $get->serialize_to_string, "round-trips");
}

# aggregates.  groups:
{
    my $gr = AppEngine::Service::MemcacheGetResponse->new;
    is($gr->item_size, 0, "no items");

    my $i1 = $gr->add_item;
    $i1->set_key("key");
    $i1->set_value("value");
    is($gr->item_size, 1, "now 1 item");

    bin_is($gr->serialize_to_string, "\x0b\x12\x03key\x1a\x05value\x0c");

    # double its size (add it all to itself)
    $gr->merge_from_string($gr->serialize_to_string);
    is($gr->item_size, 2, "now 2 items");
    is(scalar @{$gr->items}, 2, "yeah, really 2");
    is(ref($gr->items), "ARRAY", "is array");
    
    is($gr->items->[0]->key, "key", "item0 is 'key'");
    is($gr->items->[1]->key, "key", "item1 is 'key'");

    # double its size again
    $gr->merge_from_string($gr->serialize_to_string);
    is($gr->item_size, 4, "now 4 item");

    is($gr->items->[2]->key, "key");
    is($gr->items->[3]->key, "key");
  
}

# aggregates.  embedded messages:
{
    my $p = AppEngine::Service::MemcacheStatsResponse->new;
    $p->parse_from_string("\n\x0f\x08\x07\x10\x08\x18\t \n(\x055\x01\x01\x00\x00");
    is($p->stats->byte_hits, 9);
    is($p->stats->bytes, 5);
    is($p->stats->hits, 7);
    is($p->stats->items, 10);
    is($p->stats->misses, 8);
    is($p->stats->oldest_item_age, 257);
}

# unknown fields
{
    my $i1 = AppEngine::Service::MemcacheGetResponse::Item->new;
    $i1->set_key("key1");
    $i1->set_value("value1");
    $i1->set_flags(123);

    # a field not in the .proto
    $i1->merge_from_string("(\x01");

    is($i1->key, "key1", "key unchanged");
    is($i1->value, "value1", "value unchanged");
    is($i1->flags, 123, "flags unchanged");

    my $meta = Class::MOP::Class->initialize(ref $i1);

    my @attrs = $meta->protobuf_attributes;

    ok(my $events = Protobuf::Decoder->decode($i1->serialize_to_string));

    my %by_field = map { delete $_->{fieldnum} => $_ } @$events;
    is( scalar keys %by_field, 4, "four events" );

    is( @attrs, 3, "three attrs" );

    foreach my $attr ( @attrs ) {
        ok( $by_field{$attr->field->number}, "data for " . $attr->name . " exists in output" );
    }

    ok( $by_field{5}, "field 5 set" );
}

