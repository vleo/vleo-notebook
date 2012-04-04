#
# $Id: Makefile.PL 25 2009-05-13 18:53:14Z gomor $
#
use ExtUtils::MakeMaker;

my $libs = qx{dumbnet-config --libs 2>/dev/null}
   || ['-L/lib -L/usr/lib -L/usr/local/lib -ldnet'];

my $inc = qx{dumbnet-config --cflags 2>/dev/null}
   || '-I/include -I/usr/include -I/usr/local/include';

WriteMakefile(
   NAME          => 'Net::Libdnet',
   VERSION_FROM  => 'lib/Net/Libdnet.pm',
   LICENSE       => 'bsd',
   ABSTRACT_FROM => 'lib/Net/Libdnet.pm',
   AUTHOR        => 'GomoR <gomor-cpan_at_gomor.org>',
   LIBS          => $libs,
   INC           => $inc,
   DEFINE        => '',
   EXE_FILES     => [ @{[glob('bin/*.pl')]} ],
   PREREQ_PM     => {
      Class::Gomor => 0,
   },
);
