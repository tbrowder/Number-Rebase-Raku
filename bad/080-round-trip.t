use Test;

use LibUUID;
use Number::Rebase :ALL;

my $debug = 0;

#plan 99;
plan 96;

# a UInt as input
my $hex  = "ffffffffffffffffffffffffffffffff";
my $hexn = 0xffffffffffffffffffffffffffffffff;
# note default alphabet for base 36 or less in Raku is upper case
#is $hex.chars, 32;

my ($val-out, $val-in, $bo, $bi);
#for $hex, $hexn -> $hex {
for $hex -> $hex {
$val-in  = $hex;
$bi = 16;
$bo = 10;
lives-ok {
    $val-out = str2num $val-in, $bi;
    note "DEBUG: val-in  = '$val-in'; base $bi" if $debug;
    note "       val-out = '$val-out'; base $bo'";
}

$val-in = $val-out;
($bi, $bo) = ($bo, $bi);
lives-ok {
    $val-out = num2str $val-in, 16;
    note "DEBUG: val-in  = '$val-in'; base 10" if $debug;
    note "       val-out = '$val-out'; base 16'";
}

is $val-out, $hex.uc;
}

#=finish

lives-ok {
    my $val = rebase $hex, 16, 65;
    note "DEBUG: val = '$val'" if $debug;
}
lives-ok {
    my $val = rebase $hex, 16, 91;
    note "DEBUG: val = '$val'" if $debug;
}

#=finish

#=begin comment
# base 64 is causing trouble
# char is '#'
# decimal value is 63

lives-ok {
    my $val = rebase $hex, 16, 64;
    note "DEBUG: val = '$val'" if $debug;
}
#=end comment
#done-testing

#=finish

for 2..15 -> $base-o {
    lives-ok {
	my $x = rebase $hex, 16, $base-o;
        note "DEBUG: base-o = $base-o; x = '$x'" if $debug;
	rebase $hex, 16, $base-o;
    }
}

for 17..63 -> $base-o {
    lives-ok {
	my $x = rebase $hex, 16, $base-o;
        note "DEBUG: base-o = $base-o; x = '$x'" if $debug;
    }
}

for 65..91 -> $base-o {
    lives-ok {
	my $x = rebase $hex, 16, $base-o;
        note "DEBUG: base-o = $base-o; x = '$x'" if $debug;
    }
}

my $uuid = UUID.new.Str;
my $nc = $uuid.chars;
#say "DEBUG uuid: '$uuid', chars: $nc" if $debug; #  > 1;
# remove hyphens
$uuid ~~ s:g/'-'//;
$nc = $uuid.chars;
#say "DEBUG2 uuid: '$uuid', chars: $nc" if $debug; # > 1;
# convert to base 91

lives-ok {
    $uuid = rebase $uuid, 16, 91;
}

#$uuid = rebase $uuid, 16, 62;
$nc = $uuid.chars;
#say "DEBUG3 uuid: '$uuid', chars: $nc" if $debug; # > 1;
#return $uuid;

# from a bug:
$hex = 'e90cdff8d6714c529efead7dfea22262';

lives-ok {
    $hex = rebase $hex, 16, 62, 22;
}
