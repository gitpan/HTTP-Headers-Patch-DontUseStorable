package HTTP::Headers::Patch::DontUseStorable;

use 5.010001;
use strict;
no warnings;
#use Log::Any '$log';

use Module::Patch 0.12 qw();
use base qw(Module::Patch);

our $VERSION = '0.03'; # VERSION

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

version 0.03

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

=head2 Is this a bug with HTTP::Headers? Why don't you submit a bug to HTTP-Message?

I tend not to think this is a bug with HTTP::Headers; after all, Storable's
dclone() is a pretty standard way to clone data in Perl. This patch is more of a
workaround for current Storable's deficiencies.

=head2 Shouldn't you add STORABLE_{freeze,thaw} methods to Regexp instead?

Yes, that's also one possible solution, albeit with slightly more work. There's
an old distribution, L<Regexp::Copy> (last release is 0.06 in 2003, at the time
of this writing) which does this, but last time I tried it no longer works.

=head1 SEE ALSO

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

