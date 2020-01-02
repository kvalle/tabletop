module Data.CollectionStatus exposing
    ( CollectionStatus(..)
    , Username
    , fromResponse
    , getUsername
    )

import Data.CollectionResponse as CollectionResponse exposing (CollectionResponse)
import Data.Game exposing (Game)


type alias Username =
    String


type CollectionStatus
    = Requesting Username
    | BggProcessing Username
    | Success Username (List Game)
    | Error Username String


getUsername : CollectionStatus -> Username
getUsername collection =
    case collection of
        Requesting username ->
            username

        BggProcessing username ->
            username

        Success username _ ->
            username

        Error username _ ->
            username


fromResponse : Username -> CollectionResponse -> CollectionStatus
fromResponse username response =
    case response of
        CollectionResponse.BggProcessing ->
            BggProcessing username

        CollectionResponse.Success games ->
            Success username games

        CollectionResponse.Error error ->
            Error username error
