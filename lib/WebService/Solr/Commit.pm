package WebService::Solr::Commit;
use XML::Generator;
use Tie::IxHash;
use strict;
use warnings;

sub new {
    my ( $class, $options ) = @_;

    my $self = { opts => $options, };

    bless $self, $class;
    return $self;
}
1;

sub to_xml {
    my $self = shift;
    my $opts = $self->{ opts };
    die "Expected hash reference for WebService::Solr::Commit->toString "
        unless ref( $opts ) eq "HASH";

    #my %optshash = %$opts;
    my $gen = XML::Generator->new();
    tie my %attr, 'Tie::IxHash';
    my $waitFlush    = $opts->{ 'waitFlush' };
    my $waitSearcher = $opts->{ 'waitSearcher' };
    %attr = (
        waitFlush    => $waitFlush,
        waitSearcher => $waitSearcher,
    );
    my $func = $gen->commit( \%attr );
    return "$func";

}
