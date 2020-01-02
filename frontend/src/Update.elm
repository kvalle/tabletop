module Update exposing (update)

import Backend
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Data.GamesRequest as GamesRequest
import Messages exposing (Msg(..))
import Process
import Task
import Url


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

        GameCollectionReceived (Ok gamesRequest) ->
            ( { model | gamesRequest = gamesRequest }
            , if gamesRequest == GamesRequest.BggProcessing then
                Process.sleep 2
                    |> Task.andThen (\_ -> Backend.getCollection model.username)
                    |> Task.attempt GameCollectionReceived

              else
                Cmd.none
            )

        GameCollectionReceived (Err _) ->
            ( { model | gamesRequest = GamesRequest.Error "Server Error" }
            , Cmd.none
            )
