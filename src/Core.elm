module Core exposing
  ( Row
  , Cell
  , Field
  , Coords
  , Checker
  , makeMove
  , Color(..)
  , updateCell
  , selectCell
  , updateCells
  , getSelected
  , initialField
  , makeMoveFromSelected
  )

import List exposing (indexedMap, map, repeat, filter, concat, head, all, any)


type Color = Black | White

type alias Checker = Maybe Color

type alias Cell =
  { coords : Coords
  , color : Color
  , checker : Checker
  , selected : Bool
  , highlighted: Bool
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


selectCell : Cell -> Field -> Field
selectCell c field =
  updateCells (\cell ->
    { cell
    | selected = cell.coords == c.coords
    , highlighted = isPossibleMove c cell field
    }) field


getSelected : Field -> Maybe Cell
getSelected field =
  head <| filter .selected <| concat field


makeMove : Cell -> Cell -> Field -> Field
makeMove from to =
  updateCells (\cell ->
    { cell
    | checker =
        if cell.coords == to.coords then
          from.checker
        else if cell.coords == from.coords then
          Nothing
        else
          cell.checker
    , selected = False
    , highlighted = False
    })


makeMoveFromSelected : Cell -> Field -> Field
makeMoveFromSelected to field =
  let
    selected = getSelected field
  in
    case selected of
      Just sel ->
        makeMove sel to field

      Nothing ->
        field


isTrue : Bool -> Bool
isTrue = (==) True


isPossibleMove : Cell -> Cell -> Field -> Bool
isPossibleMove from to field =
  all isTrue
    [ to.checker == Nothing
    , to.color == Black
    , abs (from.coords.x - to.coords.x) == 1
    , any isTrue
      [ all isTrue
        [ from.checker == Just White
        , from.coords.y - to.coords.y == 1
        ]
      , all isTrue
        [ from.checker == Just Black
        , from.coords.y - to.coords.y == -1
        ]
      ]
    ]


-- initial data

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
    Cell coords color checker False False


initialField : Int -> Field
initialField fieldSize =
  indexedMap
    (\y -> map (coordsToCell << flip Coords y))
    (repeat fieldSize [0..fieldSize-1])

