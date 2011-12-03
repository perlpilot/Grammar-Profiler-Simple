# Grammar::Profiler::Simple
This module provides a simple profiler for Perl 6 gramamrs. To enable
profiling simply add

    use Grammar::Profiler::Simple;

to your code. Any grammar in the lexical scope of the use statement
will automatically have profiling information collected when the
grammar is used.

This module exports two subroutines

- get-timing        retrieve the timing information collected so far
- reset-timing      reset the timing information to zero



