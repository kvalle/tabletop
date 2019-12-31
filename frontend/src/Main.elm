module Main exposing (init, main)

import Browser
import Browser.Navigation as Navigation
import Json.Decode
import Messages exposing (Msg(..))
import Model exposing (Model)
import Update exposing (update)
import Url
import View exposing (view)


init : Json.Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( "foobar", Cmd.none )


main : Program Json.Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view >> (\view2 -> { title = "Tabletop", body = [ view2 ] })
        , subscriptions = always Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
