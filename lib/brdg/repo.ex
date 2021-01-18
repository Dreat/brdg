defmodule Brdg.Repo do
  use Ecto.Repo,
    otp_app: :brdg,
    adapter: Ecto.Adapters.Postgres
end
