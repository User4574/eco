MODULES=eco_pool eco_proc eco_time eco_watcher eco_tb

PREREQS=$(addprefix bin/, $(addsuffix .beam, ${MODULES}))

.PHONY: all run clean

all: bin/ ${PREREQS}

run: bin/ ${PREREQS}
	erl -pz bin/ -noshell -run eco_tb start

clean:
	rm -r bin erl_crash.dump

bin/:
	mkdir bin

bin/%.beam: src/%.erl
	erlc -o bin/ $<
