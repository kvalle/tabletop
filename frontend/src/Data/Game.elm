module Data.Game exposing (Game, decoder)

import Json.Decode as Decode exposing (Decoder)


type alias Game =
    { id : String
    , title : String
    , imageUrl : String
    , thumbnailUrl : String
    }


decoder : Decoder Game
decoder =
    Decode.map4 Game
        (Decode.field "id" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "image_url" Decode.string)
        (Decode.field "thumbnail_url" Decode.string)
