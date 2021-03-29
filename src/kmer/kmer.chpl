module KMER {
  use Map;
  use IO;

  config const numTasks = here.maxTaskPar;
  config const verbose = true;

  // REQUIRES a linearized fasta file format
  // this can be created via "make fasta FASTA=<file>"
  iter sequenceSerial(file, k : int) throws {
    // skip first line
    var firstLine : string;
    (file.reader()).readline(firstLine);
    var offset = firstLine.size;
    var kmerTotal = (file.size - offset) - k + 1;
    kmerTotal -= 1; // substract the new line at the end of the sequence

    for i in offset..#kmerTotal {
      var kmer : string;
      (file.reader(iokind.dynamic, true, i, i + k)).readstring(kmer);
      yield kmer;
    }
  }

  // get a file and create a kmer iterator
  // archived because it is missing the kmer between 
  // the lines
  iter sequenceSerialArchived(file, k : int) throws {
    // skip first line
    var firstLine : string;
    (file.reader()).readline(firstLine);

    for i in file.lines(true,firstLine.size) {
      var line = i.strip("\n");
      var size = line.size - k + 1;
      for j in 0..#size {
        yield line[j..j+k-1];
      }
    }
  }

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

  proc countingSerial2(file, k : int) : map throws {
    writeln("Serial version 2");
    var countTable = new map(string, int, parSafe = false);

    for kmer in sequenceSerialArchived(file, k) {
      if(countTable.contains(kmer)) then 
        countTable.set(kmer, countTable[kmer] + 1);
      else 
        countTable.add(kmer, 1);
    }

    return countTable;
  }

  proc countingSerial3(file, k : int) : map throws {
    writeln("Serial version 3");
    var countTable = new map(string, int, parSafe = false);

    for kmer in sequenceSerial(file, k) {
      if(countTable.contains(kmer)) then 
        countTable.set(kmer, countTable[kmer] + 1);
      else 
        countTable.add(kmer, 1);
    }

    return countTable;
  }

  // todo: Implement a compare and swap parallel technique
  proc countingParallel(file, k : int) : map throws {
    writeln("Parallel version");
    var countTable = new map(string, int, parSafe = true);

    iter sequence(file, k : int){}; // standalone iterator required for the parallel iterator
    iter sequence(param tag: iterKind, file, k : int) throws
      where tag == iterKind.standalone {
        if verbose then
          writeln("Standalone parallel count() is creating ", numTasks, " tasks");

        var firstLine : string;
        (file.reader()).readline(firstLine);
        var offset = firstLine.size;
        var kmerTotal = (file.size - offset) - k + 1;
        kmerTotal -= 1; // substract the new line at the end of the sequence

        var low = offset;
        var high = kmerTotal; 
        writeln((low,high));
        coforall tid in 0..#numTasks {
          const myIters = computeChunk(low..#high, tid, numTasks);

          if verbose then
            writeln("task ", tid, " owns ", myIters);

          for i in myIters {
            var kmer : string;
            (file.reader(iokind.dynamic, true, i, i + k)).readstring(kmer);
            yield kmer;
          }
        }
      }

    forall kmer in sequence(file,k) with (ref countTable) {
      if(countTable.contains(kmer)) then
        countTable.set(kmer, countTable.getValue(kmer) + 1);
      else
        countTable.add(kmer, 1);
    }

        return countTable;
  }

  proc computeChunk(r: range, myChunk, numChunks) where r.stridable == false {
    const numElems = r.size;
    const elemsperChunk = numElems/numChunks;
    const rem = numElems%numChunks;
    var mylow = r.low;
    if myChunk < rem {
      mylow += (elemsperChunk+1)*myChunk;
      writeln(mylow..#(elemsperChunk+1));
      return mylow..#(elemsperChunk+1);
    } else {
      mylow += ((elemsperChunk+1)*rem + (elemsperChunk)*(myChunk-rem));
      writeln(mylow..#elemsperChunk);
      return mylow..#elemsperChunk;
    }
  }
}
