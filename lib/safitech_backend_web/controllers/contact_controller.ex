defmodule SafitechBackendWeb.ContactController do
  use SafitechBackendWeb, :controller
  
  alias SafitechBackend.Messages

  def create(conn, params) do
    case Messages.create_message(params) do
      {:ok, message} ->
        conn
        |> put_status(:created)
        |> json(%{
          success: true,
          message: "Message sent successfully!",
          id: message.id
        })

      {:error, changeset} ->
        errors = translate_errors(changeset)
        
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          success: false,
          errors: errors
        })
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
