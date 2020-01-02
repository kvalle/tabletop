module View exposing (view)

import Data.CollectionStatus as CollectionStatus exposing (CollectionStatus(..))
import Data.Game as Game exposing (Game)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (Msg)
import Model exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Board game collection of BGG user "
            , em []
                [ model.collection
                    |> CollectionStatus.getUsername
                    |> text
                ]
            ]
        , case model.collection of
            Success _ games ->
                ul [] <|
                    List.map displayGame games

            BggProcessing _ ->
                p [] [ text "Waiting for BGG to process the games" ]

            Requesting _ ->
                p [] [ text "Loading" ]

            Error _ _ ->
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
