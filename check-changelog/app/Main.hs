module Main where

import System.IO
import System.Exit
import System.Process

import CheckChangelog ( performCheck )

main :: IO ()
main = performCheck
