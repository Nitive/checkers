module Core exposing (..)

type Color = Black | White

type alias Cell =
  { color: Color
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
  in
    Cell color


initialField =
  List.indexedMap (coordsToCell >> List.map) <| List.repeat 8 [0..7]

