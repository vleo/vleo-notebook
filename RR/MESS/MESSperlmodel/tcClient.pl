#!/usr/bin/perl

use strict;
use TcpConnection;
use CallEventData;
use Data::Dumper;

#use Gtk2 '-init';

use MessConfig;
DEFAULT_CONFIG_FILE('tcClient.xml');

use Authen::SASL;

=pod

my $window = Gtk2::Window->new('toplevel');
$window->set_title("Hello World!");

my $lbox = new Gtk2::Layout;
$lbox->set_size(800,600);
 
my $button = Gtk2::Button->new("Press me");
$button->signal_connect(clicked => sub { print "Hello again - the button was pressed\n";  });
$lbox->add($button);

my $buttonq = Gtk2::Button->new("Quit");
$buttonq->signal_connect(clicked => sub { print "Quit\n"; Gtk2->main_quit; });
$lbox->add($buttonq);
$lbox->move($buttonq,200,100);

$window->add($lbox);
$window->set_default_size(800,600);
$window->show_all;
 
Gtk2->main;

exit;
=cut

my $sock = new TcpConnection(6666,'localhost');

#print $sock "Quick brown fox jumped over the lazy dog 1234567890 times!?\n";


print CONFIG('MY_PWD')," ",CONFIG('MY_ID'),"\n";

my $sasl = Authen::SASL->new
(
  mechanism => 'PLAIN',
  callback => 
	{
    pass => CONFIG('MY_PWD'),
    user => CONFIG('MY_ID'),
		authname => 'myauth' 
  }
);

# Creating the Authen::SASL::Cyrus instance
my $conn = $sasl->client_new("mess", "mess-server.vks.mt.ru");
# Client begins always
print Dumper($conn);

my $myRequest = $conn->client_start();
printf "myRequest=%s\n", $myRequest;
print $sock $myRequest;

#while ($conn->need_step) {
	my $reply = <$sock>;
  printf "reply=%s\n",$reply;
  my $nextRequest= $conn->client_step( $reply );
  printf "nextRequest=%s\n",$nextRequest;
  print $sock $nextRequest;
#}

if ($conn->code == 0) {
print STDERR "Negotiation succeeded.\n";
} else {
print STDERR "Negotiation failed.\n";
}

exit;

my $callData = new CallEventData;
my $messEvent = new MessEvent("localhost:6666","func123",{ a=>1, b=>2},{ s=>undef });

  $callData->setRaw($messEvent);
#  my $rawData=$call->getFrozen();
#  print $sock pack("N",length($rawData)),N$call->getFrozen();
  $callData->sendData($sock);

sleep(3);
printf "Closing socket\n";
$sock->close();
