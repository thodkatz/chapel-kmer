/**
 * A naive implementation of word counting in Chapel.
 * Parallel verison
 */
module WordParallel {
    use Map;

    proc counting(text : string) : map {
        writeln("Parallel version initiated");        

        var m : map(string, int, true);

        // create an array spliting the string to each whitespace
        // iterate over the array and if key exist then add the key and set count 1, otherwise increment the id
        // parallelism?
        forall word in text.split(' ') {
            if(m.contains(word)) then m.set(word, m[word] + 1);
            else m.add(word, 1);
        }
        
        return m;
    }
}