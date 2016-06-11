import Html exposing (Html, button, div, text, input, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (value, class, style)
import TimeTravel.Html.App as TimeTravel
import Core exposing (..)

-- Model

type alias Style =
  List (String, String)

type alias Model =
  { field : Field
  }


-- Update

type Msg
  = SelectCheker Coords


update : Msg -> Model -> Model
update msg model =
  case msg of
    SelectCheker coords ->
      { model | field = selectCell coords model.field }


-- View

fieldStyles : Style
fieldStyles =
  [ ("display", "inline-block")
  , ("padding", "10px")
  , ("background-color", "lightgray")
  ]

rowStyles : Style
rowStyles =
  [ ("display", "flex")
  ]

cellStyles : Cell -> Style
cellStyles cell =
  let
    size = "40px"

    color =
      case cell.color of
        Black -> "gray"
        White -> "white"

    border =
      if cell.selected
        then "solid 2px red"
        else "none"
  in
     [ ("display", "inline-flex")
     , ("width", size)
     , ("height", size)
     , ("background-color", color)
     , ("box-sizing", "border-box")
     , ("border", border)
     ]

checkerStyles : Cell -> Style
checkerStyles cell =
  let
    color =
      case cell.checker of
        Just White -> "white"
        Just Black -> "black"
        Nothing -> ""

    display =
      if cell.checker == Nothing
        then "none"
        else "block"

    size = "30px"

  in
    [ ("display", display)
    , ("width", size)
    , ("height", size)
    , ("margin", "auto")
    , ("border-radius", "50%")
    , ("background-color", color)
    ]

cell : Cell -> Html Msg
cell props =
  div [style <| cellStyles props]
    [ div
      [ onClick <| SelectCheker props.coords
      , style <| checkerStyles props
      ]
      []
    ]


view : Model -> Html Msg
view model =
  div [style fieldStyles]
    <| List.map (div [style rowStyles] << List.map cell) model.field


-- Initial state

model : Model
model =
  Model <| initialField 8

main : Program Never
main =
  -- Html.beginnerProgram
  TimeTravel.beginnerProgram
    { model = model
    , update = update
    , view = view
    }
