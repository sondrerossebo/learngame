module Main exposing (..)

import Html exposing (Html, text, div, h1, img, button)
import Html.Attributes exposing (src,class)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    { kanonRotasjon : Int }


init : ( Model, Cmd Msg )
init =
    ( { kanonRotasjon = 0 }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | MerRotasjon
    | MindreRotasjon


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MerRotasjon ->
            ( { model | kanonRotasjon = model.kanonRotasjon + 1 }, Cmd.none )

        MindreRotasjon ->
            ( { model | kanonRotasjon = model.kanonRotasjon - 1 }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 []
            [ text "sondre sin test"
            ]
        , button [class "fas fa-arrow-circle-right fa-3x", onClick MerRotasjon ] [ text "+" ]
        , button [ onClick MindreRotasjon ] [ text "-" ]
        , text ("rotasjon:" ++ (toString model.kanonRotasjon))
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
