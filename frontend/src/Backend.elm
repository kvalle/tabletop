module Backend exposing (getCollection)

import Data.GamesRequest as GamesRequest exposing (GamesRequest(..))
import Http
import Json.Decode
import Result
import Result.Extra as Result
import Task exposing (Task)


apiEndpoint =
    "https://ldm35m3519.execute-api.eu-north-1.amazonaws.com/api"


getCollection : String -> Task Http.Error GamesRequest
getCollection username =
    Http.task
        { method = "GET"
        , headers = []
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = gamesRequestResolver
        , url = apiEndpoint ++ "/collection/" ++ username
        }


gamesRequestResolver : Http.Resolver Http.Error GamesRequest
gamesRequestResolver =
    let
        decodeWith decoder body =
            Json.Decode.decodeString decoder body
                |> Result.mapError (\err -> Http.BadBody <| Json.Decode.errorToString err)
    in
    Http.stringResolver <|
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
