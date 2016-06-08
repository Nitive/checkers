module Core exposing (..)

type Color = Black | White

type Checker = Color Color | None

type alias Cell =
  { color : Color
  , checker : Checker
  }

type alias Row = List Cell

type alias Field = List Row


coordsToCell : Int -> Int -> Cell
coordsToCell x y =
  let
    color =
      if (x + y) % 2 == 0
        then White
        else Black

    isBlack = color == Black

    cherker =
      if isBlack
       then Color Black
       else None

  in
    Cell color cherker


fieldSize = 8

initialField =
  List.indexedMap (coordsToCell >> List.map) <| List.repeat fieldSize [0..fieldSize-1]

