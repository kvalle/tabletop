module Main exposing (main)

import Backend
import Browser
import Browser.Navigation as Navigation
import Data.CollectionStatus as CollectionStatus
import Json.Decode
import Messages exposing (Msg(..))
import Model exposing (Model)
import Task
import Update exposing (update)
import Url
import View exposing (view)


init : Json.Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { collection = CollectionStatus.Requesting "kvalle"
            , navKey = key
            }
    in
    ( model
    , model.collection
        |> CollectionStatus.getUsername
        |> Backend.getCollection
        |> Task.attempt GameCollectionReceived
    )


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
