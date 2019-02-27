module Main exposing (Model, Msg(..), main, update, view)

import Api.Object
import Api.Object.Task
import Api.Query as Query
import Browser
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html, button, div, i, input, text)
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
    , addMode : Bool
    }


type Msg
    = AddTaskClicked
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
    ( { tasks = Loading, addMode = False }, makeRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTaskClicked ->
            ( { model | addMode = True }, Cmd.none )

        GotResponse response ->
            case response of
                _ ->
                    ( { model | tasks = response }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ viewHeader
        , div [ class "container pt-2" ]
            [ viewTaskList (RemoteData.withDefault [] model.tasks) model.addMode ]
        ]
    }


viewHeader : Html Msg
viewHeader =
    div [ class "p-2 bg-grey text-center" ] [ text "UpNext^" ]


viewTaskList : TaskList -> Bool -> Html Msg
viewTaskList tasks addMode =
    let
        task_ =
            List.map viewTask tasks

        addButton_ =
            if addMode == False then
                addButton

            else
                nothing

        inputField_ =
            if addMode == True then
                inputField

            else
                nothing
    in
    div [ class "relative" ] (task_ ++ [ addButton_ ] ++ [ inputField_ ])


inputField : Html Msg
inputField =
    div [ class "ml-2 flex items-start" ]
        [ input [ class "mr-2 appearance-none border rounded w-full py-2 px-3 text-grey-darker leading-tight focus:outline-none focus:shadow-outline" ] []
        , i [ class "material-icons" ] [ text "cancel" ]
        ]


nothing : Html msg
nothing =
    text ""


addButton : Html Msg
addButton =
    div [ class "pin-b pin-r absolute" ]
        [ i [ class "material-icons", onClick AddTaskClicked ] [ text "add_circle" ] ]


viewTask : Task -> Html Msg
viewTask task =
    div [ class "p-2 text-lg text-black" ] [ text task.title ]


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
