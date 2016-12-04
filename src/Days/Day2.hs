{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleContexts #-}
module Days.Day2
  ( day2
  ) where

import Days.Prelude
import Linear.V2
import Data.Array.IArray


data KeypadState = KeypadState
  { _pos :: !(V2 Int)
  , _code :: ![Char]
  }



makeLenses ''KeypadState

type Pad = Array (V2 Int) Char

keyPad1 :: Pad
keyPad1 = listArray (pure 0, pure 4)
  "     \
  \ 123 \
  \ 456 \
  \ 789 \
  \     "

keyPad2 :: Pad
keyPad2 = listArray (pure 0, pure 6)
  "       \
  \   1   \
  \  234  \
  \ 56789 \
  \  ABC  \
  \   D   \
  \       "

digitAt m p = m ! (p ^. pos)

canMoveTo m p = digitAt m p /= ' '

move m d p
  | canMoveTo m (p & pos +~ d) = p & pos +~ d
  | otherwise = p

press m p = p & code %~ (++ [digitAt m p])

act m 'U' = move m (V2 (-1) 0)
act m 'D' = move m (V2 1 0)
act m 'L' = move m (V2 0 (-1))
act m 'R' = move m (V2 0 1)
act m '\n' = press m

solve m = view code . foldl' (flip (act m)) (KeypadState initialPosition [])
  where
    initialPosition = fst . head . filter ((== '5') . snd) $ assocs m

part1 = solve keyPad1

part2 = solve keyPad2

day2 =
  Day
  { _parser = parser
  , _dayPart1 = part1
  , _dayPart2 = part2
  }
  where
    parser :: Parser [Char]
    parser = some (oneOf "URDL\n")
