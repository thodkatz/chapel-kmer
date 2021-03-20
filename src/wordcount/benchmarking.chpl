/**
 * A naive implementation of word counting in Chapel.
 * Benchmarking the serial and parallel versions of Chapel for proof of concept
 */
module Benchmarking {
    use WordSerial;
    use WordParallel;
    use IO;
    use Map;

    writeln("Let's start with the kmer counting problem");
    config const path = "words.txt";

    proc main() {
        var text = try! readString(path);
        var m : map = WordSerial.counting(text);
        try! writeMap(m);
    }

    // read "file.txt" (lorem) and convert it to unified string
    proc readString(path : string) : string throws {
        var file = open("words.txt", iomode.r);

        var text : string;
        for line in file.lines() {
            text += line;
        }

        file.close();
        return text;
    }

    proc writeMap(m : map) throws {
        var outputFile = open("output.txt", iomode.cw);
        var writer = outputFile.writer();

        for pair in m.items() {
            var (key, value) = pair;
            writer.writeln(key,":",value);
        }

        writer.close();
        outputFile.close();
    }
}