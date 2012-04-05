#!/usr/bin/perl
use Config;
$Config{useithreads} or die('Recompile Perl with threads to run this program.');
use threads;
use threads::shared;
use Thread::Queue;

my $a=1;
my $b:shared=1;
my $dq = new Thread::Queue;

sub sub1 { $a=2; $b=2; print("In the thread\n"); $dq->enqueue(123); sleep(1); }

my $thr = threads->create(\&sub1);

$thr->join();

printf "%d %d %d\n", $a,$b, $dq->dequeue();
