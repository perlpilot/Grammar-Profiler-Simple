my %timing;

my class ProfiledGrammarHOW is Metamodel::GrammarHOW is Mu {

    method find_method($obj, $name) {
        my $meth := callsame;
        substr($name, 0, 1) eq '!' || $name eq any(<parse CREATE Bool defined MATCH WHAT gist>) ??
            $meth !!
            -> $c, |$args {
                my $grammar = $obj.WHAT.gist;
                %timing{$grammar} //= {};                   # Vivify grammar hash
                %timing{$grammar}{$meth.name} //= {};       # Vivify method hash
                my %t := %timing{$grammar}{$meth.name};
                my $start = now;
                my $result := $meth($obj, |$args);
                %t<time> += now - $start;
                %t<calls>++;
                $result
            }
    }

    method publish_method_cache($obj) {
        # no caching, so we always hit find_method
    }
}

sub get-timing () is export { %timing }
sub reset-timing () is export { %timing = () }

my module EXPORTHOW { }
EXPORTHOW.WHO.<grammar> = ProfiledGrammarHOW;
