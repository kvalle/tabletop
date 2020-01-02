module Update exposing (update)

import Backend
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Data.CollectionResponse as CollectionResponse
import Data.CollectionStatus as CollectionStatus
import Messages exposing (Msg(..))
import Model exposing (Model)
import Process
import Task
import Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        GameCollectionReceived (Ok response) ->
            let
                username =
                    CollectionStatus.getUsername model.collection
            in
            ( { model | collection = CollectionStatus.fromResponse username response }
            , if response == CollectionResponse.BggProcessing then
                Process.sleep 2
                    |> Task.andThen (\_ -> Backend.getCollection username)
                    |> Task.attempt GameCollectionReceived

              else
                Cmd.none
            )

        GameCollectionReceived (Err _) ->
            ( { model
                | collection =
                    CollectionStatus.Error
                        (CollectionStatus.getUsername model.collection)
                        "Server Error"
              }
            , Cmd.none
            )
