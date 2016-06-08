import Html exposing (Html, button, div, text, input, span)
import Html.App as Html
import Html.Attributes exposing (value, class, style)
import Core exposing (..)

-- Model

type alias Style =
  List (String, String)

type alias Model =
  { field : Field
  }


-- Update

type Msg
  = N

update : Msg -> Model -> Model
update msg model =
  case msg of
    N ->
      model


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
  in
     [ ("display", "inline-block")
     , ("width", size)
     , ("height", size)
     , ("background-color", color)
     ]


cell : Cell -> Html Msg
cell c =
  span [style <| cellStyles c] []


view : Model -> Html Msg
view model =
  div [style fieldStyles]
    <| List.map (div [style rowStyles] << List.map cell) model.field


-- Initial state

model : Model
model =
  Model initialField

main = Html.beginnerProgram { model = model, update = update, view = view }
