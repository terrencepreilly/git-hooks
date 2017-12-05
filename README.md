# Git Hooks

Some useful git hooks that I'll be making.

## The Hooks

- *CheckChangelog*: Makes sure that the change log has been
  edited and staged.
- `CheckDartAnalyzer`: Makes sure that AngularDart projects have
  no errors as reported by `dart_analyzer`.

## Build

Building requires Haskell and Make. To build the hooks, clone
the repo and `make`:

```
git clone https://github.com/terrencepreilly/git-hooks
cd git-hooks
make
```

By default, this will clear out all build files and leave the
executables.

## Using Multiple hooks

You can combine as many hooks as you would like in a bash script
named after the hook.  For example, if we would like to check the
change log and check dart analyzer, we could do something such as

```
if ! /path/to/repo/.git/hooks/CheckChangelog; then
  exit 1
fi
/path/to/repo/.git/hooks/CheckDartAnalyzer
```

It's probably a good idea to put the slowest hooks last, that way you
don't have to be frustrated by waiting a long time just to find out you
have to change something that could have been checked quickly.
