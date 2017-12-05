
ALL = CheckChangelog CheckDartAnalyzer clean-build

all: $(ALL)

CheckChangelog: CheckChangelog.hs
	ghc CheckChangelog.hs

CheckDartAnalyzer: CheckDartAnalyzer.hs
	ghc CheckDartAnalyzer.hs

# We use `rm -f` in case the targets do not exist.
.PHONE: clean-build
clean-build:
	rm -f *.o *.hi

clean:
	$(MAKE) clean-build && rm -f $(ALL)
