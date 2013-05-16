my %timing;

my class ProfiledGrammarHOW is Metamodel::GrammarHOW {

    method find_method($obj, $name) {
        my $meth := callsame;
        substr($name, 0, 1) eq '!' ||
        substr($name, 0, 8) eq 'dispatch' || 
        $name eq any(« parse CREATE Bool defined MATCH Stringy Str WHERE orig ») ??
            $meth !!
            -> $c, |args {
                my $grammar = $obj.^name;
                %timing{$grammar} //= {};                   # Vivify grammar hash
                %timing{$grammar}{$meth.name} //= {};       # Vivify method hash
                my %t := %timing{$grammar}{$meth.name};
                my $start = now;
                my $result := $meth($obj, |args);
                %t<time> += now - $start;
                %t<calls>++;
                $result
            }
    }

    method publish_method_cache($obj) {
        # no caching, so we always hit find_method
    }
}

multi sub get-timing () is export { %timing }
multi sub get-timing ($grammar) is export { %timing{$grammar} }
multi sub get-timing ($grammar, $rule) is export { %timing{$grammar}{$rule} }

multi sub reset-timing () is export { %timing = () }
multi sub reset-timing ($grammar) is export { %timing{$grammar} = () }
multi sub reset-timing ($grammar, $rule) is export { %timing{$grammar}{$rule} = () }

my module EXPORTHOW { }
EXPORTHOW.WHO.<grammar> = ProfiledGrammarHOW;
