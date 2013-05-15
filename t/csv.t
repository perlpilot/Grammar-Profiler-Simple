#!/usr/bin/env perl6

#use Test;
use Grammar::Profiler::Simple;

grammar CSV {
    token TOP { ^ <line>* $ }
    token line { ^^ <csv> <ws> $$ }
    token csv { <value>* % ',' }
    token value { <-[,]>+ }
}

my @strings = ( "alpha", "alpha,beta,gamma,delta" );
#plan(+@strings);

for @strings -> $str {
    my $match = CSV.parse($str);
#    my %t = get-timing;
#    ok(?$match);
#    say ~%t;
    say ?$match ?? "yes" !! "no";
}

