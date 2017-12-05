{- A Git pre-commit hook for ensuring that Changelog has been updated. -}

import System.Process
import System.Exit
import System.IO
import Data.List

gitCommand :: String
gitCommand = "git --no-pager diff --cached --name-only"

{- Get a list of staged files. -}
getStagedChanges :: Handle -> IO ([String])
getStagedChanges stdout' = do
    contents <- hGetContents stdout'
    let lcontents = lines contents
    return lcontents

_printStagedChanges :: [String] -> IO ()
_printStagedChanges changes = do
    if null changes then do
        return ()
    else do
        putStrLn (head changes)
        _printStagedChanges (tail changes)

changelogInStaged :: [String] -> Bool
changelogInStaged [] = False
changelogInStaged (x:xs) =
    if isInfixOf "CHANGELOG.md" x
    then True
    else changelogInStaged xs

_cleanUp :: Handle -> Handle -> Handle -> IO ()
_cleanUp stdin' stdout' stderr' = do
    hClose stdin'
    hClose stdout'
    hClose stderr'
    return ()

main :: IO ()
main = do
    (stdin', stdout', stderr', _) <- runInteractiveCommand gitCommand
    changes <- getStagedChanges stdout'
    let changeLogDefined = changelogInStaged changes
    if not changeLogDefined then do
        hPutStrLn stderr "Changelog not staged!"
        _cleanUp stdin' stdout' stderr'
        exitWith (ExitFailure 1)
    else do
        _cleanUp stdin' stdout' stderr'
        return()
