defmodule Livechat.PageControllerTest do
  use Livechat.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Elm Chat"
  end
end
