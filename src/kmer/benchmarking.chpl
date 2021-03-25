module TEST {
  use KMER;
  use Time;
  use Map;
  use IO;

  config const k : int = 3;

  proc main() {
    var timer : Timer;
    var bioSequence : string = readBioSequence("path.txt");

    //var countTableSerial = new map(string, int);
    timer.start();
    var countTableSerial = KMER.countingSerial(bioSequence, k);
    timer.stop();
    writeln("Time elasped: ", timer.elapsed());

    try! writeMap(countTableSerial, "kmer_serial.txt");

    timer.clear();

    //var countTableParallel = new map(string, int, true);
    timer.start();
    var countTableParallel = KMER.countingParallel(bioSequence, k);
    timer.stop();
    writeln("Time elasped: ", timer.elapsed());

    try! writeMap(countTableParallel, "kmer_parallel.txt");
  }

  // todo: read fasta files
  proc readBioSequence(path : string) {
    var bioSequence : string = "ATCGATCACATCGATCAC";

    return bioSequence;
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
