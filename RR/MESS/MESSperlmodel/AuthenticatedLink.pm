#!/usr/bin/perl
package AuthenticatedLink;

use strict;
use feature 'say';

use Exporter;
our @ISA=qw(Exporter TcpConnection); 
our @EXPORT=qw(newClient newServer authenticateOnServer);
use Scalar::Util 'refaddr';

use TcpConnection;


my (%sasl,%auth);

sub newClient
{
	say "AuthenticatedLink::newClient ",join(":",@_);
	my ($class,$pass,$user,$host,$port) = @_;

	my $self = new TcpConnection($port,$host);
	my $me = refaddr $self;

	$sasl{$me}= Authen::SASL->new
	(
		mechanism => 'DIGEST-MD5',
		callback => 
		{
			pass => $pass,
			user => $user,
			authname => 'messauth'
		}
	);

	authenticateClient($self);

	bless $self,$class;
}

sub newServer
{
	say "AuthenticatedLink::newServer ",join(":",@_);
	my ($class,$port) = @_;
	my $self = new TcpConnection($port);
	my $me = refaddr $self;

	bless $self,$class;
}

sub authenticateClient
{
	my ($mySock) = @_;
	my $me=refaddr $mySock;

	my $myConn = $sasl{$me}->client_new("mess", "mess-server.vks.mt.ru","noplaintext noanonymous");

	die "We expect to need client_start for DIGEST-MD5" unless $myConn->need_step; 

	die "Expecting empty return from client_start()" unless $myConn->client_start() eq ""; 

	die "We expect one step for DIGEST-MD5" unless $myConn->need_step;

	my $serverChallange;
	$mySock->sysread($serverChallange,1000);

	printf "serverChallange= %s\n",$serverChallange;
	my $clientResponse = $myConn->client_step($serverChallange);
	die "Expecting client response string from 1st client_step()\n" unless $clientResponse ; 

	printf "clientResponse= %s\n",$clientResponse;

	$mySock->send($clientResponse);

	my $serverResponse;
	$mySock->sysread($serverResponse,1000);
	printf "serverResponse= %s\n",$serverResponse;

	die "We expect 2nd step for DIGEST-MD5" unless $myConn->need_step;

	$clientResponse = $myConn->client_step($serverResponse);
	die "Expecting empty return from 2nd client_step()" unless $clientResponse eq ""; 

	die "We don't expect 3rd step for DIGEST-MD5" if $myConn->need_step;
	die "Negotiation failed:".$myConn->error."\n" unless ($myConn->code == 0);

	$auth{$me}=$myConn;

	return 1;
}


sub authenticateOnServer
{
	my ($mySock,$clientIDs) = @_;
	my $me = refaddr $mySock;

	# v v v Authenticate new connection v v v
	$sasl{$me} = Authen::SASL->new (
		mechanism => "DIGEST-MD5",
		callback => 
		{
		# MAYBE FIXME!!! we ignore $parts->{authzid} info
			getsecret => 
				sub { $_[2]->($clientIDs->{$_[1]->{user}}) }
		}
	);

	my $myConn = $sasl{$me}->server_new("mess","mess-server.vks.mt.ru",{ no_integrity => 1 });
	die "We expect to need server_start() for DIGEST-MD5" unless $myConn->need_step;

  my $serverChallange;
	$myConn->server_start("",sub { $serverChallange = shift } ) eq "" or die "Expecting empty return from server_start()\n";
	printf "serverChallange= %s\n",$serverChallange;
	die "We expect to need one server_step() for DIGEST-MD5" unless $myConn->need_step;

	$mySock->send($serverChallange);

	# FIXME - need to remember blocking state
  $mySock->blocking(1);
	my $clientResponse;
	my $n = $mySock->sysread($clientResponse,1000);
	printf "buffer read %d bytes: %s\n",$n,$clientResponse;
	my $serverResponse;
	$myConn->server_step($clientResponse, sub { $serverResponse = shift });
	printf "serverResponse= %sr\n",$serverResponse;
	$mySock->send($serverResponse);

	die "We do not expect to need 2nd step for DIGEST-MD5" if $myConn->need_step;

	if ($myConn->code)
	{
		printf "Error code: %d Message: %s\n",$myConn->code,$myConn->error;
		return;
	}
	
	printf "Adding Auth OK status to socket %s\n",$mySock;
	# ^ ^ ^ Authenticate new connection ^ ^ ^

	# FIXME - need to remember blocking state
  $mySock->blocking(0);
	#print Dumper($myConn);

	$auth{$me}=$myConn;
	return;
}

sub getAuth
{
	my ($mySock) = @_;
	my $me = refaddr $mySock;
	return $auth{$me}->{'answer'}{'username'};
}

1;
