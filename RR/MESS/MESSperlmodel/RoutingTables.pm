#!/usr/bin/perl

package RoutingTables;

use strict;
use feature 'say';

use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw();
use Scalar::Util 'refaddr';
use Data::Dumper;
use Time::HiRes 'gettimeofday';

use MessMessage;
use MessageTransport;


my (%seenUUID,%localRoutes,%globalRT,%cid2mid,%sid2mid);

sub new
{
	my $class = shift;
	bless \do{my $v},$class;
}

sub cRoute
{
	my $self=shift;
	my $me=refaddr $self;
	my ($dstsub,$dst,$sock);
}

sub mRoute
{
	my $self=shift;
	my $me=refaddr $self;
	my ($dst,$src,$sock,$type);
	say "adding to routes ",join(":",@_);
	$localRoutes{$me}->{$_[0]}->{$_[1]}->{sock}=$_[2] if @_ >=2;
	return $localRoutes{$me}->{$_[0]};
}

sub mRouteDel
{
	my $self=shift;
	die unless scalar(@_) == 2;
	my $me=refaddr $self;

#	my $dst=$_[1];
#	@{$localRoutes{$me}->{$_[0]}} = grep { $dst ne $_ }  @{$localRoutes{$me}->{$_[0]}};

	
	delete $localRoutes{$me}->{$_[0]}->{$_[1]};

	return $localRoutes{$me}->{$_[0]};
}

sub floodRoute
{
	my $self= shift;
	my $me= refaddr $self;
	my ($myID,$msg,$localProcessing) = @_;

	# if UUID forwarded already - drop it
	return if $seenUUID{$me}->{$msg->get_UUID};
	# remember UUIDs for routed messages
	$seenUUID{$me}->{$msg->get_UUID}=gettimeofday;

	my $dst= $msg->get_DST;
	my $sock;
	say "message to $dst";
	# process events addressed locally
	if ($dst eq DST_BCAST or $dst eq $myID)
	{
		if ($msg->get_METHOD eq 'bcastRT')
		{
			my $dst = $msg->get_SRC;
		  my $gdst;
			foreach $gdst (keys %{$msg->get_ARGVAL->{rt}})
			{
				say "adding destinatin $gdst to globalRT";
				$globalRT{$me}->{$gdst} = $msg->get_ARGVAL->{rt}->{$gdst};
			}
		}
		elsif ($msg->get_METHOD eq 'bcastIP_PORT')
		{
			my $bc_id = $msg->get_ARGVAL->{id};
			if($bc_id ne $myID and $msg->get_SRC ne $myID)
			{
				my $bc_ip = $msg->getMsg->{ARGVAL}->{ip};
				my $bc_port = $msg->getMsg->{ARGVAL}->{port};
				if ( not grep { $bc_id eq $_ } (keys %{$localRoutes{$me}->{$myID}}) )
				{
					my $sock = new AuthenticatedLink($bc_ip,$bc_port);
					$self->mRoute($myID,$bc_id,$sock) if $sock;
				}
			}
		}
		else
		  { &$localProcessing($msg) }
	}
	# directly connected destination
	elsif(defined $localRoutes{$me}->{$myID}->{$dst})
	{
		print "sending to peer $dst: ",Dumper($localRoutes{$me}->{$myID});
		$sock=$localRoutes{$me}->{$myID}->{$dst}->{sock};
		$msg->sendData($sock)
	}
	# send to all connected MESS peers
	else
	{
		print "sending to all connected peers: ",Dumper($localRoutes{$me}->{$myID});
		foreach my $peer (keys %{$localRoutes{$me}->{$myID}})
		{
			$msg->sendData($localRoutes{$me}->{$myID}->{$peer}->{sock})
			  if $localRoutes{$me}->{$myID}->{$peer}->{type} eq 'MESS'
		}
	}
}

sub bcastLocalRT
{
	my $me = refaddr shift;
	my ($myID) = @_;
	#for all mess peers
	my $rtbe = new MessEvent($myID,'_BCAST_','bcastRT',{ 'rt' => $localRoutes{$me}},undef);
	floodRoute($myID,$rtbe)
}

sub bcastLocalIpPort
{
	my $self= shift;
	my $me = refaddr $self;
	die if @_ < 3;
	my ($myID,$ip,$port) = @_;
	#for all mess peers
	my $callData = new MessageTransport
		(MT_EVENT,SUBADDR_SELF,$myID,SUBADDR_SELF,DST_BCAST,'bcastIP_PORT',{ 'id' => $myID, 'ip' => $ip, 'port' => $port});
	$self->floodRoute($myID,$callData)
}

1;
