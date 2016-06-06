import Html exposing (Html, button, div, text, input, span)
import Html.App as Html
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)
import String exposing (toInt)
import Result exposing (withDefault)

-- Model

type Color = Black | White

type alias Cell =
  { color: Color
  }

type alias Row = List Cell

type alias Field = List Row

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


t : Cell
t = { color = White }

-- View

cell : Cell -> Html Msg
cell x = span []
  [case x.color of
    Black ->
      text "black"

    White ->
      text "white"
  ]

view : Model -> Html Msg
view model =
  div []
    <| List.map (div [] << List.map cell) model.field


-- Initial state
model : Model
model =
  { field =
    [ [ { color = Black }
      , { color = White }
      ]
    , [ { color = White }
      , { color = Black }
      ]
    ]
  }

main = Html.beginnerProgram { model = model, update = update, view = view }
