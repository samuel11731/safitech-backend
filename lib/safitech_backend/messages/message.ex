defmodule SafitechBackend.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :name, :string
    field :email, :string
    field :subject, :string
    field :body, :string
    field :is_read, :boolean, default: false  # Add this line

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :email, :subject, :body, :is_read])  # Add :is_read here
    |> validate_required([:name, :email, :subject, :body])
  end
end
