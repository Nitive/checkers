import ElmTest exposing (..)
import Core exposing (..)
import Maybe exposing (withDefault, andThen)
import List exposing (head, length, drop)

testCell : Cell
testCell =
  { coords = { x = 1, y = 0 }
  , color = Black
  , checker = Just Black
  , selected = False
  , highlighted = False
  }

elem : Int -> List a -> Maybe a
elem index list = head <| drop index list

first : List (List a) -> Maybe a
first list = head list `andThen` elem 1

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
          actual = first <| updateCell (\c -> testCell) { x = 1, y = 0 } (initialField 8)
        in
          test "update cell in field"
            <| assertEqual actual expected
      ]
    ]

main = runSuiteHtml tests
