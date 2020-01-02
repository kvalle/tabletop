module Backend exposing (getCollection)

import Data.CollectionResponse as CollectionResponse exposing (CollectionResponse(..))
import Http
import Json.Decode
import Result
import Result.Extra as Result
import Task exposing (Task)


apiEndpoint =
    "https://ldm35m3519.execute-api.eu-north-1.amazonaws.com/api"


getCollection : String -> Task Http.Error CollectionResponse
getCollection username =
    Http.task
        { method = "GET"
        , headers = []
        , body = Http.emptyBody
        , timeout = Nothing
        , resolver = gamesRequestResolver
        , url = apiEndpoint ++ "/collection/" ++ username
        }


gamesRequestResolver : Http.Resolver Http.Error CollectionResponse
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
                    decodeWith CollectionResponse.errorDecoder body

                Http.GoodStatus_ metadata body ->
                    if metadata.statusCode == 202 then
                        decodeWith CollectionResponse.processingDecoder body

                    else
                        decodeWith CollectionResponse.successDecoder body
