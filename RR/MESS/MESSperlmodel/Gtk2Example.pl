#!/usr/bin/perl

use strict;
use feature 'say';
use Data::Dumper;

use Gtk2 '-init';

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
