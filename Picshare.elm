module Picshare exposing (main)

import Html exposing (Html, beginnerProgram, div, i, img, h1, h2, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }


type alias Model =
    { url : String, caption : String, liked : Bool }


type Msg
    = Like
    | Unlike


initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfer"
    , liked = False
    }


update :
    Msg
    -> Model
    -> Model
update msg model =
    case msg of
        Like ->
            { model | liked = True }

        Unlike ->
            { model | liked = False }


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare" ]
            ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model
            ]
        ]


viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"

        msg =
            if model.liked then
                Unlike
            else
                Like
    in
        div [ class "detailed-photo" ]
            [ img [ src model.url ] []
            , div [ class "photo-info" ]
                [ div [ class "like-button" ]
                    [ i [ class "fa fa-2x", class buttonClass, onClick msg ] []
                    ]
                , h2 [ class "caption" ] [ text model.caption ]
                ]
            ]


baseUrl : String
baseUrl =
    "https://programming-elm.com/"
