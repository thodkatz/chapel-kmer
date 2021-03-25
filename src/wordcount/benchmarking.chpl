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
  config const path = "sample-2mb-text-file.txt";
  config const benchmark = true;

  proc main() {
    var text = try! readString(path);
    var timer : Timer;

    timer.start();
    var mapSerial : map = WordSerial.counting_v0(text);
    timer.stop();
    if (benchmark) then writeln("Time: ", timer.elapsed());
    try! writeMap(mapSerial, "word_count_serial.txt");

    timer.clear();

    timer.start();
    var mapParallel : map = try! WordParallel.counting_v0(text);
    timer.stop();
    if (benchmark) then writeln("Time: ", timer.elapsed());
    try! writeMap(mapParallel, "word_count_parallel.txt");
  }

  // read "file.txt" (lorem) and convert it to unified string
  proc readString(path : string) : string throws {
    var file = open(path, iomode.r);
    var text : string;

    for line in file.lines() { 
      // text += line.strip().strip("."); 
      text += line.strip("\n"); 
      text += " ";
    }

    file.close();
    return text;
  }

  proc writeMap(m : map, path : string) throws {
    var outputFile = open(path, iomode.cw);
    var writer = outputFile.writer();

    writer.writeln("word:count");
    for pair in m.items() {
      var(key, value) = pair;
      writer.writeln(key, ":", value);
    }

    writer.close();
    outputFile.close();
  }
}
