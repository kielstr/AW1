package AcidWorx::Utils;

use v5.20;
use Data::Dumper;
use Carp;

use Moose;

with 'AcidWorx';

sub populate_countries {
	my $self = shift;
	my $sql = qq~
		SELECT * FROM country
	~;

	my $counties_hashref = $self->dbh->selectall_hashref($sql, 'country_code')
		or confess "Failed to fetch country hashref: " . $self->dbh->errstr;

	my $country_aref = [ 
		map {$counties_hashref->{$_} } 
			sort { $counties_hashref->{$a}{country_name} cmp $counties_hashref->{$b}{country_name} } 
				keys %{ $counties_hashref } 
	];


	$self->countries( $country_aref );

}

1;