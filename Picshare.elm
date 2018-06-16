module Picshare exposing (main)

import Html exposing (Html, beginnerProgram, div, i, img, h1, h2, text)
import Html.Attributes exposing (class, placeholder, src, type_)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }


type alias Model =
    { url : String
    , caption : String
    , liked : Bool
    }


type Msg
    = ToggleLike


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
        ToggleLike ->
            { model | liked = not model.liked }


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
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ viewLikeButton model
            , h2 [ class "caption" ] [ text model.caption ]
            ]
        ]


viewLikeButton : Model -> Html Msg
viewLikeButton model =
    let
        buttonClass =
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"
    in
        div [ class "like-button" ]
            [ i [ class "fa fa-2x", class buttonClass, onClick ToggleLike ] []
            ]


baseUrl : String
baseUrl =
    "https://programming-elm.com/"
