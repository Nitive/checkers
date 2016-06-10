import ElmTest exposing (..)
import Core exposing (..)

tests : Test
tests =
  suite "field"
    [ test "generate field with right height"
      <| assertEqual 8 <| List.length <| initialField 8
    ]

main = runSuiteHtml tests
