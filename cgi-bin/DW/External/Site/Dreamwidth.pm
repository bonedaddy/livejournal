#!/usr/bin/perl
#
# DW::External::Site::Dreamwidth
#
# Class to support the Dreamwidth.org site.
#
# Authors:
#      Mark Smith <mark@dreamwidth.org>
#
# Copyright (c) 2009 by Dreamwidth Studios, LLC.
#
# This program is free software; you may redistribute it and/or modify it under
# the same terms as Perl itself.  For a copy of the license, please reference
# 'perldoc perlartistic' or 'perldoc perlgpl'.
#

package DW::External::Site::Dreamwidth;

use strict;
use base 'DW::External::Site';
use Carp qw/ croak /;


# new does nothing for these classes
sub new { croak 'cannot build with new'; }


# returns 1/0 if we allow this domain
sub accepts {
    my ( $class, $parts ) = @_;

    # allows anything at dreamwidth.org
    return 0 unless $parts->[-1] eq 'org' &&
                    $parts->[-2] eq 'dreamwidth';

    return bless { hostname => 'dreamwidth.org' }, $class;
}


# argument: DW::External::User
# returns URL to this account's journal
sub journal_url {
    my ( $self, $u ) = @_;
    croak 'need a DW::External::User'
        unless $u && ref $u eq 'DW::External::User';

# FIXME: this should do something like $u->is_person to determine what kind
# of thing to setup...
    return 'http://www.dreamwidth.org/users/' . $u->user . '/';
}


# argument: DW::External::User
# returns URL to this account's journal
sub profile_url {
    my ( $self, $u ) = @_;
    croak 'need a DW::External::User'
        unless $u && ref $u eq 'DW::External::User';

# FIXME: same as above
    return 'http://www.dreamwidth.org/users/' . $u->user . '/profile';
}


# argument: DW::External::User
# returns URL to the badge image (head icon) for this user
sub badge_image_url {
    my ( $self, $u ) = @_;
    croak 'need a DW::External::User'
        unless $u && ref $u eq 'DW::External::User';

# FIXME: same as above
    return "$LJ::IMGPREFIX/silk/identity/user.png";
}

sub canonical_username {
    return LJ::canonical_username( $_[1] );
}

1;