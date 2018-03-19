
module Main exposing (..)

import Html.Attributes exposing (src, style, class)
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
     pressedKeys : List Key
    }



init : ( Model, Cmd Msg )
init =
    { 
     pressedKeys = []
    }
        ! []



---- UPDATE ----


type Msg
    = Tick Float
    | KeyMsg Keyboard.Extra.Msg


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






view : Model -> Html Msg
view m =
    div [ class "grid-container" ]
        [ h1 [ class "heading" ] [ text "Test" ]
        , div [ class "main-game" ]
            [ Game.renderCentered { time = 0, camera = Camera.fixedArea (1200 * 900) ( 0, 0 ), size = ( 1200, 900 ) }
                [ 

                ]
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

