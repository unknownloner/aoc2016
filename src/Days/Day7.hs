module Days.Day7
  ( day7
  ) where

import Days.Prelude

part1 = const ""
part2 = const ""

day7 =
  Day
  { _parser = parser
  , _dayPart1 = part1
  , _dayPart2 = part2
  }
  where
    parser :: Parser ()
    parser = pure ()
