defmodule Brdg.Host.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> format_title()
  end

  defp format_title(%Ecto.Changeset{changes: %{title: _}} = changeset) do
    changeset
    |> update_change(:title, fn title ->
      title
      |> String.downcase()
      |> String.replace(" ", "-")
    end)
  end

  defp format_title(changeset), do: changeset
end
