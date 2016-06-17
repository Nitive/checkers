import ElmTest exposing (..)
import Core exposing (..)
import Maybe exposing (withDefault, andThen)
import List exposing (head, length, drop, all)
import Random exposing (Generator)


elem : Int -> List a -> Maybe a
elem index list = head <| drop index list


first : List (List a) -> Maybe a
first list = head list `andThen` elem 1


allCells : (Cell -> Bool) -> Field -> Bool
allCells fn = all (all fn)


ifElse : a -> a -> Bool -> a
ifElse a b condition =
  if condition then a else b


colorGen : Generator Color
colorGen =
  Random.map (ifElse White Black) Random.bool


checkerGen : Generator Checker
checkerGen =
  Random.map (ifElse (Just White) (Just Black)) Random.bool


randomCell : Coords -> Random.Seed -> Cell
randomCell coords seed =
  let
    (color, seed') = Random.step colorGen seed
    (checker', seed'') = Random.step checkerGen seed'
    checker =
      if color == Black
        then checker'
        else Nothing

    (selected, seed''') = Random.step Random.bool seed''
    highlighted = fst <| Random.step Random.bool seed'''
  in
    Cell coords color checker selected highlighted


testCell : Cell
testCell = randomCell { x = 1, y = 0 } <| Random.initialSeed 1



tests : Test
tests =
  suite "tests"
    [ suite "field"
      [ let
          expected = 8
          actual = length <| initialField 8
        in
          test "generate field with right height"
            <| assertEqual actual expected
        ]
    , suite "updateCell"
      [ let
          expected = Just testCell
          actual = first <| updateCell (\c -> testCell) testCell.coords (initialField 8)
        in
          test "update cell in field"
            <| assertEqual actual expected
      ]
    , suite "clearField"
      [ test "set selected to False"
          <| assert <| allCells (not << .selected) (clearField <| initialField 8)
      , test "set highlighted to False"
          <| assert <| allCells (not << .highlighted) (clearField <| initialField 8)
      ]
    ]

main = runSuiteHtml tests
