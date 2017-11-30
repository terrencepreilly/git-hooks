
ALL = CheckChangelog

all: $(ALL)

CheckChangelog: CheckChangelog.hs
	ghc CheckChangelog.hs && $(MAKE) clean-build

# We use `rm -f` in case the targets do not exist.
clean-build:
	rm -f *.o *.hi

clean:
	$(MAKE) clean-build && rm -f $(ALL)
