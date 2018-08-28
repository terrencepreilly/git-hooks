module Main where

import System.Process
import System.Exit
import System.IO
import Data.List

import CheckDartAnalyzer
    ( performCheck
    )


main :: IO ()
main = performCheck
