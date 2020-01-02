module View exposing (view)

import Data.Game as Game exposing (Game)
import Data.GamesRequest exposing (GamesRequest(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (Msg)
import Model exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Board game collection of BGG user "
            , em [] [ text model.username ]
            ]
        , case model.gamesRequest of
            Success games ->
                ul [] <|
                    List.map displayGame games

            BggProcessing ->
                p [] [ text "Waiting for BGG to process the games" ]

            Requesting ->
                p [] [ text "Loading" ]

            Error _ ->
                p [] [ text "Something went wrong :(" ]
        ]


displayGame : Game -> Html Msg
displayGame game =
    li []
        [ text game.title
        , br [] []
        , img
            [ src game.thumbnailUrl
            , alt <| "Cover image for " ++ game.title
            ]
            []
        ]
