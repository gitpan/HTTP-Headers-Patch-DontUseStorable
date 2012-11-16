package HTTP::Headers::Patch::DontUseStorable;

use 5.010001;
use strict;
no warnings;
#use Log::Any '$log';

use Module::Patch 0.12 qw();
use base qw(Module::Patch);

our $VERSION = '0.02'; # VERSION

our %config;

sub _clone($) {
    my $self = shift;
    my $clone = HTTP::Headers->new;
    $self->scan(sub { $clone->push_header(@_);} );
    $clone;
}

sub patch_data {
    return {
        v => 3,
        patches => [
            {
                action => 'replace',
                mod_version => qr/^6\.0.+/,
                sub_name => 'clone',
                code => \&_clone,
            },
        ],
    };
}

1;
# ABSTRACT: Do not use Storable


__END__
=pod

=head1 NAME

HTTP::Headers::Patch::DontUseStorable - Do not use Storable

=head1 VERSION

version 0.02

=head1 SYNOPSIS

 use HTTP::Headers::Patch::DontUseStorable;

=head1 DESCRIPTION

HTTP::Headers (6.05 as of this writing) tries to load L<Storable> (2.39 as of
this writing) and use its dclone() method. Since Storable still does not support
serializing Regexp objects, HTTP::Headers/L<HTTP::Message> croaks when fed data
with Regexp objects.

This patch avoids using Storable and clone using the alternative method.

=for Pod::Coverage ^(patch_data)$

=head1 FAQ

=head1 SEE ALSO

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

