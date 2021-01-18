defmodule Brdg.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :title, :string

      timestamps()
    end

    create unique_index(:rooms, :title)
  end
end
