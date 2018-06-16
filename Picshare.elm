module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)


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
    , comments : List String
    , newComment : String
    }


type Msg
    = ToggleLike
    | UpdateComment String
    | SaveComment


initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfer"
    , liked = False
    , comments = []
    , newComment = ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleLike ->
            { model | liked = not model.liked }

        UpdateComment comment ->
            { model | newComment = comment }

        SaveComment ->
            saveNewComment model


saveNewComment : Model -> Model
saveNewComment model =
    case model.newComment of
        "" ->
            model

        _ ->
            let
                comment =
                    String.trim model.newComment
            in
                { model
                    | comments = model.comments ++ [ comment ]
                    , newComment = ""
                }


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
            , viewComments model
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


viewComments : Model -> Html Msg
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment", onSubmit SaveComment ]
            [ input
                [ type_ "text"
                , placeholder "Add a comment"
                , value model.newComment
                , onInput UpdateComment
                ]
                []
            , button [] [ text "Save" ]
            ]
        ]


viewCommentList : List String -> Html Msg
viewCommentList comments =
    div [ class "comments" ]
        [ ul [] (List.map viewComment comments)
        ]


viewComment : String -> Html Msg
viewComment comment =
    li []
        [ strong [] [ text "Comment: " ]
        , text comment
        ]


baseUrl : String
baseUrl =
    "https://programming-elm.com/"
