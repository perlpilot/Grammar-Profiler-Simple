my %timing;

my class ProfiledGrammarHOW is Metamodel::GrammarHOW is Mu {

    method find_method($obj, $name) {
        my $meth := callsame;
        substr($name, 0, 1) eq '!' || $name eq any(<parse CREATE Bool defined MATCH>) ??
            $meth !!
            -> $c, |$args {
                %timing{$meth.name} //= {};
                my $start = now;
                my $result := $meth($obj, |$args);
                %timing{$meth.name}<time> += now - $start;
                %timing{$meth.name}<calls>++;
                $result
            }
    }

    method publish_method_cache($obj) {
        # no caching, so we always hit find_method
    }
}

sub get_timing () is export { %timing }

my module EXPORTHOW { }
EXPORTHOW.WHO.<grammar> = ProfiledGrammarHOW;
