defmodule SafitechBackendWeb.Router do
  use SafitechBackendWeb, :router

  import SafitechBackendWeb.UserAuth
  alias SafitechBackendWeb.AdminLoginLive

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SafitechBackendWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Admin pipeline
  pipeline :admin do
    plug :require_admin
  end

  # Add this plug function
  defp require_admin(conn, _opts) do
    case get_session(conn, :admin_email) do
      nil ->
        conn
        |> put_flash(:error, "Please log in first")
        |> redirect(to: "/admin/login")
        |> halt()
      _email ->
        conn
    end
  end

  scope "/api", SafitechBackendWeb do
    pipe_through :api
    post "/contact", ContactController, :create
  end

  # Admin routes
  scope "/admin", SafitechBackendWeb do
    pipe_through :browser

    get "/login", AdminController, :login_form
    post "/login", AdminController, :login
    delete "/logout", AdminController, :logout

    # Protected admin routes
    pipe_through :admin
    get "/dashboard", AdminController, :dashboard
    get "/messages", AdminController, :messages
    put "/messages/:id/read", AdminController, :mark_as_read
    delete "/messages/:id", AdminController, :delete_message
  end

  scope "/", SafitechBackendWeb do
    pipe_through :browser
    get "/", PageController, :home
    live "/admin-login", AdminLoginLive
  end

  scope "/", SafitechBackendWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SafitechBackendWeb.UserAuth, :require_authenticated}] do
      live "/users/settings", UserLive.Settings, :edit
      live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/users/update-password", UserSessionController, :update_password
  end

  scope "/", SafitechBackendWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{SafitechBackendWeb.UserAuth, :mount_current_scope}] do
      live "/users/register", UserLive.Registration, :new
      live "/users/log-in", UserLive.Login, :new
      live "/users/log-in/:token", UserLive.Confirmation, :new
    end

    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end
end
