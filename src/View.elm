import Html exposing (Html, button, div, text, input, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes exposing (value, class, style)
import TimeTravel.Html.App as TimeTravel
import List exposing (map)
import String exposing (join)
import Core exposing (..)

-- Model

type alias Style =
  List (String, String)

type alias Model =
  { field : Field
  }


-- Update

type Msg
  = SelectCheker Cell
  | MakeMove Cell


update : Msg -> Model -> Model
update msg model =
  case msg of
    SelectCheker cell ->
      { model | field = selectCell cell model.field }

    MakeMove cell ->
      let
        field = makeMoveFromSelected cell model.field
      in
        case field of
          Just newField ->
            { model | field = newField }
          Nothing ->
            { model | field = clearField model.field }



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
      if cell.highlighted
        then
          "red"
        else
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

    cursor =
      case cell.checker of
        Just color -> "pointer"
        Nothing -> "default"

    radius =
      case cell.king of
        Just True -> "none"
        Just False -> "50%"
        Nothing -> ""

    size = "30px"

  in
    [ ("color", "green")
    , ("width", size)
    , ("height", size)
    , ("margin", "auto")
    , ("border-radius", radius)
    , ("background-color", color)
    , ("cursor", cursor)
    ]

cell : Cell -> Html Msg
cell props =
  div
    [ style <| cellStyles props
    , onClick <| if props.checker /= Nothing
       then SelectCheker props
       else MakeMove props
    ]
    [ div
      [ style <| checkerStyles props
      ]
      [ text <| join ", " <| map toString [props.coords.x, props.coords.y]
      ]
    ]


view : Model -> Html Msg
view model =
  div [style fieldStyles]
    <| map (div [style rowStyles] << map cell) model.field


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
