# If the first argument is "run"...
ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

MODULES=eco_pool eco_proc eco_time eco_watcher eco_tb

PREREQS=$(addprefix bin/, $(addsuffix .beam, ${MODULES}))

.PHONY: all run clean

all: bin/ ${PREREQS}

run: bin/ ${PREREQS}
	erl -pz bin/ -noshell -run eco_tb $(RUN_ARGS)

clean:
	rm -r bin erl_crash.dump

bin/:
	mkdir bin

bin/%.beam: src/%.erl
	erlc -o bin/ $<
