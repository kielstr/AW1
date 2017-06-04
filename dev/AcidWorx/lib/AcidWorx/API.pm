package AcidWorx::API;

use Dancer2;

use v5.20;

use Data::Dumper qw(Dumper);

our $VERSION = '0.1';

set serializer => 'JSON';

get '/' => sub {

	return {test => 1, test2 => 2};

};

true;
