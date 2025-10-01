defmodule SafitechBackend.Repo do
  use Ecto.Repo,
    otp_app: :safitech_backend,
    adapter: Ecto.Adapters.Postgres
end
