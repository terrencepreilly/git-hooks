{- A Git commit hook for ensuring that no errors were found by dart_analyzer.

This is more specifically for AngularDart projects.  It expects there to be
a file at lib/app/app_component.dart which is the root of the project.

To use for any other dart projects, just redefine `projectRoot` to return the
correct root.

 -}
import System.Process
import System.Exit
import System.IO
import Data.List

projectRoot :: String
projectRoot = "lib/app/app_component.dart"

dartAnalyzerCommand :: String
dartAnalyzerCommand = "dartanalyzer " ++ projectRoot

getProblems :: Handle -> IO ([String])
getProblems stdout' = do
    contents <- hGetContents stdout'
    let lcontents = lines contents
    return lcontents

isProblemFree :: [String] -> Bool
isProblemFree [] = False
isProblemFree (x:xs) =
    if isInfixOf "No issues found!" x
    then True
    else isProblemFree xs

_cleanUp :: Handle -> Handle -> Handle -> IO ()
_cleanUp stdin' stdout' stderr' = do
    hClose stdin'
    hClose stdout'
    hClose stderr'
    return ()

_errorMessage :: [String] -> String
_errorMessage problems =
    let
        dartMessage = last problems
    in
        "DartAnalyzer: " ++ dartMessage

main :: IO ()
main = do
    (stdin', stdout', stderr', _) <- runInteractiveCommand dartAnalyzerCommand
    problems <- getProblems stdout'
    let problemFree = isProblemFree problems
    if problemFree
        then do
            _cleanUp stdin' stdout' stderr'
            return ()
        else do
            hPutStrLn stderr $ _errorMessage problems
            _cleanUp stdin' stdout' stderr'
            exitWith (ExitFailure 1)
