module Model exposing (Model)

import Browser.Navigation as Nav
import Data.CollectionStatus exposing (CollectionStatus)


type alias Model =
    { collection : CollectionStatus
    , navKey : Nav.Key
    }
