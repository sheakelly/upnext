module Main exposing (Model, Msg(..), main, update, view)

import Api.Object
import Api.Object.Task
import Api.Query as Query
import Browser
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData(..))


type alias Task =
    { title : String
    }


type alias TaskList =
    List Task


type alias Model =
    { tasks : RemoteData (Graphql.Http.Error TaskList) TaskList
    }


type Msg
    = RefreshClicked
    | GotResponse (RemoteData (Graphql.Http.Error TaskList) TaskList)


tasksQuery : SelectionSet (List Task) RootQuery
tasksQuery =
    Query.tasks taskSelection


taskSelection : SelectionSet Task Api.Object.Task
taskSelection =
    SelectionSet.map Task
        Api.Object.Task.title


makeRequest : Cmd Msg
makeRequest =
    tasksQuery
        |> Graphql.Http.queryRequest "/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tasks = Loading }, makeRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RefreshClicked ->
            ( model, makeRequest )

        GotResponse response ->
            case response of
                _ ->
                    ( { model | tasks = response }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        tasks =
            List.map viewTask <| RemoteData.withDefault [] model.tasks
    in
    { title = "URL Interceptor"
    , body =
        [ div [] tasks
        ]
    }


viewTask : Task -> Html Msg
viewTask task =
    div [ class "text-purple" ] [ text task.title ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
