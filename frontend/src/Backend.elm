module Backend exposing (getCollection)

import Data.GamesRequest as GamesRequest exposing (GamesRequest(..))
import Http
import Json.Decode
import Messages exposing (Msg(..))
import Result
import Result.Extra as Result


apiEndpoint =
    "https://ldm35m3519.execute-api.eu-north-1.amazonaws.com/api"


getCollection : String -> Cmd Msg
getCollection username =
    Http.get
        { expect = expectGamesResponse
        , url = apiEndpoint ++ "/collection/" ++ username
        }


expectGamesResponse : Http.Expect Msg
expectGamesResponse =
    let
        decodeWith decoder body =
            Json.Decode.decodeString decoder body
                |> Result.mapError (\err -> Http.BadBody <| Json.Decode.errorToString err)
    in
    Http.expectStringResponse GameCollectionReceived <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (Http.BadUrl url)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata body ->
                    decodeWith GamesRequest.errorDecoder body

                Http.GoodStatus_ metadata body ->
                    if metadata.statusCode == 202 then
                        decodeWith GamesRequest.processingDecoder body

                    else
                        decodeWith GamesRequest.successDecoder body
