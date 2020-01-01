module View exposing (view)

import Html exposing (..)
import Messages exposing (Msg)
import Model exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Board game collection of BGG user "
            , em [] [ text model.username ]
            ]
        , p []
            [ text "Loading"
            ]
        ]
