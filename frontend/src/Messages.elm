module Messages exposing (Msg(..))

import Browser
import Data.CollectionResponse exposing (CollectionResponse)
import Http
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GameCollectionReceived (Result Http.Error CollectionResponse)
