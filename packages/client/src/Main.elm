module Main exposing (Model, Msg(..), main, update, view)

import Api.Mutation as Mutation
import Api.Object
import Api.Object.Task
import Api.Query as Query
import Browser
import Browser.Dom
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (Html, button, div, i, input, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick, onInput)
import Keyboard exposing (Key(..))
import Keyboard.Events as Keyboard
import RemoteData exposing (RemoteData(..))
import Task


type alias Task =
    { title : String
    }


setTitle : String -> Task -> Task
setTitle title task =
    { task | title = title }


type alias TaskList =
    List Task


type alias Model =
    { tasks : TaskList
    , addMode : Bool
    , newTask : Maybe Task
    }


type Msg
    = AddTaskClicked
    | CancelAddClicked
    | SaveNewTask
    | NewTaskTitleChanged String
    | QueryTasksResponse (Result (Graphql.Http.Error TaskList) TaskList)
    | CreateTaskResponse (Result (Graphql.Http.Error Task) Task)
    | Focus (Result Browser.Dom.Error ())


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
        |> Graphql.Http.send QueryTasksResponse


createTaskMutation : String -> SelectionSet Task RootMutation
createTaskMutation title =
    Mutation.createTask { title = title } taskSelection


createTask : String -> Cmd Msg
createTask title =
    createTaskMutation title
        |> Graphql.Http.mutationRequest "/graphql"
        |> Graphql.Http.send CreateTaskResponse


init : () -> ( Model, Cmd Msg )
init _ =
    ( { tasks = [], addMode = False, newTask = Nothing }, makeRequest )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTaskClicked ->
            ( setAddMode model, focusNewTask )

        CancelAddClicked ->
            ( { model | addMode = False }, Cmd.none )

        NewTaskTitleChanged value ->
            let
                updated =
                    Maybe.map (setTitle value) model.newTask
            in
            ( { model | newTask = updated }, Cmd.none )

        SaveNewTask ->
            case model.newTask of
                Just newTask ->
                    ( addTaskToModel newTask model
                        |> andThen (\m -> { m | addMode = False })
                    , createTask newTask.title
                    )

                Nothing ->
                    ( model, Cmd.none )

        Focus _ ->
            ( model, Cmd.none )

        QueryTasksResponse response ->
            case response of
                Ok tasks ->
                    ( { model | tasks = tasks }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        CreateTaskResponse response ->
            ( model, Cmd.none )


andThen : (Model -> Model) -> Model -> Model
andThen fn model =
    fn model


addTaskToModel : Task -> Model -> Model
addTaskToModel task model =
    { model | tasks = List.append model.tasks [ task ] }


setAddMode : Model -> Model
setAddMode model =
    let
        newTask =
            case model.newTask of
                Just _ ->
                    model.newTask

                Nothing ->
                    Just { title = "" }
    in
    { model | addMode = True, newTask = newTask }


view : Model -> Browser.Document Msg
view model =
    { title = "UpNext^"
    , body =
        [ viewHeader
        , div [ class "container pt-2" ]
            [ viewTaskList model.tasks model.addMode ]
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
                div [ class "pt-2 pl-1" ] [ icon "add_circle" AddTaskClicked ]

            else
                nothing

        inputField_ =
            if addMode == True then
                inputField

            else
                nothing
    in
    div [] (task_ ++ [ addButton_ ] ++ [ inputField_ ])


inputField : Html Msg
inputField =
    div [ class "p-2 flex items-center" ]
        [ input
            [ id "new-task"
            , class "mr-2 appearance-none border rounded w-full py-2 px-3 text-grey-darker leading-tight focus:outline-none focus:shadow-outline"
            , onInput NewTaskTitleChanged
            , Keyboard.onKeyDown [ ( Enter, SaveNewTask ) ]
            ]
            []
        , icon "cancel" CancelAddClicked
        ]


focusNewTask : Cmd Msg
focusNewTask =
    Task.attempt Focus (Browser.Dom.focus "new-task")


nothing : Html msg
nothing =
    text ""


addButton : Html Msg
addButton =
    i [ class "p-2 material-icons text-3xl", onClick AddTaskClicked ] [ text "add_circle" ]


icon : String -> msg -> Html msg
icon name onClick_ =
    i [ class "material-icons text-3xl", onClick onClick_ ] [ text name ]


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
