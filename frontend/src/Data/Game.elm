module Data.Game exposing (Game, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias Game =
    { id : String
    , title : String
    }


decoder : Decoder Game
decoder =
    Decode.map2 Game
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
