module Core exposing
  ( Color(..)
  , Checker
  , Cell
  , Row
  , Field
  , Coords
  , updateCells
  , initialField
  )

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


updateCellsIf : (Cell -> Bool) -> (Cell -> Cell) -> Field -> Field
updateCellsIf pred update =
  map <| map <| \cell ->
    if pred cell
      then update cell
      else cell


updateCell : (Cell -> Cell) -> Coords -> Field -> Field
updateCell fn coords =
  updateCellsIf (\c -> c.coords == coords) fn


updateCells : (Cell -> Cell) -> Field -> Field
updateCells = updateCellsIf (\c -> True)


isTopLines : Coords -> Bool
isTopLines {y} = y < 3


isBottomLines : Coords -> Bool
isBottomLines {y} = y > 4


getInitialCheckerColor : Coords -> Checker
getInitialCheckerColor coords =
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
       then getInitialCheckerColor coords
       else Nothing

  in
    Cell coords color checker False


initialField : Int -> Field
initialField fieldSize =
  indexedMap
    (\y -> map (coordsToCell << flip Coords y))
    (repeat fieldSize [0..fieldSize-1])

