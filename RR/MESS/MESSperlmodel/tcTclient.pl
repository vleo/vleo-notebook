#!/usr/bin/perl

use TcpConnection;
use Data::Dumper;
use Gtk2 '-init';

sub serverletThread
{
  my ($newSock) = @_;
  print ref($newSock)," Server receives:\n";
  while(<$newSock>)
    { print $_; } 
  close($newSock);
}

=pod

$window = Gtk2::Window->new('toplevel');
$window->set_title("Hello World!");
 
$button = Gtk2::Button->new("Press me");
$button->signal_connect(clicked => sub { print "Hello again - the button was pressed\n"; });
 
$window->add($button);
$window->show_all;
 
Gtk2->main;

=cut

my $sock = new TcpConnection;
my $sock1 = $sock->connectToAddr('localhost',6666);


print $sock1 "Quick brown fox jumped over the lazy dog 1234567890 times!?\n"
