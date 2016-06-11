module Core exposing (..)
import List exposing (indexedMap, map, repeat)

type Color = Black | White

type alias Checker = Maybe Color

type alias Cell =
  { coords : Coords
  , color : Color
  , checker : Checker
  , selected : Bool
  }

type alias Row = List Cell

type alias Field = List Row

type alias Coords =
  { x : Int
  , y : Int
  }

updateElement : Int -> (a -> a) -> List a -> List a
updateElement index fn =
  indexedMap <| \i e -> if i == index then fn e else e

updateCell : (Cell -> Cell) -> Coords -> Field -> Field
updateCell fn {x, y} =
  updateElement y (updateElement x fn)

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
    Cell coords color checker False


initialField : Int -> Field
initialField fieldSize =
  indexedMap
    (\y -> map (coordsToCell << flip Coords y))
    (repeat fieldSize [0..fieldSize-1])

