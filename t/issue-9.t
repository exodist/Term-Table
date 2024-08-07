use warnings FATAL => 'all';
use strict;

BEGIN {
    if (eval { require Test2::Tools::Tiny }) {
        print "# Using Test2::Tools::Tiny\n";
        Test2::Tools::Tiny->import();
    }
    elsif (eval { require Test::More; Test::More->can('done_testing') ? 1 : 0 }) {
        print "# Using Test::More " . Test::More->VERSION . "\n";
        Test::More->import();
    }
    else {
        print "1..0 # SKIP Neither Test2::Tools::Tiny nor a sufficient Test::More is installed\n";
        exit(0);
    }
}

use Term::Table;

my @rows;
my @cols = 1..1;

push(@rows, \@cols) for 1..1;

my $table = Term::Table->new(max_width => 4, collapse => 0, rows => \@rows);
my @table;

my $ok = eval {
    local $SIG{ALRM} = sub { die "timeout" };
    alarm 5;
    @table = $table->render;
    1;
};

ok($@ !~ m/timeout/, "Did not timeout");
ok($@ =~ m/Table is too large \(9 including 4 padding\) to fit into max-width \(4\)/, "Threw proper exception");
ok(!@table, "Did not render");



$table = Term::Table->new(max_width => 4, collapse => 0, rows => \@rows, pad => 0);

$ok = eval {
    local $SIG{ALRM} = sub { die "timeout" };
    alarm 5;
    @table = $table->render;
    1;
};

ok($@ !~ m/timeout/, "Did not timeout");
ok($@ =~ m/Table is too large \(5 including 0 padding\) to fit into max-width \(4\)/, "Threw proper exception");
ok(!@table, "Did not render");



$table = Term::Table->new(max_width => 4, collapse => 0, rows => \@rows, allow_overflow => 1);

$ok = eval {
    local $SIG{ALRM} = sub { die "timeout" };
    alarm 5;
    @table = $table->render;
    1;
};

ok($ok, "Did not die");
ok($@ !~ m/timeout/, "Did not timeout");
ok(@table, "rendered");
ok(length($table[0]) == 5, "overflow in rendering");

done_testing;
