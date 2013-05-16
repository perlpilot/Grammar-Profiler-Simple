#!/usr/bin/env perl6

#use Test;
use Grammar::Profiler::Simple;

grammar CSV {
    token TOP { ^ <line>+ % "\n" $ }
    token line { <value>+ % ',' }
    token value { <-[,]>+ }
}

my @strings = ( 
    "", 
    "alpha", 
    "alpha,beta,gamma,delta",
    "a\nb\nc",
    "a,b,c\ne,f\n,g,h,i",
);
#plan(+@strings);

for @strings -> $str {
    my $match = CSV.parse($str);
    say (?$match ?? "MATCH" !! "no match") ~ " '$str'";
    my %t = get-timing;
    say ~%t;
}

