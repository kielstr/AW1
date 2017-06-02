package AcidWorx::WWW;

use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Email;
use Dancer2::Plugin::Auth::Extensible;
use v5.20;
use Text::Template;
use FindBin qw( $RealBin );

use AcidWorx::Artist;
use AcidWorx::Demo;
use AcidWorx::Management::Demos;
use AcidWorx::Management::Artists;

use Data::Dumper qw(Dumper);

warn Dumper database;

our $VERSION = '0.1';

get '/' => require_login sub {
    template 'index';
};

get '/manage_artists/demos' => require_role Admin => sub {
	my $demos = AcidWorx::Management::Demos->new(
		dbh => database,
	);

	template 'manage_artists/demos', {
		demos => $demos->all_demos,
	}
};

post '/manage_artists/demos' => require_role Admin => sub {
	
	my $params = params;
	my $approved;

	my $demos = AcidWorx::Management::Demos->new(
		dbh => database,
		dont_populate => 1,
	);

	my $template = Text::Template->new(
		TYPE => 'FILE',  
		SOURCE => "$RealBin/../views/demo_approval.tt"
	) or die $!;

	for my $key ( keys %$params ) {
		if ( $key =~ /^approve_/) {
			my (undef, $token) = split '_', $key;
			
			$demos->set_approval( $token, $params->{$key} );
			
			if ( $params->{$key} == 1 ) {

				my $demo = AcidWorx::Demo->new (
					'token' => $token,
					'dbh' => database,
				);

				my $msg = $template->fill_in ( HASH => {
		        	name => $demo->name,
		        	link => "http://192.168.1.10:5000/new_artist?token=$token",
		        });

				email {
		            from    => 'no-reply@acidworx.com',
		            to      => $demo->email,
		            subject => 'Demo to AcidWorx',
					body    => $msg,
		            #attach  => '/path/to/attachment',
		        };
			}
		}
	}

	$demos->populate;

	template 'manage_artists/demos', {
		demos => $demos->all_demos,
	}
};


get '/manage_artists' => require_role Admin => sub {
	template 'manage_artists';
};

post '/manage_artists/new_requests' => require_role Admin => sub {
	my $params = params;

	my $artists = AcidWorx::Management::Artists->new(
		'dbh' => database,
	);

	if ( $params->{ 'approve' } ) {
		
		my $template = Text::Template->new(
			TYPE => 'FILE',  
			SOURCE => "$RealBin/../views/artist_approval.tt"
		) or die $!;

		my @approved;

		if ( ref $params->{ 'approve' } ) {
			@approved = @{ $params->{ 'approve' } }
		} else {
			push @approved, $params->{ 'approve' };
		}

		for my $token ( @approved ) {

			$artists->approve_by_token( $token );

			warn "\ntoken: " . Dumper( $token ) . "\n";

			my $artist = AcidWorx::Artist->new (
				'token' => $token,
				'dbh' => database,
			);

			my $msg = $template->fill_in( HASH => {
        		name => $artist->name,
        	});

			email {
	            from    => 'no-reply@acidworx.com',
	            to      => $artist->email,
	            subject => 'Welcome to AcidWorx',
	            body    => $msg,
	            #attach  => '/path/to/attachment',
	        };
		}

		$artists->get_new_request;
	}

	template 'manage_artists/new_requests', {
		new_requests => $artists->new_request,
	};
};

get '/manage_artists/new_requests' => require_login sub {
	my $artists = AcidWorx::Management::Artists->new(
		'dbh' => database,
	);

	template 'manage_artists/new_requests', {
		new_requests => $artists->new_request,
	};
};

get '/new_artist' => sub {

	my $token;

	if ( param 'token' ) {
		$token = param 'token';
	} elsif ( cookie( 'artist' ) ) {
		$token = cookie( 'artist' )->value;
	}

	if ( $token ) {
		my $demo = AcidWorx::Demo->new (
			'token' => $token,
			'dbh' => database,
		);

		unless ( $demo->approved ) {
			return template 'new_artist_no_token';
		}

	} else {
		return template 'new_artist_no_token';
	}


	session 'new_artist' => {} unless session( 'new_artist' );

	my $artist_details;

	my $artist = AcidWorx::Artist->new(
		'dbh' => database,
	);

	$artist->populate_countries;

	my $country_aref = $artist->countries;

	if ( $token ) {
		my $demo = AcidWorx::Demo->new (
			'dbh' => database,
			'token' => ( $token ? $token : undef )
		);

		if ( $demo->token ) {
			session 'new_artist' => {
				'name' => $demo->name,
				'artist_name' => $demo->artist_name,
				'country_id' => $demo->country_id,
				'email' => $demo->email,
				'token' => $demo->token,
			};
		}
	}

	template 'new_artist', {
		'artist_details' => $artist_details,
		'countries' => $country_aref,
	};
};

