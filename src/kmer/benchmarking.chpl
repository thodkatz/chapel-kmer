module Benchmarking {
  use KMER;
  use Time;
  use Map;
  use IO;

  config const k : int = 3;
  config const pathFasta = "linear.fasta";
  config const probSize = 15;

  proc main() {
    var timer : Timer;
    var bioSequence : string = try! readBioSequence(pathFasta);
    var file = try! open(pathFasta, iomode.r);

    timer.start();
    var countTableSerial = try! KMER.countingSerial(bioSequence, k);
    timer.stop();
    writeln("Time elasped: ", timer.elapsed());

    try! writeMap(countTableSerial, "kmer_serial.txt");

    timer.clear();
    timer.start();
    var countTableSerial2 = try! KMER.countingSerial2(file, k);
    timer.stop();
    writeln("Time elasped: ", timer.elapsed());

    try! writeMap(countTableSerial2, "kmer_serial2.txt");

    timer.clear();
    timer.start();
    var countTableSerial3 = try! KMER.countingSerial3(file, k);
    timer.stop();
    writeln("Time elasped: ", timer.elapsed());

    try! writeMap(countTableSerial2, "kmer_serial3.txt");

    timer.clear();
    timer.start();
    var countTableParallel = try! KMER.countingParallel(file, k);
    timer.stop();
    writeln("Time elasped: ", timer.elapsed());

    try! writeMap(countTableParallel, "kmer_parallel.txt");
  }

  // naive reading sequence
  // not memory efficient
  proc readBioSequence(path : string) throws {
    var bioSequence : string = "ATCGATCACATCGATCAC";

    var file = open(path, iomode.r);
    var text : string;
    var firstLine : string;
    (file.reader()).readline(firstLine);

    for line in file.lines(true,firstLine.size) do
      text += line.strip("\n"); 

    file.close();
    return text;
  }

  proc writeMap(m : map, path : string) throws {
    var outputFile = open(path, iomode.cw);
    var writer = outputFile.writer();

    writer.writeln("kmer:count");
    for pair in m.items() {
      var(key, value) = pair;
      writer.writeln(key, ":", value);
    }

    writer.close();
    outputFile.close();
  }
}
