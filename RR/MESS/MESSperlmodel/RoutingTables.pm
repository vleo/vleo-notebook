#!/usr/bin/perl

package RoutingTables;

use strict;
use feature 'say';

use Exporter;
our @ISA=qw(Exporter); 
our @EXPORT=qw(new);

use Scalar::Util 'refaddr';
use Data::Dumper;
use Time::HiRes 'gettimeofday';

use MessMessage;
use MessageTransport;

use constant RT_MESS => 'MESS';
use constant RT_TCC => 'TCC';
use constant RT_TCS => 'TCS';

my (%seenUUID,%localRoutes,%remoteRoutes);

# seenUUID keeps information about packets that had passed the node; flashed when grows over certain size
# localRoutes has local (direct) connections to tcClients, tcServers and other MESS servers
# remoteRoutes has list of MESS,clients,tc-servers with their connected MESS servers

sub new # table;
{
	my $class = shift;
	bless \do{my $v},$class;
}

sub gRoute
{
	my $self=shift;
	my $me=refaddr $self;
	my ($dst,$src,$type) = @_;
	die "should specify at least dst to lookup" unless $dst;
	if(@_>1)
	{
		die "Must specify src ID when adding remote route" unless $src;
		die "Must specify connection type as MESS, TCC or TCS, got $type" unless grep { $type eq $_ } (RT_MESS, RT_TCC, RT_TCS);
		say "adding entry to remote routing table: ",join(":",@_);
		$remoteRoutes{$me}->{$dst}->{src}=$src;
		$remoteRoutes{$me}->{$dst}->{type}=$type;
	}
	return $remoteRoutes{$me}->{$dst};
}

sub lRoute
{
	my $self=shift;
	my $me=refaddr $self;
	my ($dst,$sock,$type)= @_;
	die "should specify at least dst to lookup" unless $dst;
	if(@_>1)
	{
		die "Must specify socket when adding local route" unless $sock;
		die "Must specify connection type as MESS, TCC or TCS, got $type" unless grep { $type eq $_ } (RT_MESS, RT_TCC, RT_TCS);
		say "adding entry to local routing table: ",join(":",@_);
		$localRoutes{$me}->{$dst}->{sock}=$sock;
		$localRoutes{$me}->{$dst}->{type}=$type;
	}
	return $localRoutes{$me}->{$dst};
}

sub lRouteDel
{
	my $self=shift;
	my $me=refaddr $self;
	my ($dst)= @_;
	die "should specify destination to remove" unless @_ == 1;
	delete $localRoutes{$me}->{$dst};
	return 1;
}

sub gRouteDel
{
	my $self=shift;
	my $me=refaddr $self;
	my ($dst)= @_;
	die "should specify destination to remove" unless @_ == 1;
	delete $remoteRoutes{$me}->{$dst};
	return 1;
}

sub floodRoute
{
	my $self= shift;
	my $me= refaddr $self;
	my ($localID,$msg,$localHandler) = @_;

	# if UUID forwarded already - drop it
	return if $seenUUID{$me}->{$msg->get_UUID};
	# remember UUIDs for routed messages
	$seenUUID{$me}->{$msg->get_UUID}=gettimeofday;

	my $dst= $msg->get_DST;
	my $sock;
	say "message $dst->get_METHOD to $dst";
	# process events addressed locall MESS server
	if ($dstsub eq SUBADDR_SELF and ($dst eq DST_BCAST or $dst eq $localID))
	{
		if ($msg->get_METHOD eq 'bcastRTE')
		{
			my $bcsrc = $msg->get_SRC;
		  my $dst;
			foreach $dst (keys %{$msg->get_ARGVAL->{rt}})
			{
				say "adding destinatin $dst to globalRT";
				$self->gRoute($dst,$msg->get_ARGVAL->{rt}->{$dst}->{src},$msg->get_ARGVAL->{rt}->{$dst}->{type});
			}
		}
		elsif ($msg->get_METHOD eq 'bcastIP_PORT')
		{
			my $bc_id = $msg->get_ARGVAL->{id};
			if($bc_id ne $localID and $msg->get_SRC ne $localID)
			{
				my $bc_ip = $msg->getMsg->{ARGVAL}->{ip};
				my $bc_port = $msg->getMsg->{ARGVAL}->{port};
				if ( not grep { $bc_id eq $_ } (keys %{$localRoutes{$me}->{$localID}}) )
				{
					my $sock = new AuthenticatedLink($bc_ip,$bc_port);
					$self->mRoute($localID,$bc_id,$sock) if $sock;
				}
			}
		}
		else	# local tc-clients and tc-servers
		{	&$localHandler($localID,$msg) }
	}
	# directly connected destination (another MESS server)
	elsif(defined $localRoutes{$me}->{$dst})
	{
		print "sending to one peer $dst: ",Dumper($localRoutes{$me}->{$dst});
		$sock=$localRoutes{$me}->{$dst}->{sock};
		$msg->sendData($sock)
	}
	# send to all connected MESS peers, includes DST_BCAST
	else
	{
		print "sending to all connected peers: ";
		foreach my $peer (keys %{$localRoutes{$me}->{$localID}})
		{
			if ($localRoutes{$me}->{$localID}->{$peer}->{type} eq RT_MESS)
			{
				print "$peer "
				$msg->sendData($localRoutes{$me}->{$peer}->{sock})
			}
			print "\n";
		}
	}
}

sub bcastLocalRT
{
	my $me = refaddr shift;
	my ($localID) = @_;
	#for all mess peers
	my $rtbe = new MessEvent($localID,MT_EVENT,SUBADDR_SELF,$localID,SUBADDR_SELF,DST_BCAST,'bcastRTE',{ 'rt' => $localRoutes{$me}},undef);
	floodRoute($localID,$rtbe)
}

sub bcastLocalIpPort
{
	my $self= shift;
	my $me = refaddr $self;
	die if @_ < 3;
	my ($localID,$ip,$port) = @_;
	#for all mess peers
	my $callData = new MessageTransport
		(MT_EVENT,SUBADDR_SELF,$localID,SUBADDR_SELF,DST_BCAST,'bcastIP_PORT',{ 'id' => $localID, 'ip' => $ip, 'port' => $port});
	$self->floodRoute($localID,$callData)
}

1;
