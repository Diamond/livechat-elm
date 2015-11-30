defmodule Livechat.RoomChannel do
  use Phoenix.Channel

  alias Livechat.Repo
  alias Livechat.Message

  def join("rooms:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body, "author" => author}, socket) do
    changeset = Message.changeset(%Message{}, %{body: body, author: author})
    case Repo.insert(changeset) do
      {:ok, _message} ->
        broadcast!(socket, "new_msg", %{body: body, author: author})
        {:noreply, socket}
      {:error, _message} ->
        {:noreply, socket}
    end
  end

  def handle_out("new_msg", payload, socket) do
    {:safe, new_body} = Phoenix.HTML.html_escape(payload["body"])
    push(socket, "new_msg", %{payload | "body" => new_body})
    {:noreply, socket}
  end
end
