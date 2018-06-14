module Picshare exposing (main)

import Html exposing (Html, div, img, h1, h2, text)
import Html.Attributes exposing (class, src)


main : Html msg
main =
    view initialModel


initialModel : { url : String, caption : String }
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfer"
    }


view : { url : String, caption : String } -> Html msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare" ]
            ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model
            ]
        ]


viewDetailedPhoto : { url : String, caption : String } -> Html msg
viewDetailedPhoto model =
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ h2 [ class "caption" ] [ text model.caption ]
            ]
        ]


baseUrl : String
baseUrl =
    "https://programming-elm.com/"
