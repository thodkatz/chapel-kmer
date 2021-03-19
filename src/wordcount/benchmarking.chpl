/**
 * A naive implementation of word counting in Chapel.
 * Benchmarking the serial and parallel versions of Chapel for proof of concept
 */
module Benchmarking {
    writeln("Let's start with the kmer counting problem");
    use WordSerial;
    use WordParallel;
    use IO;

    proc main() {
        WordSerial.counting();
    }

    proc readString() {

    }
}