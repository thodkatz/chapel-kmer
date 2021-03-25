/**
 * A naive implementation of word counting in Chapel.
 * Serial verison
 */
module WordSerial {    
    use Map;
    use Benchmarking;

    proc counting(text : string) : map {
        writeln("Serial version is initiated");

        var m : map(string, int, false);

        // create an array spliting the string to each whitespace
        // iterate over the array and if key exist then add the key and set count 1, otherwise increment the id
        for word in text.split(' ') {
            var parsedWord = word.strip().strip(",. "); // remove pounds and commas
            if(m.contains(parsedWord)) then m.set(parsedWord, m[parsedWord] + 1);
            else m.add(parsedWord, 1);
        }
        return m;
    }

    proc counting_v1(text : string) : map {
        var kmerHash : map(string, int, true);
        for word in text.split(' ') {
            var stripedWord = word.strip().strip(",.");
            if(kmerHash.contains(stripedWord)) then
                kmerHash.set(stripedWord, kmerHash.getValue(stripedWord) + 1);
            else 
                kmerHash.add(stripedWord, 1);
        }
        return kmerHash;
    }
}