post '/new_artist' => sub {
	my $params = params;
	session 'new_artist' => {} unless session( 'new_artist' );

	for my $param ( keys %$params ) {
		session( 'new_artist' )->{ $param } = $params->{ $param };
	}

	my $artist = AcidWorx::Artist->new(
		params,
		dbh => database,
	);

	# populate token after creating the object so we don't self populate.
	#$artist->token( session( 'new_artist' )->{ 'token' } );

	if ( $artist->error ) {
		my $errors = $artist->errors;

		warn Dumper $errors;

		$artist->populate_countries;

		my $country_aref = $artist->countries;

		template 'new_artist', {
			'errors' => "Please enter all the required fields",
			'countries' => $country_aref,
		};

	} else {

		my @chars = ("A".."Z", "a".."z");
		my $code;
		$code .= $chars[rand @chars] for 1..18;

		session( 'new_artist' )->{'code'} = $code;

		my $template = Text::Template->new(
			TYPE => 'FILE',  
			SOURCE => "$RealBin/../views/confirm_email.tt"
		) or die $!;

		my $msg = $template->fill_in ( HASH => {
        	name => $artist->name,
        	code => $code,
        });

		email {
			from    => 'no-reply@acidworx.com',
			to      => $artist->email,
			subject => 'New artist sign up',
			body    => $msg,
			#attach  => '/path/to/attachment',
		};

		# Must save before sending the cookie so token is defined
		$artist->save;

		cookie(
			'artist' => $artist->token, 
			'http_only' => 1, 
			'expires' => '-1'
		);

		#redirect '/new_artist_thankyou';
		redirect '/new_artist_confirm_email';
	}
	
};

get '/new_artist_confirm_email' => sub {
	template 'new_artist_confirm_email';

};

post '/new_artist_confirm_email' => sub {

	my $params = params;

	my $artist = AcidWorx::Artist->new(
		'dbh' => database,
		'token' => ( cookies->{ 'artist' } and cookies->{ 'artist' }->value
				? cookies->{ 'artist' }->value : undef ) 
	);

	if ( $params->{ 'code' } eq session( 'new_artist' )->{ 'code' } ) {
		$artist->email_confirmed(1, 1);
	
		template 'new_artist_thankyou';
	} else {
		template 'new_artist_confirm_email', {
			'errors' => ["Invalid code"],
		};
	}
};

get '/new_artist_thankyou' => sub {
	template 'new_artist_thankyou';	
};

get '/demo' => sub {

	session 'demo' => {} unless session( 'demo' );

	my $demo = AcidWorx::Demo->new (
		'dbh' => database,
		'token' => ( cookies->{ 'artist' } and cookies->{ 'artist' }->value
			? cookies->{ 'artist' }->value : undef )
	);

	if ( $demo->token ) {
		session 'demo' => {
			'name' => $demo->name,
			'artist_name' => $demo->artist_name,
			'country_id' => $demo->country_id,
			'token' => $demo->token,
		};
	}

	session( 'demo' )->{ 'sent_to_other' } ||= 0;
	
	$demo->populate_countries;

	my $country_aref = $demo->countries;

	template 'demo', {
		'countries' => $country_aref,
	};	
};

post '/demo' => sub {
	my $params = params;

	session 'demo' => {} unless session( 'demo' );

	for my $param ( keys %$params ) {
		session( 'demo' )->{ $param } = $params->{ $param };
	}

	session( 'demo' )->{ 'sent_to_other' } ||= 0;

	my $template_data = session( 'demo' );

	warn "\n\n**** Session Demo -- \n" . ( Dumper session( 'demo' ) ) . "****\n\n\n";

	my $demo = AcidWorx::Demo->new (
		'dbh' => database,
		params,
	);

	if ( $demo->error ) {
		my $errors = $demo->errors;

		$demo->populate_countries;

		my $country_aref = $demo->countries;

		template 'demo', {
			'errors' => "Please enter all the required fields",
			'countries' => $country_aref,
		};

	} else {
		$demo->save;

		cookie(
			'artist' => $demo->token, 
			'http_only' => 1, 
			'expires' => 'Fri, 31 Dec 9999 23:59:59 GMT'
		);

		redirect '/demo_thankyou';
		
	}

};

get '/demo_thankyou' => sub {
	template 'demo_thankyou';
};

true;
