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

my $sock = new TcpConnection(CONFIG('MY_MESS_PORT'),CONFIG('MY_MESS_ADDR'));

#print $sock "Quick brown fox jumped over the lazy dog 1234567890 times!?\n";

############ AUTHENTICATE NEW SOCKET ################
print CONFIG('MY_PWD')," ",CONFIG('MY_ID'),"\n";

my $sasl = Authen::SASL->new
(
  mechanism => 'DIGEST-MD5',
  callback => 
	{
    pass => CONFIG('MY_PWD'),
    user => CONFIG('MY_ID'),
		authname => 'messauth'
  }
);

my $myAuthConn;

sub authenticateClient
{
	my ($mySock) = @_;

	my $myConn = $sasl->client_new("mess", "mess-server.vks.mt.ru","noplaintext noanonymous");

	die "We expect to need client_start for DIGEST-MD5" unless $myConn->need_step; 

	die "Expecting empty return from client_start()" unless $myConn->client_start() eq ""; 

	die "We expect one step for DIGEST-MD5" unless $myConn->need_step;

	my $serverChallange;
	$mySock->sysread($serverChallange,1000);

	printf "serverChallange= %s\n",$serverChallange;
	my $clientResponse = $myConn->client_step($serverChallange);

	printf "initial= %s\n",$clientResponse;

	$mySock->send($clientResponse);

	die "We don't expect 2nd step for DIGEST-MD5" if $myConn->need_step;

	die "Negotiation failed:%s\n",$myConn->error unless ($myConn->code == 0);

	$myAuthConn=$myConn;

	return 1;
}

authenticateClient($sock);

exit;

my $callData = new CallEventData;
my $messEvent = new MessEvent(CONFIG('MY_ID'),CONFIG('MY_MESS_ID'),"ping",{ a=>1, b=>2},{ s=>undef });

  $callData->setRaw($messEvent);
  $callData->sendData($sock);

sleep(3);
printf "Closing socket\n";
$sock->close();
