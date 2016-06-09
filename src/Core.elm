module Core exposing (..)

type Color = Black | White

type alias Checker = Maybe Color

type alias Cell =
  { color : Color
  , checker : Checker
  }

type alias Row = List Cell

type alias Field = List Row

type alias Coords =
  { x : Int
  , y : Int
  }


isTopLines : Coords -> Bool
isTopLines {y} = y < 3


isBottomLines : Coords -> Bool
isBottomLines {y} = y > 4


startCheckerColor : Coords -> Checker
startCheckerColor coords =
  if isTopLines coords then
    Just Black

  else if isBottomLines coords then
    Just White

  else
    Nothing


coordsToCell : Coords -> Cell
coordsToCell coords =
  let
    color =
      if (coords.x + coords.y) % 2 == 0
        then White
        else Black

    isBlackCell = color == Black

    checker =
      if isBlackCell
       then startCheckerColor coords
       else Nothing

  in
    Cell color checker


fieldSize = 8

initialField =
  List.indexedMap
    (\y -> List.map (coordsToCell << flip Coords y))
    (List.repeat fieldSize [0..fieldSize-1])

