package AcidWorx::Demo;

use v5.20;
use Data::Dumper;
use Carp;
use Session::Token;

use Moose;

extends 'AcidWorx::Utils';

with 'AcidWorx';

has 'name' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'artist_name' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'email' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'country_id' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'sent_to_other' => ( 'is' => 'rw', 'isa' => 'Maybe[Bool]' );
has 'released_on' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'link' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'descripton' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'errors' => ( 'is' => 'rw', 'isa' => 'Maybe[ArrayRef]' );
has 'token' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'approved' => ( 'is' => 'rw', 'isa' => 'Bool' );

my %validate_subs = (
	artist_name => \&notnull,
	name => \&notnull,
	country_id => undef,
	email => \&notnull,
	sent_to_other => undef,
	released_on => undef,
	link => \&notnull,
	descripton => undef,
	approved => undef,
);

for ( __PACKAGE__->meta->get_all_attributes() ) {
	around $_->name => sub {
	    my $orig = shift;
	    my $self = shift;

	    return $self->$orig()
	        unless @_;

	    my $value = shift;

	    if ( defined $value and $validate_subs{ $value } ) {
	    	$validate_subs{ $value }->( $self, $_->name, $value );
	    }

    	return $self->$orig($value) if defined $value;
	};
}

sub BUILD {
	my $self = shift;
	
	if ( $self->email ) {
		$self->init;
	} elsif ( $self->token ) {
		$self->populate_from_token;
	}

	for ( __PACKAGE__->meta->get_all_attributes() ) {
		if ( $validate_subs{ $_->name } ) {
	    	$validate_subs{ $_->name}->( $self, $_->name, $self->{$_->name} );
	    }
	}

}

sub init {
	my $self = shift;
}

sub notnull {
	my ( $self, $name, $value ) = @_;
	my $errors =  $self->errors;

	if ( $value and $value eq "" or not $value ) {
		$self->add_error( "$name is required" );
	}
}

sub error {
	my $self = shift;
	return ($self->errors and int @{ $self->errors }) ? 1 : 0;
}

sub add_error {
    my ( $self, $errstr ) = @_;

    my $current_errors = $self->errors;
    push @$current_errors, $errstr;
    $self->errors( $current_errors );
}

sub save {
	my $self = shift;

	my $dbh = $self->dbh;

	my $sql = qq~
		INSERT INTO demo (
			name,
			artist_name,
			email,
			country_id,
			token,
			sent_to_other,
			released_on,
			link,
			description
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
	~;

	$self->token( Session::Token->new(entropy => 256)->get );

	$dbh->do( $sql, {}, 
		$self->name,
		$self->artist_name,
		$self->email,
		$self->country_id,
		$self->token,
		$self->sent_to_other,
		$self->released_on,
		$self->link,
		$self->descripton,
	) or die $dbh->errstr;

}

sub populate_from_token {
	my $self = shift;
	my $sql = qq~
		SELECT * FROM demo WHERE token = ?
	~;

	my $demo = $self->dbh->selectrow_hashref( $sql, {}, $self->token );

	#warn Dumper $demo;
	$self->name( $demo->{ 'name' } );
	$self->email( $demo->{ 'email' } );
	$self->artist_name( $demo->{ 'artist_name' } );
	$self->country_id( $demo->{ 'country_id' } );
	$self->approved( $demo->{ 'approved' } );

}

__PACKAGE__->meta->make_immutable;

1;