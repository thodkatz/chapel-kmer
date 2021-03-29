CC = chpl
CFLAGS = --fast

BIN = bin
FASTA = # pass via command line argument
SRC_WORD = src/wordcount/*.chpl
SRC_KMER = src/kmer/*.chpl

$(shell mkdir -p bin)

word: $(SRC_WORD)
	$(CC) $(CFLAGS) $^ -o $(BIN)/word

fasta:
	@echo "USAGE: make fasta <name of fasta file>"
	@echo "FASTA file: '$(FASTA)'"
	$(shell awk '!/^>/ { printf "%s", $$0; n = "\n" } /^>/ { print n $$0; n = "" } END { printf "%s", n }' $(FASTA) > linear.fasta)

kmer: $(SRC_KMER)
	$(CC) $(CFLAGS) $^ -o $(BIN)/kmer

.PHONY: clean

clean:
	rm -rf bin/*
