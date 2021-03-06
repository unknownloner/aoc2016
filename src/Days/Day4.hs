{-# LANGUAGE TemplateHaskell #-}
module Days.Day4
  ( day4
  ) where

import Days.Prelude
import Data.Char
import Data.Function

data Room = Room
  { _name :: String
  , _sector :: Integer
  , _checksum :: String
  }

makeLenses ''Room

calcChecksum :: String -> String
calcChecksum =
  map head .               -- We only want one of each letter.

  take 5 .                 -- Get the top 5 frequent letters

  concatMap sort .         -- Sort each subgroup of letters. This serves to
                           -- alphabetically sort the equal-length lists
                          
  sortDAndGroupBy length . -- Sort/group by the frequency of each letter
                          
  sortDAndGroupBy id .     -- Group letters into lists of each letter

  filter isLetter          -- Remove dashes

  where
    -- Sort and group by the same function. Sorts in descending order
    sortDAndGroupBy f = groupBy (on (==) f) . sortBy (on (flip compare) f)

validRooms :: [Room] -> [Room]
validRooms = filter (\x -> calcChecksum (x ^. name) == x ^. checksum)

-- Rotate a lowercase letter once forward, wrapping around
-- Obviously this screws up the '-', but we dont really care about it anyway
rotate :: Char -> Char
rotate c = toEnum (((fromEnum c - o) + 1) `mod` 26 + o)
  where
    o = fromEnum 'a' :: Int

-- All possible rotations of a string
rotations :: String -> [String]
rotations str = take 26 $ iterate (map rotate) str

-- Check every possible Caesar cipher for the word "north" and "pole"
-- Checking for "north" only seems to work, but just in case I added pole too
isNorth :: String -> Bool
isNorth = any (\x -> isInfixOf "north" x && isInfixOf "pole" x) . rotations

part1 :: [Room] -> Integer
part1 = sumOf (folded . sector) . validRooms

part2 :: [Room] -> Integer
part2 = view sector . head . filter (isNorth . view name) . validRooms

day4 :: Day [Room] Integer Integer
day4 =
  Day
  { _parser = parser
  , _dayPart1 = part1
  , _dayPart2 = part2
  }
  where
    parser :: Parser [Room]
    parser = do
      let key = do
            let letterOrDash = oneOf ('-' : ['a'..'z'])
            name <- some letterOrDash
            sector <- natural
            char '['
            checksum <- some letterOrDash
            char ']'
            spaces
            pure $ Room name sector checksum
      some key
