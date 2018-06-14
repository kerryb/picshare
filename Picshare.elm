module Picshare exposing (main)

import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (class)


main : Html msg
main =
    div [ class "header" ] [ h1 [] [ text "Picshare" ] ]
