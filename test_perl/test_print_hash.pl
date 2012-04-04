#!/usr/bin/perl

sub print_hash {
  my $hash_ref = shift;
  my $handle = shift;
  my $level = shift;
  print $handle $level."{\n";
  foreach my $key (keys %{$hash_ref}) 
  {
    if (ref($hash_ref->{$key}) eq "HASH")
    {
      print $handle $level."$key =>\n";
      print_hash($hash_ref->{$key},$handle,$level."  ");
    }
    else
    {
      print $handle $level.$key . '=' . $hash_ref->{$key} . "\n";
    }
  }
  print $level."}"."\n";
};

$hash_ref={
  'a' => '1',
  'b' => '2',
  'c' => { 'x'=>3,'y'=>'4','z' => {'q'=>99}},
  'd' => '3'
};


print_hash($hash_ref,\*STDOUT);

$s="xyz123.344343 zk\n";
$s=~ s/(\d*\.\d{2})\d+/\1/;
print $s;
