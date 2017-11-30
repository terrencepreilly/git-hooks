# Git Hooks

Some useful git hooks that I'll be making.

## The Hooks

- *CheckChangelog*: Makes sure that the change log has been
  edited and staged.

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
