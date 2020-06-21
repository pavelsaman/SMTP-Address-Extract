use strict;
use warnings;
use Test::More qw(no_plan);

use SMTP::Address::Extract qw(:test);

###############################################################################

subtest 'Compile Module' => sub {
    use_ok('SMTP::Address::Extract');
};

###############################################################################
# addresses()

subtest 'Return SMTP Address' => sub {
    my $test_data        = q{Pavel Saman <pavelsam@centrum.cz>};
    my @expected_outcome = (q{pavelsam@centrum.cz});

    my @result = addresses($test_data);
    is(scalar @result, 1);
    is($result[0], $expected_outcome[0]);
};

subtest 'Return SMTP Address - More Domains' => sub {
    my $test_data        = q{Pavel Saman <pavelsam@centrum.co.uk>};
    my @expected_outcome = (q{pavelsam@centrum.co.uk});

    my @result = addresses($test_data);
    is(scalar @result, 1);
    is($result[0], $expected_outcome[0]);
};

subtest 'Return SMTP Address - Dots In From Of @' => sub {
    my $test_data        = q{Pavel Saman <pavel.sam@centrum.co.uk>};
    my @expected_outcome = (q{pavel.sam@centrum.co.uk});

    my @result = addresses($test_data);
    is(scalar @result, 1);
    is($result[0], $expected_outcome[0]);
};

subtest 'Return SMTP Address - White Chars' => sub {
    my $test_data        = q{Pavel Saman < pavelsam@centrum.cz   >};
    my @expected_outcome = (q{pavelsam@centrum.cz});

    my @result = addresses($test_data);
    is(scalar @result, 1);
    is($result[0], $expected_outcome[0]);
};

subtest 'Return SMTP Addresses' => sub {
    my $test_data        
        = q{Pavel Saman <pavelsam@centrum.cz>; ABC <abc@abc.com>};
    my @expected_outcome = (q{pavelsam@centrum.cz}, q{abc@abc.com});

    my @result = addresses($test_data);
    my @first  = grep { $_ eq $expected_outcome[0] } @result;
    my @second = grep { $_ eq $expected_outcome[1] } @result;

    is(scalar @result, 2);
    is(scalar @first,  1);
    is(scalar @second, 1);
    is($first[0],  $expected_outcome[0]);
    is($second[0], $expected_outcome[1]);
};

###############################################################################
# aliases()

subtest 'Return Alias' => sub {
    my $test_data        = q{Pavel Saman <pavelsam@centrum.cz>};
    my @expected_outcome = (q{Pavel Saman});

    my @result = aliases($test_data);
    is(scalar @result, 1);
    is($result[0], $expected_outcome[0]);
};

subtest 'Return Aliases' => sub {
    my $test_data        
        = q{Pavel Saman <pavelsam@centrum.cz>; ABC <abc@centrum.cz>};
    my @expected_outcome = (q{Pavel Saman}, q{ABC});

    my @result = aliases($test_data);
    my @first  = grep { $_ eq $expected_outcome[0] } @result;
    my @second = grep { $_ eq $expected_outcome[1] } @result;

    is(scalar @result, 2);
    is(scalar @first,  1);
    is(scalar @second, 1);
    is($first[0],  $expected_outcome[0]);
    is($second[0], $expected_outcome[1]);
};

###############################################################################
# parse()

subtest 'Return Addr And Alias' => sub {
    my $test_data        = q{Pavel Saman <pavelsam@centrum.cz>};
    my @expected_outcome = ({
        addr  => q{pavelsam@centrum.cz},
        alias => q{Pavel Saman}
    });

    my @result = parse($test_data);
    is(scalar @result, 1);
    is($result[0]->{addr},  $expected_outcome[0]->{addr});
    is($result[0]->{alias}, $expected_outcome[0]->{alias});
};

subtest 'Return Addresses And Aliases' => sub {
    my $test_data        
        = q{Pavel Saman <pavelsam@centrum.cz>; ABC <abc@centrum.cz>};
    my @expected_outcome = (
        {
            addr  => q{pavelsam@centrum.cz},
            alias => q{Pavel Saman}
        },
        {
            addr  => q{abc@centrum.cz},
            alias => q{ABC}
        }
    );

    my @result = parse($test_data);
    my @first  = grep { $_->{addr} eq $expected_outcome[0]->{addr} } @result;
    my @second = grep { $_->{addr} eq $expected_outcome[1]->{addr} } @result;

    is(scalar @result, 2);
    is(scalar @first,  1);
    is(scalar @second, 1);
    is($first[0]->{addr},   $expected_outcome[0]->{addr});
    is($first[0]->{alias},  $expected_outcome[0]->{alias});
    is($second[0]->{addr},  $expected_outcome[1]->{addr});
    is($second[0]->{alias}, $expected_outcome[1]->{alias});
};
