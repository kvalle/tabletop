module Data.Username exposing (Username, fromString, toString)


type Username
    = Username String


toString : Username -> String
toString (Username string) =
    string


fromString : String -> Username
fromString =
    Username
