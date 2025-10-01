defmodule SafitechBackendWeb.PageController do
  use SafitechBackendWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
