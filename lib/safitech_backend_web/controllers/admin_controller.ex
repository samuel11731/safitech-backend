defmodule SafitechBackendWeb.AdminController do
  use SafitechBackendWeb, :controller
  alias SafitechBackend.Messages

  # Explicitly use the new Layouts system
  plug :put_root_layout, {SafitechBackendWeb.Layouts, :root}

  def login_form(conn, _params) do
    render(conn, :login, layout: {SafitechBackendWeb.Layouts, :root})
  end

  def login(conn, %{"password" => password, "email" => email}) do
    if password == "admin123" do
      conn
      |> put_session(:admin_email, email)
      |> redirect(to: "/admin/dashboard")
    else
      conn
      |> put_flash(:error, "Invalid password")
      |> redirect(to: "/admin/login")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:admin_email)
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: "/admin/login")
  end

  def dashboard(conn, _params) do
    case get_session(conn, :admin_email) do
      nil ->
        conn
        |> put_flash(:error, "Please log in first")
        |> redirect(to: "/admin/login")
      _email ->
        messages_count = Messages.list_messages() |> Enum.count()
        unread_count = Messages.list_unread_messages() |> Enum.count()
        render(conn, :dashboard, 
               messages_count: messages_count, 
               unread_count: unread_count,
               layout: {SafitechBackendWeb.Layouts, :root})
    end
  end

  def messages(conn, _params) do
    case get_session(conn, :admin_email) do
      nil ->
        conn
        |> put_flash(:error, "Please log in first")
        |> redirect(to: "/admin/login")
      _email ->
        messages = Messages.list_messages_ordered()
        render(conn, :messages, messages: messages, layout: {SafitechBackendWeb.Layouts, :root})
    end
  end

  def mark_as_read(conn, %{"id" => id}) do
    case get_session(conn, :admin_email) do
      nil -> redirect_to_login(conn)
      _email -> 
        message = Messages.get_message!(id)
        case Messages.update_message(message, %{is_read: true}) do
          {:ok, _} -> conn |> put_flash(:info, "Message marked as read") |> redirect(to: "/admin/messages")
          {:error, _} -> conn |> put_flash(:error, "Failed to mark message as read") |> redirect(to: "/admin/messages")
        end
    end
  end

  def delete_message(conn, %{"id" => id}) do
    case get_session(conn, :admin_email) do
      nil -> redirect_to_login(conn)
      _email -> 
        message = Messages.get_message!(id)
        case Messages.delete_message(message) do
          {:ok, _} -> conn |> put_flash(:info, "Message deleted") |> redirect(to: "/admin/messages")
          {:error, _} -> conn |> put_flash(:error, "Failed to delete message") |> redirect(to: "/admin/messages")
        end
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> put_flash(:error, "Please log in first")
    |> redirect(to: "/admin/login")
  end
end
