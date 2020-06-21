use Test::More tests => 1;
use Test::Perl::Critic (-severity => 2);

###############################################################################

subtest 'Perl Critic' => sub {
    critic_ok("lib/SMTP/Address/Extract.pm");
};
