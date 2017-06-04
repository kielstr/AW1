#!/usr/bin/env perl

use v5.20;

use Plack::Builder;

use FindBin;
use lib "$FindBin::Bin/../lib";

use AcidWorx::WWW;
use AcidWorx::API;

builder {
    mount '/' => AcidWorx::WWW->to_app;
    mount '/api' => AcidWorx::API->to_app;
};

