/**
 * A naive implementation of word counting in Chapel.
 * Serial verison
 */
module WordSerial {    
    use Map;

    proc counting() {
        writeln("Serial version is initiated");

        var m : map(string, int, true);

        var testSubject : string = "hi there bye hi";
        // create an array spliting the string to each whitespace
        // iterate over the array and if key exist then add the key and set count 1, otherwise increment the id
        for word in testSubject.split(' ') {
            if(m.contains(word)) then {
                var value = m.getValue(word);
                m.set(word, value + 1);
            }
            else {
                m.add(word, 1);
            }
        }

        // print map elements
        // should work with tuples now
        for pair in m.items() {
            // writeln(pair);
            var (key, value) = pair;
            writeln(key, ":", value);
        }
    }
}