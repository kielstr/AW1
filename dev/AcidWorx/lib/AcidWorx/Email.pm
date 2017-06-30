package AcidWorx::Email;

use v5.20;

use Moose;

with 'AcidWorx';

has 'token' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'email' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'confirm_code' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );
has 'status' => ( 'is' => 'rw', 'isa' => 'Maybe[Str]' );

sub build {
	my $self = shift;

	my @chars = ("A".."Z", "a".."z");
	my $code;
	$code .= $chars[rand @chars] for 1 .. 18;

	$self->confirm_code( $code );
	$self->status( 'unconfirmed' );

	if ( $self->email and $self->token ) {
		$self->add;
	}
}

sub add {
	my $self = shift;

	my $dbh = $self->dbh;

	my $sql = qq~
		INSERT INTO email (
			token,
			email,
			confirm_code,
			status
		) VALUES (?, ?, ?, ?)
	~;

	$dbh->do( $sql, {}, 
		$self->token,
		$self->email,
		$self->confirm_code,
		$self->status,
	) or die $dbh->errstr;

}


__PACKAGE__->meta->make_immutable;

1;
