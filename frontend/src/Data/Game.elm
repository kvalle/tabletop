module Data.Game exposing (Game, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias Game =
    { id : String
    }


decoder : Decoder Game
decoder =
    Decode.map Game <|
        Decode.field "id" Decode.string
