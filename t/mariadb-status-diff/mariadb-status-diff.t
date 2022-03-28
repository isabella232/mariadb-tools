#!/usr/bin/env perl

BEGIN {
   die "The PERCONA_TOOLKIT_BRANCH environment variable is not set.\n"
      unless $ENV{PERCONA_TOOLKIT_BRANCH} && -d $ENV{PERCONA_TOOLKIT_BRANCH};
   unshift @INC, "$ENV{PERCONA_TOOLKIT_BRANCH}/lib";
};

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);
use Test::More;

use PerconaTest;

like(
   `$trunk/bin/mariadb-status-diff 2>&1`,
   qr/Usage:/,
   'It runs'
);

my $cmd    = "$trunk/bin/mariadb-status-diff";
my $sample = "$trunk/t/mariadb-status-diff/samples";

ok(
   no_diff(
      "$cmd -- cat $sample/mext-001.txt",
      "t/mariadb-status-diff/samples/mext-001-result.txt",
      post_pipe => "LANG=C sort -k1,1",
   ),
   "mext-001"
) or diag($test_diff);

ok(
   no_diff(
      "$cmd -r -- cat $sample/mext-002.txt",
      "t/mariadb-status-diff/samples/mext-002-result.txt",
      post_pipe => "LANG=C sort -k1,1",
   ),
   "mext-002 -r"
) or diag($test_diff);

ok(
   no_diff(
      "$cmd -- cat $sample/pt-130-in.txt",
      "t/mariadb-status-diff/samples/pt-130-out.txt",
   ),
   "having rsa key",
) or diag($test_diff);

# #############################################################################
# Done.
# #############################################################################
done_testing;
exit;