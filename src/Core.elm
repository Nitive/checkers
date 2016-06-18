module Core exposing
  ( Row
  , Cell
  , elem
  , Field
  , Coords
  , Checker
  , makeMove
  , updateCell
  , selectCell
  , clearField
  , updateCells
  , getSelected
  , initialField
  , Color(White, Black)
  , makeMoveFromSelected
  )

import List exposing (indexedMap, map, repeat, filter, concat, head, all, any, drop, sum, length)
import Maybe exposing (andThen)


type Color = Black | White

type alias Checker = Maybe Color

type alias Cell =
  { coords : Coords
  , color : Color
  , checker : Checker
  , king : Maybe Bool
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


clearField : Field -> Field
clearField =
  updateCells <| \cell -> { cell | selected = False, highlighted = False }



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


between : Int -> Int -> Int -> Bool
between a b x =
  (a < x && x < b) || (b < x && x < a)


makeMove : Cell -> Cell -> Field -> Maybe Field
makeMove from to field =
  if isPossibleMove from to field
    then Just <| updateCells (\cell ->
      { cell
      | checker =
          if cell.coords == to.coords then
            from.checker
          else if cell.coords == from.coords then
            Nothing
          else if
            between from.coords.x to.coords.x cell.coords.x &&
            between from.coords.y to.coords.y cell.coords.y
          then
            Nothing
          else
            cell.checker
      , selected = False
      , highlighted = False
      }) field
    else Nothing


makeMoveFromSelected : Cell -> Field -> Maybe Field
makeMoveFromSelected to field =
  let
    selected = getSelected field
  in
    case selected of
      Just sel ->
        makeMove sel to field

      Nothing ->
        Just field


isTrue : Bool -> Bool
isTrue = (==) True


elem : Int -> List a -> Maybe a
elem index list = head <| drop index list


cellByCoords : Coords -> Field -> Maybe Cell
cellByCoords {x, y} field =
  elem y field `andThen` elem x


avg : List Int -> Int
avg list =
  sum list // length list


isPossibleMove : Cell -> Cell -> Field -> Bool
isPossibleMove from to field =
  all isTrue
    [ to.checker == Nothing
    , to.color == Black
    , any isTrue
      [ all isTrue
        [ from.checker == Just White
        , from.coords.y - to.coords.y == 1
        , abs (from.coords.x - to.coords.x) == 1
        ]
      , all isTrue
        [ from.checker == Just Black
        , to.coords.y - from.coords.y == 1
        , abs (from.coords.x - to.coords.x) == 1
        ]
      , all isTrue
        [ from.checker == Just White
        , from.coords.y - to.coords.y == 2
        , abs (from.coords.x - to.coords.x) == 2
        , (cellByCoords
            { x = avg [from.coords.x, to.coords.x]
            , y = avg [from.coords.y, to.coords.y]
            }
            field) `andThen` .checker == Just Black
        ]
      , all isTrue
        [ from.checker == Just Black
        , to.coords.y - from.coords.y == 2
        , abs (from.coords.x - to.coords.x) == 2
        , (cellByCoords
            { x = avg [from.coords.x, to.coords.x]
            , y = avg [from.coords.y, to.coords.y]
            }
            field) `andThen` .checker == Just White
        ]
      , all isTrue
        [ from.king == Just True
        , abs (from.coords.y - to.coords.y) == abs (from.coords.x - to.coords.x)
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

    -- king = Just False
    king = Just True

  in
    Cell coords color checker king False False


initialField : Int -> Field
initialField fieldSize =
  indexedMap
    (\y -> map (coordsToCell << flip Coords y))
    (repeat fieldSize [0..fieldSize-1])

