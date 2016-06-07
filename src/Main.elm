import Html exposing (Html, button, div, text, input, span)
import Html.App as Html
import Html.Attributes exposing (value, class, style)

-- Model

type Color = Black | White

type alias Cell =
  { color: Color
  }

type alias Row = List Cell

type alias Field = List Row

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
  , ("background-color", "gray")
  ]

rowStyles : Style
rowStyles =
  [ ("display", "flex")
  ]

cellStyles : Cell -> Style
cellStyles cell =
  let
    size = "20px"
    color =
      case cell.color of
        Black -> "black"
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
