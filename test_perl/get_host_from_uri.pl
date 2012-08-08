#!/usr/bin/perl

@URLS=(
"https://localhost",
"https://www.g33oog-le.ru/my/search?q=ununtu",
"http://www.google.ru/my/search?q=ununtu",
"http://www.g33oog-le.ru:777/my/search?q=ununtu"
);

$reURI2Host = 'https?://([[:alpha:]][[:alpha:][:digit:].-]*)(:\d+)?/?';

foreach (@URLS)
{
  ($host) = m/$reURI2Host/;
  printf "%s\n",$host;
}
