module Picshare exposing (main)

import Html exposing (..)
import Html.Attributes exposing (class, disabled, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode exposing (Decoder, bool, int, list, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Id =
    Int


type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }


type alias Feed =
    List Photo


photoDecoder : Decoder Photo
photoDecoder =
    decode Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> required "comments" (list string)
        |> hardcoded ""


type alias Model =
    { feed : Maybe Feed }


type
    Msg
    -- = ToggleLike
    -- | UpdateComment String
    -- | SaveComment
    = LoadFeed (Result Http.Error Feed)


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchFeed )


initialModel : Model
initialModel =
    { feed = Nothing }


fetchFeed : Cmd Msg
fetchFeed =
    Http.get (baseUrl ++ "feed") (list photoDecoder)
        |> Http.send LoadFeed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- ToggleLike ->
        --     ( { model | photo = updateFeed toggleLike model.photo }, Cmd.none )
        -- UpdateComment comment ->
        --     ( { model | photo = updateFeed (updateComment comment) model.photo }, Cmd.none )
        -- SaveComment ->
        --     ( { model | photo = updateFeed saveNewComment model.photo }, Cmd.none )
        LoadFeed (Ok feed) ->
            ( { model | feed = Just feed }, Cmd.none )

        LoadFeed (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


updateFeed : (Photo -> Photo) -> Maybe Photo -> Maybe Photo
updateFeed updatePhoto maybePhoto =
    Maybe.map updatePhoto maybePhoto


toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }


updateComment : String -> Photo -> Photo
updateComment comment photo =
    { photo | newComment = comment }


saveNewComment : Photo -> Photo
saveNewComment photo =
    case photo.newComment of
        "" ->
            photo

        _ ->
            let
                comment =
                    String.trim photo.newComment
            in
                { photo
                    | comments = photo.comments ++ [ comment ]
                    , newComment = ""
                }


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Picshare" ]
            ]
        , div [ class "content-flow" ]
            [ viewFeed model.feed
            ]
        ]


viewFeed : Maybe Feed -> Html Msg
viewFeed maybeFeed =
    case maybeFeed of
        Just feed ->
            div [] (List.map viewDetailedPhoto feed)

        Nothing ->
            div [ class "loading-feed" ] [ text "Loading ..." ]


viewDetailedPhoto : Photo -> Html Msg
viewDetailedPhoto photo =
    div [ class "detailed-photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-info" ]
            [ viewLikeButton photo
            , h2 [ class "caption" ] [ text photo.caption ]
            , viewComments photo
            ]
        ]


viewLikeButton : Photo -> Html Msg
viewLikeButton photo =
    let
        buttonClass =
            if photo.liked then
                "fa-heart"
            else
                "fa-heart-o"
    in
        div [ class "like-button" ]
            [ i
                [ class "fa fa-2x"
                , class buttonClass
                  -- , onClick ToggleLike
                ]
                []
            ]


viewComments : Photo -> Html Msg
viewComments photo =
    div []
        [ viewCommentList photo.comments
        , form
            [ class "new-comment"
              -- , onSubmit SaveComment
            ]
            [ input
                [ type_ "text"
                , placeholder "Add a comment"
                , value photo.newComment
                  -- , onInput UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty photo.newComment) ] [ text "Save" ]
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
