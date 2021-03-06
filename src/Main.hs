module Main where

import Days.Prelude
import Days.Day1
import Days.Day2
import Days.Day3
import Days.Day4
import Days.Day5
import Days.Day6
import Days.Day7
import System.Environment

days :: [String -> IO ()]
days =
  [ runDay day1
  , runDay day2
  , runDay day3
  , runDay day4
  , runDay day5
  , runDay day6
  , runDay day7
  ]

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> putStrLn "Usage: aoc2016 <day> [test]"
    [x] -> do
      let n = read x
          run = days !! (n - 1)
      run ("input/day" ++ x)
    [x, "test"] -> do
      let n = read x
          run = days !! (n - 1)
      run ("input/day" ++ x ++ "test")
