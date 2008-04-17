package XMLRPC::Lite::UpdatePing;

use 5.008008;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use XMLRPC::Lite::UpdatePing ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

use Encode;
use XMLRPC::Lite;

sub new {
    my $class = shift;
    bless { ping_servers => [
        'http://blogsearch.google.com/ping/RPC2',
        'http://www.blogpeople.net/servlet/weblogUpdates',
        'http://rpc.technorati.com/rpc/ping',
    ], }, $class;
}

sub ping_servers {
    my $self = shift;
    return $self->{ping_servers};
}

sub add_ping_server {
    my $self = shift;
    my $new_ping_server = shift;
    push @{$self->{ping_severs}}, $new_ping_server;
    return $self;
}

sub ping {
    my $self = shift;
    my $feed_uris = shift;
    my ($all_res, $recent_res) = ('', '');
    for my $feed_name ( keys %{$feed_uris} ) {
        for my $ping_server_uri (@{$self->ping_servers}) {
            $recent_res = &_send_ping(
                rpc       => $ping_server_uri,
                site_name => encode('eucjp', $feed_name),
                feed_uri  => $$feed_uris{$feed_name},
            );
            $all_res .= &_as_string($recent_res) if defined $recent_res;
        }
    }
    return $all_res;
}

sub _send_ping {
    my %arg = @_;
    my $rpc_uri   = $arg{rpc};
    my $site_name = $arg{site_name};
    my $feed_uri  = $arg{feed_uri};

    if ( ! defined $rpc_uri || $rpc_uri !~ m/^http/ ) {
        return { flerror => 0,
                 message => 'local echo mode',
                 name    => $site_name,
                 uri     => $feed_uri,   };
    }

    my $result = XMLRPC::Lite->proxy($rpc_uri)
                     ->call( 'rssfeed.updatePing', $site_name, $feed_uri, )
                     ->result ;
    return $@ if $@;
    return (defined $result) ? $result : { 'flerror' => 'none', 'message' => 'none' };
}

sub _as_string {
    my $input = shift;
    if (not ref $input) {
        return $input;
    } elsif (ref $input eq 'SCALAR') {
        return $$input;
    } elsif (ref $input eq 'ARRAY') {
        return join("<br />\n", @$input);
    } elsif (ref $input eq 'HASH') {
        my $return = '';
        for my $key (sort keys %$input) {
            $return .= "$key => $input->{$key}<br />\n";
        }
        return $return;
    } else {
        return 'unknown data format';
    }
}

1;
__END__

=head1 NAME

XMLRPC::Lite::UpdatePing - send update-ping easily with XMLRPC::Lite

=head1 SYNOPSIS

  use XMLRPC::Lite::UpdatePing;

  my $your_rssfeeds = ( 'example1' => 'http://example.com/rss.xml',
                        'example2' => 'http://yet.another.com/rss2', );

  my $result = XMLRPC::Lite::UpdatePing->ping($your_rssfeeds);

 
=head1 DESCRIPTION

XMLRPC::Lite::UpdatePing is a Perl modules that you can send update-ping to ping servers so easily.

=head2 DEPENDENCIES

XMLRPC::Lite

=head1 SEE ALSO

XMLRPC::Lite

=head1 AUTHOR

Kazuhiro Sera, E<lt>webmaster@seratch.ath.cxE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Kazuhiro Sera

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
