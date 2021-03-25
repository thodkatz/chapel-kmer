/**
 * A naive implementation of word counting in Chapel.
 * Parallel verison
 */
module WordParallel {
  use Map;
  use Types;

  proc counting(text : string) : map {
    writeln("Parallel version initiated");

    var m : map(string, int, true);

    for word in text.split(' ') {
      var stripedWord = word.strip().strip(",. "); // remove pounds and commas
        if (m.contains(stripedWord)) then
          m.set(stripedWord, m.getValue(stripedWord) + 1);
        else
          m.add(stripedWord, 1);
    }
    return m;
  }

  record r { var x : int = 0; }

  record Updater {
    proc this(const key, ref val) {
      val.x +=1;
      return none;
    }
  }

  proc counting_v1(text : string) : map throws {
    var kmerHash : map(string, r, true);
    //var kmerHash : map(string, int, false);

    var sequence = for word in text.split(' ') do word.strip().strip(",.");

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

  proc counting_v2(text : string) : map throws {
    var kmerHash : map(string, int, false);
    //var kmerHash : map(string, int, false);

    var sequence = for word in text.split(' ') do word.strip().strip(",.");
    // var sequence : domain(string) = for word in text.split(' ') do word.strip().strip(",.");

    for word in sequence {
        //writeln(word);
      if (kmerHash.contains(word)) then {
        kmerHash.set(word, kmerHash[word] + 1);
      }
      else {
        kmerHash.add(word, 1);
      }
    }
    return kmerHash;
  }

  proc counting_v3(text : string) : map throws {
    var kmerHash : map(string, int, true);
    //var kmerHash : map(string, int, false);

    var sequence = for word in text.split(' ') do word.strip().strip(",.");

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