
module Main exposing (..)

import Html.Attributes exposing (src, style, class)
import Html.Events exposing (..)
import Color
import Html exposing (..)
import AnimationFrame
import Debug
import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render as Render exposing (Renderable, rectangle, circle)
import Game.TwoD as Game
import Keyboard.Extra exposing (Key)


---- MODEL ----


type alias Model =
    {
     kanonRotasjon : Float 
    , pressedKeys : List Key
    }



init : ( Model, Cmd Msg )
init =
    { 
     kanonRotasjon = 0
    , pressedKeys = []
    }
        ! []



---- UPDATE ----


type Msg
    = Tick Float
    | KeyMsg Keyboard.Extra.Msg
    | MerRotasjon
    | MindreRotasjon


subs : Model -> Sub Msg
subs model =
    Sub.batch
        [ Sub.map KeyMsg Keyboard.Extra.subscriptions
        , AnimationFrame.diffs Tick
        ]





update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick dt ->
            ( model, Cmd.none )

        KeyMsg keyMsg ->
            ( { model | pressedKeys = Keyboard.Extra.update keyMsg model.pressedKeys }
            , Cmd.none
            )
        MerRotasjon ->
            ( {model | kanonRotasjon = model.kanonRotasjon + 1}, Cmd.none )
        MindreRotasjon ->
            ( {model | kanonRotasjon = model.kanonRotasjon - 1}, Cmd.none )


graderTilRadianer : Float -> Float
graderTilRadianer grader = 
    pi / 180 * grader



view : Model -> Html Msg
view model =
    div [ class "grid-container" ]
        [ h1 [ class "heading" ] [ text "Test" ]
        , div [ class "main-game" ]
            [ Game.renderCentered { time = 0, camera = Camera.fixedArea (1200 * 900) ( 0, 0 ), size = ( 1200, 900 ) }
                [ 

                 Render.shape rectangle { color = Color.green, position = ( -600, -300 ), size = ( 1200, 150 ) }

                , Render.shapeWithOptions rectangle { color = Color.purple, position = ( 0, 100, 0 ), size = ( 200, 50 ), rotation = graderTilRadianer model.kanonRotasjon, pivot = ( 0.5, 0.5 ) }
                ]
            ]
        , div [ class "left-player" ] [ 
    
         button [ onClick MerRotasjon, class "far fa-caret-square-up fa-3x" ] [] 
        , button [ onClick MindreRotasjon, class "far fa-caret-square-down fa-3x" ] [] 
        , text ("Rotasjon: " ++ (toString model.kanonRotasjon))
         ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subs
        }

