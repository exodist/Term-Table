package Term::Table::Spacer;
use strict;
use warnings;

sub new { bless {}, $_[0] }

sub width { 1 }

sub sanitize  { }
sub mark_tail { }
sub reset     { }

1;
