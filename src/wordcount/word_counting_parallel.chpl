/**
 * A naive implementation of word counting in Chapel.
 * Parallel verison
 */
module WordParallel {
  use Map;
  use Types;

  record r { var x : int = 0; }

  record Updater {
    proc this(const key, ref val) {
      val.x +=1;
      return none;
    }
  }

  proc counting_v0(text : string) : map throws {
    var kmerHash : map(string, r, true);
    //var kmerHash : map(string, int, false);

    var sequence = forall word in text.split(' ') do word.strip().strip(",.");

    forall word in sequence with (ref kmerHash) {
      if (kmerHash.contains(word)) then {
        kmerHash.update(word, new Updater());
      }
      else {
        kmerHash.add(word, new r(1));
      }
    }
    return kmerHash;
  }

  proc counting_v1(text : string) : map throws {
    var kmerHash : map(string, int, true);
    //var kmerHash : map(string, int, false);

    var sequence = forall word in text.split(' ') do word.strip().strip(",.");

    // using locks basically kills performance
    // we need to use compare and swap technique
    // implementing a custom data dictionairy
    forall word in sequence with (ref kmerHash) {
      if (kmerHash.contains(word)) then {
        kmerHash.set(word, kmerHash.getValue(word) + 1);
      }
      else {
        kmerHash.add(word, 1);
      }
    }
    return kmerHash;
  }
}
