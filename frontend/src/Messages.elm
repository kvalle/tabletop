module Messages exposing (Msg(..))

import Browser
import Url


type Msg
    = Noop
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
