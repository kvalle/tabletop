module Data.CollectionResponse exposing
    ( CollectionResponse(..)
    , errorDecoder
    , processingDecoder
    , successDecoder
    )

import Data.Game as Game exposing (Game)
import Json.Decode as Decode exposing (Decoder)


type CollectionResponse
    = BggProcessing
    | Success (List Game)
    | Error String


successDecoder : Decoder CollectionResponse
successDecoder =
    Decode.map Success <|
        Decode.field "games" <|
            Decode.list Game.decoder


processingDecoder : Decoder CollectionResponse
processingDecoder =
    Decode.field "status" Decode.string
        |> Decode.andThen
            (\status ->
                if status == "PROCESSING" then
                    Decode.succeed BggProcessing

                else
                    Decode.fail <| "Expected status to be 'PROCESSING', but it was '" ++ status ++ "'"
            )


errorDecoder : Decoder CollectionResponse
errorDecoder =
    Decode.map Error <|
        Decode.field "message" Decode.string
