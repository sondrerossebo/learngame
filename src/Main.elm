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
import Keyboard.Extra exposing (Key, arrows)


---- MODEL ----


type alias Model =
    { kanonPlassering : Float
    , kanonRotasjon : Float
    , pressedKeys : List Key
    }


init : ( Model, Cmd Msg )
init =
    { kanonPlassering = 0
    , kanonRotasjon = 45
    , pressedKeys = []
    }
        ! []


graderTilRadianer : Float -> Float
graderTilRadianer grader =
    pi / 180 * grader



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


updateCannonRotation : Float -> Model -> Float
updateCannonRotation tick model =
    let
        { x, y } =
            arrows model.pressedKeys
    in
        model.kanonRotasjon + toFloat (y)


updateCannonSide : Float -> Model -> Float
updateCannonSide tick model =
    let
        { x, y } =
            arrows model.pressedKeys
    in
        model.kanonPlassering + toFloat x * 7


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick dt ->
            let
                rotation =
                    updateCannonRotation dt model

                sideflytting =
                    updateCannonSide dt model
            in
                ( { model | kanonRotasjon = rotation, kanonPlassering = sideflytting }, Cmd.none )

        KeyMsg keyMsg ->
            ( { model | pressedKeys = Keyboard.Extra.update keyMsg model.pressedKeys }
            , Cmd.none
            )

        MerRotasjon ->
            ( { model | kanonRotasjon = model.kanonRotasjon + 1 }, Cmd.none )

        MindreRotasjon ->
            ( { model | kanonRotasjon = model.kanonRotasjon - 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "grid-container" ]
        [ h1 [ class "heading" ] [ text "Test" ]
        , div [ class "main-game" ]
            [ Game.renderCentered { time = 0, camera = Camera.fixedArea (1200 * 700) ( 0, 0 ), size = ( 1200, 700 ) }
                -- [
                -- -- , Render.shapeWithOptions rectangle { color = Color.purple, position = ( model.kanonPlassering, 100, 0 ), size = ( 200, 50 ), rotation = graderTilRadianer model.kanonRotasjon, pivot = ( 0, 0.5 ) }
                -- ,viewTank model
                -- -- , Render.shapeWithOptions rectangle { color = Color.purple, position = ( model.kanonPlassering, 100, 0 ), size = ( 200, 50 ), rotation = graderTilRadianer model.kanonRotasjon, pivot = ( 0, 0.5 ) }
                -- ]
                ((viewTank model)
                    ++ (viewLandscape model)
                )
            ]
        , div [ class "left-player" ]
            [ button [ onClick MerRotasjon, class "far fa-caret-square-up fa-3x" ] []
            , button [ onClick MindreRotasjon, class "far fa-caret-square-down fa-3x" ] []
            , text ("Rotasjon: " ++ (toString model.kanonRotasjon))
            ]
        ]


viewLandscape : Model -> List Renderable
viewLandscape model =
    [ Render.shape rectangle { color = Color.green, position = ( -600, -300 ), size = ( 1200, 150 ) }
    ]


viewTank : Model -> List Renderable
viewTank model =
    [ Render.shapeWithOptions rectangle { color = Color.purple, position = ( model.kanonPlassering, -125, 0 ), size = ( 130, 18 ), rotation = graderTilRadianer model.kanonRotasjon, pivot = ( 0, 0.5 ) }
    , Render.shapeWithOptions rectangle { color = Color.blue, position = ( model.kanonPlassering, -140, 0 ), size = ( 200, 60 ), rotation = 0, pivot = ( 0.5, 0.0 ) }
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
