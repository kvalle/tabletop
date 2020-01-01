module Model exposing (Model)

import Browser.Navigation as Nav
import Data.GamesRequest exposing (GamesRequest)


type alias Model =
    { username : String
    , gamesRequest : GamesRequest
    , navKey : Nav.Key
    }
