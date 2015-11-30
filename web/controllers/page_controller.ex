defmodule Livechat.PageController do
  use Livechat.Web, :controller

  alias Livechat.Message

  def index(conn, _params) do
    messages = Repo.all(from m in Message, order_by: [desc: :inserted_at], limit: 10)
    render conn, "index.html", messages: Enum.reverse(messages)
  end
end
