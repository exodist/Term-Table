use strict;
use warnings;

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
use Term::Table::Cell;

# This example was produced from the end result of another process, the end
# result is reproduced here in shortcuts:

chomp(my $inner = <<EOT);
+------+-----+-----+-------+--------+
| PATH | GOT | OP  | CHECK | LINES  |
+------+-----+-----+-------+--------+
| [0]  | x   | ANY |> ... <| 26, 30 |
|      |     |     | a     | 27     |
|      |     |     | b     | 28     |
|      |     |     | c     | 29     |
+------+-----+-----+-------+--------+
EOT

my $rows = [[
        '',
        '',
        bless({'value' => $inner},     'Term::Table::Cell'),
        bless({'value' => 'eq'},       'Term::Table::Cell'),
        bless({'value' => ""}, 'Term::Table::Cell'),
        '',
        bless({'value' => '67'}, 'Term::Table::Cell'),
        ''
    ],
];

my $table = Term::Table->new(
    collapse    => 1,
    sanitize    => 1,
    mark_tail   => 1,
    show_header => 1,
    term_size => 80,
    header      => [qw/PATH LINES GOT OP CHECK * LINES NOTES/],
    no_collapse => [qw/GOT CHECK/],
    rows        => $rows,
);

is_deeply(
    [ $table->render ],
    [
        '+-----------------------------------------+----+-------+-------+',
        '| GOT                                     | OP | CHECK | LINES |',
        '+-----------------------------------------+----+-------+-------+',
        '| +------+-----+-----+-------+--------+\n | eq |       | 67    |',
        '| | PATH | GOT | OP  | CHECK | LINES  |\n |    |       |       |',
        '| +------+-----+-----+-------+--------+\n |    |       |       |',
        '| | [0]  | x   | ANY |> ... <| 26, 30 |\n |    |       |       |',
        '| |      |     |     | a     | 27     |\n |    |       |       |',
        '| |      |     |     | b     | 28     |\n |    |       |       |',
        '| |      |     |     | c     | 29     |\n |    |       |       |',
        '| +------+-----+-----+-------+--------+   |    |       |       |',
        '+-----------------------------------------+----+-------+-------+',
    ],
    "Table looks right"
);

print map { "$_\n" } $table->render;

done_testing;
