#!/usr/bin/perl

print &{$f=sub{$_[0]<=$_[1]?$_[0]." ".&$f($_[0]+1,$_[1]):""}}(1,10)."\n";
