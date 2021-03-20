/**
 * A naive implementation of word counting in Chapel.
 * Serial verison
 */
module WordSerial {    
    use Map;
    use Benchmarking;

    proc counting(text : string) : map{
        writeln("Serial version is initiated");

        var m : map(string, int, true);

        // create an array spliting the string to each whitespace
        // iterate over the array and if key exist then add the key and set count 1, otherwise increment the id
        for word in text.split(' ') {
            if(m.contains(word)) then {
                var value = m.getValue(word);
                m.set(word, value + 1);
            }
            else {
                m.add(word, 1);
            }
        }
        
        return m;
    }
}