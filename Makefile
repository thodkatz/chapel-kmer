CC = chpl
CFLAGS = --fast

BIN = bin
SRC_WORD = src/wordcount/*.chpl
SRC_KMER = src/kmer/*.chpl

$(shell mkdir -p bin)

word: $(SRC_WORD)
	$(CC) $(CFLAGS) $^ -o $(BIN)/word.good

kmer: $(SRC_KMER)
	$(CC) $(CFLAGS) $^ -o $(BIN)/kmer.good

.PHONY: clean

clean:
	rm -rf bin/*
