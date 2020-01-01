module Messages exposing (Msg(..))

import Browser
import Data.GamesRequest exposing (GamesRequest)
import Http
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GameCollectionReceived (Result Http.Error GamesRequest)
