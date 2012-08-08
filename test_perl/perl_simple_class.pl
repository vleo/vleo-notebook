#!/usr/bin/perl

GenericClass::selfTest();

##################################################
package GenericClass;

use strict;
use warnings;

sub new {
    my $class = shift;
    my %args  = @_;

    my $self = {
        id           => $args{id},
        file         => $args{file},
        _name        => $args{name},
        _description => $args{description},
        _date        => $args{date},
        _time        => $args{time},
        _size        => $args{size},
    };

    unless (defined &get_id)
    {
      foreach my $attrib ( keys %$self ) {
          my $attrib0 = $attrib;
          $attrib0 =~ s/^_//;
          eval "sub $class\::get_$attrib0 { (my \$self)=\@_; return \$self->{'$attrib'} }\n";
          eval "sub $class\::set_$attrib0 { my (\$self,\$val)=\@_; \$self->{'$attrib'} = \$val }\n";
      }
    }

    return bless $self, $class;
}

sub selfTest
{
  my $t = GenericClass->new( id => 123, file => "xyz", name => "John Smith" );
  printf "%s\n", $t->get_id();
  printf "%s\n", $t->get_file();
  $t->set_name("Marry Ann");
  printf "%s\n", $t->get_name();
  my $t1 = GenericClass->new( id => 333);
}

1;

__END__
