package AcidWorx::API;

use Dancer2;
use Dancer2::Plugin::Email;

use v5.20;
use AcidWorx::Email;

use Data::Dumper qw(Dumper);

our $VERSION = '0.1';

set serializer => 'JSON';

get '/' => sub {

	return {test => 1, test2 => 2};

};

get '/confirm_email_send/:token/:email/:name' => sub {
	
	my $name = params->{ 'name' };

	my $acidworx_email = AcidWorx::Email->new(
		token => params->{ 'token' },
		email => params->{ 'email' },
	);

	my $template = Text::Template->new(
		TYPE => 'FILE',  
		SOURCE => config->{appdir} ."/views/confirm_email.tt",
	) or die $!;

	my $msg = $template->fill_in ( HASH => {
    	name => $name,
    	code => $acidworx_email->confirm_code,
    });

	email {
		from => 'no-reply@acidworx.com',
		to => $acidworx_email->email,
		subject => 'Please confirm your email',
		body => $msg,
	};

	return {status => 'ok'};

};

get '/confirm_email/:token/:code' => sub {
	my $token = params->{ 'token' };
	my $code = params->{ 'code' };
};

true;
