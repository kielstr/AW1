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

get '/manage_artists/edit' => require_role Admin => sub {
	my $artists_obj = AcidWorx::Management::Artists->new(
		'dbh' => database,
	);

	template 'manage_artists/select_artist', {
		'artists' => $artists_obj->get_artists,
		'back_url' => '/manage_artists',
	};

};

post '/manage_artists/edit' => require_role Admin => sub {

	my $artist_id = param( 'artist' );
	my $update = param( 'update' );

	if ( $artist_id ) {
		my $artist = AcidWorx::Artist->new(
			'dbh' => database,
			'artist_id' => $artist_id,
		);

		$artist->populate_countries;

		my $country_aref = $artist->countries;

		session 'artist' => {
			name => $artist->name,
			artist_name => $artist->artist_name,
			address => $artist->artist_name,

			'address_line1' => $artist->address_line1,
			'address_line2' => $artist->address_line2,
			'address_line3' => $artist->address_line3,
			'country_id' => $artist->country_id,
			'email' => $artist->email,
			'payment_email' => $artist->payment_email,
			'soundcloud_url' => $artist->soundcloud_url,
			'ra_url' => $artist->ra_url,
			'beatport_url' => $artist->beatport_url,
			'facebook_page' => $artist->facebook_page,
			'website' => $artist->website,
			'bio' => $artist->bio,
			'email_confirmed' => $artist->email_confirmed,
		};


		return template 'artist', {
			'countries' => $country_aref,
			'mode' => 'edit',
			'action' => '/manage_artists/edit',
			'back_url' => '/manage_artists/edit',
		};

	} elsif ( $update ) {
		my $params = params;
		session 'artist' => {} unless session( 'artist' );

		for my $param ( keys %$params ) {
			session( 'artist' )->{ $param } = $params->{ $param };
		}

		my $artist = AcidWorx::Artist->new(
			params,
			dbh => database,
		);

		# populate token after creating the object so we don't self populate.
		#$artist->token( session( 'artist' )->{ 'token' } );

		if ( $artist->error ) {
			my $errors = $artist->errors;

			warn Dumper $errors;

			$artist->populate_countries;

			my $country_aref = $artist->countries;

			template 'artist', {
				'errors' => "Please enter all the required fields",
				'countries' => $country_aref,
				'action' => '/new_artist',
				'mode' => 'new_artist',
				'back_url' => '/new_artist',
			};
		} else {
			$artist->save;
			redirect '/manage_artists';
		}
	}
};

get '/manage_artists/add' => require_role Admin => sub {
	session 'artist' => {};

	my $artist = AcidWorx::Artist->new(
		'dbh' => database,
	);

	$artist->populate_countries;

	my $country_aref = $artist->countries;

	template 'artist', {
		'countries' => $country_aref,
		'mode' => 'add',
		'action' => '/manage_artists/add',
		'back_url' => '/manage_artists',
	};
};

post '/manage_artists/add' => sub {
	my $params = params;
	session 'artist' => {} unless session( 'artist' );

	for my $param ( keys %$params ) {
		session( 'artist' )->{ $param } = $params->{ $param };
	}

	my $artist = AcidWorx::Artist->new(
		params,
		dbh => database,
	);

	# populate token after creating the object so we don't self populate.
	#$artist->token( session( 'artist' )->{ 'token' } );

	if ( $artist->error ) {
		my $errors = $artist->errors;

		$artist->populate_countries;

		my $country_aref = $artist->countries;

		template 'artist', {
			'errors' => "Please enter all the required fields",
			'countries' => $country_aref,
			'action' => '/manage_artists/add',
			'mode' => 'add',
			'back_url' => '/manage_artists',
		};

	} else {

		# Must save before sending the cookie so token is defined
		$artist->save;

		redirect '/manage_artists';
	}
	
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
		        	link => "http://acidworx.zapto.org:5000/new_artist?token=$token",
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

	$artists->get_new_request;

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


	session 'artist' => {} unless session( 'artist' );

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
			session 'artist' => {
				'name' => $demo->name,
				'artist_name' => $demo->artist_name,
				'country_id' => $demo->country_id,
				'email' => $demo->email,
				'token' => $demo->token,
			};
		}
	}

	template 'artist', {
		'artist_details' => $artist_details,
		'countries' => $country_aref,
		'action' => '/new_artist',
		'mode' => 'new_artist',
		'back_url' => '/new_artist',
	};
};

post '/new_artist' => sub {
	my $params = params;
	session 'artist' => {} unless session( 'artist' );

	for my $param ( keys %$params ) {
		session( 'artist' )->{ $param } = $params->{ $param };
	}

	my $artist = AcidWorx::Artist->new(
		params,
		dbh => database,
	);

	# populate token after creating the object so we don't self populate.
	#$artist->token( session( 'artist' )->{ 'token' } );

	if ( $artist->error ) {
		my $errors = $artist->errors;

		warn Dumper $errors;

		$artist->populate_countries;

		my $country_aref = $artist->countries;

		template 'artist', {
			'errors' => "Please enter all the required fields",
			'countries' => $country_aref,
			'action' => '/new_artist',
			'mode' => 'new_artist',
			'back_url' => '/new_artist',
		};

	} else {

		my @chars = ("A".."Z", "a".."z");
		my $code;
		$code .= $chars[rand @chars] for 1..18;

		session( 'artist' )->{'code'} = $code;

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

	if ( $params->{ 'code' } eq session( 'artist' )->{ 'code' } ) {
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

get 'manage_release' => require_role Admin => sub {

	template 'manage_release/index';

};

get '/manage_release/show' => require_role Admin => sub {

	template 'manage_release/show';

};

get '/manage_release/add' => require_role Admin => sub {

	my $artists_obj = AcidWorx::Management::Artists->new(
		dbh => database,
	);

	$artists_obj->get_artists;

	template 'manage_release/add', {
		artists => $artists_obj->artists,
	};

};



true;
