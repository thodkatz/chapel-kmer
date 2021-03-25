module KMER {
  use Map;

  proc countingSerial(bioSequence : string, k : int) : map {
    writeln("Serial version");

    assert(k < bioSequence.size);
    var size : int = bioSequence.size - k + 1;

    var countTable = new map(string, int, parSafe = false);

    for i in 0..#size {
      var kmer : string = bioSequence[i..i+k-1];
      if(countTable.contains(kmer)) then 
        countTable.set(kmer, countTable[kmer] + 1);
      else 
        countTable.add(kmer, 1);
    }

    return countTable;
  }

  proc countingParallel(bioSequence : string, k : int) : map {
    writeln("Parallel version");

    assert(k < bioSequence.size);
    var size : int = bioSequence.size - k + 1;

    var countTable = new map(string, int, parSafe = true);

    forall i in 0..#size with (ref countTable) {
      var kmer : string = bioSequence[i..i+k-1];
      if(countTable.contains(kmer)) then 
        countTable.set(kmer, countTable.getValue(kmer) + 1);
      else 
        countTable.add(kmer, 1);
    }

    return countTable;
  }
}
