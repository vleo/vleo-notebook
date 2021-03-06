package Protobuf::Attribute::Field::Scalar;
use Moose::Role;

use Protobuf::Types qw(type_constraint);

use namespace::clean -except => 'meta';

with q(Protobuf::Attribute::Field);

before _process_options => sub {
    my ( $class, $name, $options ) = @_;

    $options->{reader}    ||= $name;
    $options->{writer}    ||= "set_$name";
    $options->{predicate} ||= "has_$name";
    $options->{clearer}   ||= "clear_$name";

    my $field = $options->{field};

    my $type_constraint = $options->{type_constraint} = $class->field_to_type_constraint($options->{field});

    # 
    if ( defined ( my $default = $field->default_value ) ) {
        $options->{default} = $class->process_default($default, $type_constraint);
    } elsif ( $type_constraint->isa("Moose::Meta::TypeConstraint::Class") ) {
        my $class = $type_constraint->class;
        $options->{default} = sub { $class->new }; # FIXME only ->isa("Protobuf::Message")?
    }

    # make sure predicate returns false even if we define a default. the predicate
    # should really check that the field has been set by something other than the
    # default
    $options->{lazy} = 1 if exists $options->{default};

    if ( $type_constraint->is_a_type_of("Math::BigInt") ) {
        $options->{coerce} = 1;
    }
};

sub process_default {
    my ( $class, $default, $type_constraint ) = @_;

    if ( $type_constraint and !$type_constraint->check($default) ) {
        if ( $type_constraint->has_coercion ) {
            $default = $type_constraint->coerce($default);
        } else {
            die $type_constraint->get_message($default);
        }
    }

    unless ( ref $default ) {
        return $default;
    } else {
        if ( blessed($default) ) {
            if ( $default->isa("Math::BigInt" ) ) {
                return sub { $default->copy };
            }
        }

    }
    die "unsupported default value for Scalar";
}

sub protobuf_emit {
    my ( $self, $instance, $emit ) = @_;

    my $field = $self->field;

    if ( $self->has_value($instance) ) {
        $emit->( $field, $self->get_value($instance) );
    } else {
        if ($field->is_required ) {
            die sprintf "Missing required field '%s'\n", $self->name;
        }
    }
}

sub Moose::Meta::Attribute::Custom::Trait::Protobuf::Field::Scalar::register_implementation { __PACKAGE__ }

__PACKAGE__

__END__
