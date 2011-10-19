package Employee;
use Person;
@ISA = ("Person");

sub new 
{
    my $class = shift;
    my $self  = Person->new();
    $self->SUPER::name('T101');
    $self->{WAGE}   = undef;
    bless ($self, $class);
    print "object of class Employee constructed\n";
    return $self;
}

1;
