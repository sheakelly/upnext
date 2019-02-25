module Main exposing (Model, Msg(..), main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))
import Graphql.Operation exposing (RootQuery)
import Graphql.Http
import Graphql.SelectionSet exposing (SelectionSet, with)
import Api.Query as Query
import Api.Object

type alias Task =
    { title : String
    }

type alias Model =
    { tasks : RemoteData (Graphql.Http.Error (List Task)) (List Task)
    }


type Msg
    = RefreshClicked


query : SelectionSet (List Task) RootQuery
query =
    Query.tasks (List Task)
        |> with (Query.tasks task)


taskSelection : SelectionSet Task Api.Object.Task
taskSelection =
    Task.selection Task
        |> with Task.title


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tasks = Loading }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RefreshClicked ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ div []
            [ button [ onClick RefreshClicked ] [ text "Refresh" ]
            ]
        ]
    }


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
