module CheckFlags
    ( performCheck
    , findCommand
    , gitCommand
    , getCachedFiles
    , find
    , containsAny
    ) where


import qualified Data.List as List
import System.Exit
import System.FilePath ( takeFileName )
import System.IO
import System.Process


findCommand :: String -> String
findCommand flag
    = "find . -not -path '*/\\.*' -type f |"
    ++ "xargs awk '/"
    ++ flag
    ++ "/{print FILENAME \": \" NR\": \"$0}' "

gitCommand :: String
gitCommand = "git --no-pager diff --cached --name-only"

cleanUp :: (Handle, Handle, Handle) -> IO ()
cleanUp (stdin', stdout', stderr') = do
    hClose stdin'
    hClose stdout'
    hClose stderr'
    return ()


cleanUpAll :: [(Handle, Handle, Handle)] -> IO ()
cleanUpAll [] = return ()
cleanUpAll (x:xs) = do
    cleanUp x
    cleanUpAll xs


getCachedFiles :: IO ( ([String], [(Handle, Handle, Handle)]) )
getCachedFiles = do
    (stdin', stdout', stderr', _) <- runInteractiveCommand gitCommand
    contents <- hGetContents stdout'
    let lcontents = map takeFileName $ lines contents
    return (lcontents, [(stdin', stdout', stderr')])


find :: String -> IO (([String], [(Handle, Handle, Handle)]))
find item = do
    let command = findCommand item
    (stdin', stdout', stderr', _) <- runInteractiveCommand command
    contents <- hGetContents stdout'
    let lcontents = lines contents
    return (lcontents, [(stdin', stdout', stderr')])


getWarning :: [String] -> String
getWarning items =
    List.intercalate "\n" $ "Flags Present:" : items


containsAny :: [String] -> String -> Bool
containsAny filenames warning =
    let
        contains :: String -> Bool
        contains filename =
            List.isInfixOf filename warning
    in
        List.any contains filenames


-- TODO: Finish Me!
performCheck :: IO ()
performCheck = do
    (cachedFiles, handles0) <- getCachedFiles
    (todos, handles1) <- find "TODO"
    (fixmes, handles2) <- find "FIXME"
    let handles = handles0 ++ handles1 ++ handles2
    -- let flags = todos ++ fixmes
    let flags =
            filter
                (containsAny cachedFiles)
                (todos ++ fixmes)
    if null flags then do
        cleanUpAll handles
        return()
    else do
        hPutStrLn stderr $ getWarning flags
        cleanUpAll handles
        exitWith (ExitFailure 1)
