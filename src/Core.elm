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


isTopLines : Coords -> Bool
isTopLines {x} = x < 3


isBottomLines : Coords -> Bool
isBottomLines {x} = x > 4


startCheckerColor : Coords -> Checker
startCheckerColor coords =
  if isTopLines coords then
     Color Black

  else if isBottomLines coords then
    Color White

  else
    None


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
       else None

  in
    Cell color checker


fieldSize = 8

initialField =
  List.indexedMap
    (\x -> List.map (coordsToCell << Coords x))
    (List.repeat fieldSize [0..fieldSize-1])

