module LiveChat where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import StartApp.Simple as StartApp

-- MODEL
type alias Model =
  { author : String, newMessage : String, messages : List String, outgoingMessage : String }

initialModel : Model
initialModel =
  { author = "Guest", newMessage = "", messages = [], outgoingMessage = "" }

messageFromModel : Model -> String
messageFromModel model =
  "<" ++ model.author ++ "> " ++ model.newMessage

-- UPDATE
type Action = NoOp | Add String | UpdateMessage String | UpdateAuthor String | Send

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    Add message ->
      { model | messages = model.messages ++ [message] }
    UpdateMessage message ->
      { model | newMessage = message }
    UpdateAuthor author ->
      { model | author = author }
    Send ->
      { model |
        outgoingMessage = messageFromModel model,
        newMessage = ""
      }

-- VIEW
message : String -> Html
message msg =
  li [ class "message" ] [ text msg ]

entryForm : Signal.Address Action -> Model -> Html
entryForm address model =
  div [ class "chat-form" ] [
    input [
      type' "text",
      placeholder "Guest",
      class "author-entry",
      value model.author,
      on "input" targetValue (Signal.message address << UpdateAuthor),
      id "author-input"
    ] [ ],
    input [
      type' "text",
      placeholder "Enter your message here...",
      class "message-entry",
      value model.newMessage,
      on "input" targetValue (Signal.message address << UpdateMessage),
      id "chat-input",
      size 70
    ] [ ],
    button [ onClick address Send ] [
      text "Send"
    ]
  ]

view : Signal.Address Action -> Model -> Html
view address model =
  div [ class "display-chat" ] [
    h2 [ class "banner" ] [ text "LiveChat" ],
    ul [ class "chat-log" ] (List.map message model.messages),
    entryForm address model
  ]

-- PORTS
port incomingMessages : Signal String

port outgoingMessage : Signal String
port outgoingMessage =
  Signal.dropRepeats (Signal.map .outgoingMessage model)

-- MAIN
inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

actions : Signal Action
actions =
  Signal.merge inbox.signal (Signal.dropRepeats (Signal.map Add incomingMessages))

model : Signal Model
model =
  Signal.foldp update initialModel actions

main : Signal Html
main =
  Signal.map (view inbox.address) model
