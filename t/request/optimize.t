use strict;
use warnings;

use Test::More tests => 22;
use Test::Mock::LWP::UserAgent;

use XML::Simple;

$Mock_ua->mock(
    request => sub {
        _test_req( @{ $_[ 1 ]->new_args } );
        return HTTP::Response->new;
    }
);

use_ok( 'WebService::Solr' );
my $solr = WebService::Solr->new;
isa_ok( $solr, 'WebService::Solr' );

my $opt;
for (
    {},
    { waitFlush => 'true',  waitSearcher => 'true' },
    { waitFlush => 'true',  waitSearcher => 'false' },
    { waitFlush => 'false', waitSearcher => 'true' },
    { waitFlush => 'false', waitSearcher => 'false' },
    )
{
    $opt = $_;
    $solr->optimize( $_ );
}

sub _test_req {
    is( $_[ 2 ]->path, '/solr/update', 'optimize() path' );
    is_deeply( { $_[ 2 ]->query_form }, { wt => 'json' }, 'optimize() params' );
    is_deeply(
        $_[ 3 ],
        [ 'Content_Type', 'text/xml; charset=utf-8' ],
        'optimize() headers'
    );
    my $struct = XMLin( $_[ 4 ], KeepRoot => 1 );
    is_deeply( $struct, { optimize => $opt }, 'optimize() xml' );
}
