module Data.GamesRequest exposing
    ( GamesRequest(..)
    , errorDecoder
    , processingDecoder
    , successDecoder
    )

import Data.Game as Game exposing (Game)
import Json.Decode as Decode exposing (Decoder)


type GamesRequest
    = Requesting
    | BggProcessing
    | Success (List Game)
    | Error String


successDecoder : Decoder GamesRequest
successDecoder =
    Decode.map Success <|
        Decode.field "games" <|
            Decode.list Game.decoder


processingDecoder : Decoder GamesRequest
processingDecoder =
    Decode.field "status" Decode.string
        |> Decode.andThen
            (\status ->
                if status == "PROCESSING" then
                    Decode.succeed BggProcessing

                else
                    Decode.fail <| "Expected status to be 'PROCESSING', but it was '" ++ status ++ "'"
            )


errorDecoder : Decoder GamesRequest
errorDecoder =
    Decode.map Error <|
        Decode.field "message" Decode.string
