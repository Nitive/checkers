module Core exposing (..)

type Color = Black | White

type Checker = Color Color | None

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



coordsToCell : Coords -> Cell
coordsToCell {x, y} =
  let
    color =
      if (x + y) % 2 == 0
        then White
        else Black

    isBlackCell = color == Black

    cherker =
      if isBlackCell
       then Color Black
       else None

  in
    Cell color cherker


fieldSize = 8

initialField =
  List.indexedMap
    (\x -> List.map (coordsToCell << Coords x))
    (List.repeat fieldSize [0..fieldSize-1])

