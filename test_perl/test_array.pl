#!/usr/bin/perl

undef(@a); $b=@a; @b=(int(@a),scalar(@a),@a+0,$#a);   printf "size= %s  array= %s\n",join(":",@b),join(":",@a);
@a = 0; $b=@a; @b=(int(@a),scalar(@a),@a+0,$#a);   printf "size= %s  array= %s\n",join(":",@b),join(":",@a);
@a =(1,,) ; $b=@a; @b=(int(@a),scalar(@a),@a+0,$#a);   printf "size= %s  array= %s\n",join(":",@b),join(":",@a);
@a =(1,undef,undef) ; $b=@a; @b=(int(@a),scalar(@a),@a+0,$#a);   printf "size= %s  array= %s\n",join(":",@b),join(":",@a);

@c = split(/\s+/,"abc  def"); printf "%s n= %d\n",join(":",@c),scalar(@c);
@c = split(/\s+/,"  abc  def  "); printf "%s  n= %d\n",join(":",@c),int(@c);
