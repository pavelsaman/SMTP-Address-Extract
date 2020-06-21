package SMTP::Address::Extract;

use 5.030002;
use strict;
use warnings;
use Readonly;

use Exporter 'import';
our @EXPORT_OK = qw(addresses aliases parse);
our %EXPORT_TAGS = (
    all  => \@EXPORT_OK,
    ALL  => \@EXPORT_OK,
    test => \@EXPORT_OK,
    TEST => \@EXPORT_OK,
);

our $VERSION = 0.001;

###############################################################################

Readonly my $SMTP_ADDRESS_FORMAT => qr{    
    [<]
    \s* # possible white characters
    (
     # before '@'
     \S+
     [@]
     # after '@'
     (?: # do not capture
      # has to contain '.' and domain, could be repeated (e.g. 'co.uk')
      \S+
      [.]
      \S+
     ){1,} 
    )
    \s* # possible white characters
    [>]    
}xms;

Readonly my $ALIAS_FORMAT => qr{    
    (
     \w+
     \s?
     \w+
    )
    \s*
    [<]      
}xms;

sub addresses {
    my $str = shift;

    my @addresses = $str =~ m{$SMTP_ADDRESS_FORMAT}xmsg;

    return @addresses;
}

sub aliases {
    my $str = shift;

    my @aliases = $str =~ m{$ALIAS_FORMAT}xmsg;

    return @aliases;
}

sub parse {
    my $str = shift;

    my @addresses = addresses($str);
    my @aliases   = aliases($str);

    my @addr_aliases = ();

    for my $i (0..scalar @addresses - 1) {
        push @addr_aliases, { addr => $addresses[$i], alias => $aliases[$i] };
    }

    return @addr_aliases;
}

1;

__END__
