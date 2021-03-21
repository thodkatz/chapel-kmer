/**
 * A naive implementation of word counting in Chapel.
 * Benchmarking the serial and parallel versions of Chapel for proof of concept
 */
module Benchmarking {
    use WordSerial;
    use WordParallel;
    use IO;
    use Map;
    use Time;

    writeln("Let's start with word counting!");
    config const path = "words.txt";
    config const debug = true;

    proc main() {
        var text = try! readString(path);
        var timer : Timer;

        timer.start();
        var mapSerial : map = WordSerial.counting(text);
        timer.stop();
        if (debug) then writeln("Time: ", timer.elapsed());

        try! writeMap(mapSerial, "output_serial.txt");

        // timer.start();
        // var mapParallel : map = WordParallel.counting(text);
        // timer.stop();
        // try! writerMap(mapParallel, "output_parallel.txt");
    }

    // read "file.txt" (lorem) and convert it to unified string
    proc readString(path : string) : string throws {
        var file = open("words.txt", iomode.r);

        // TODO: remove pound and commas
        var text : string;
        for line in file.lines() {
            text += line;
        }

        file.close();
        return text;
    }

    proc writeMap(m : map, name : string) throws {
        var outputFile = open(name, iomode.cw);
        var writer = outputFile.writer();

        writer.writeln("word:count");
        for pair in m.items() {
            var (key, value) = pair;
            writer.writeln(key, ":" ,value);
        }

        writer.close();
        outputFile.close();
    }
}