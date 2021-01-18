defmodule BrdgWeb.Room.ShowLive do
  @moduledoc """
  A LiveView for creating and joining game rooms.
  """

  use BrdgWeb, :live_view

  alias Brdg.Cards
  alias Brdg.Host

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @room.title %></h1>
    <h2>Current bet <%= @current.suit %><%= @current.value %><h2>
    <%= for h <- @hand do %>
     <%= h %> <br/>
    <% end %>

    <button phx-click="hearts">Hearts</button>
    <button phx-click="spades">Spades</button>
    <button phx-click="1">1</button>
    <button phx-click="2">2</button>
    """
  end

  @impl true
  def mount(%{"title" => title}, _session, socket) do
    hand = Cards.deal_hands() |> Enum.map(&translate_atoms(&1))
    case Host.get_room(title) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "That room does not exist.")
         |> push_redirect(to: Routes.new_path(socket, :new))}

      room ->
        {:ok,
         socket
         |> assign(:room, room)
         |> assign(:hand, hand)
         |> assign(:current, %{suit: "", value: ""})
        }
    end
  end

  @impl true
  def handle_event("hearts", _, socket) do
    current = socket.assigns.current
    current = %{current | suit: "hearts"}
    {:noreply,
      socket
      |> assign(:current, current)
    }
  end

  @impl true
  def handle_event("spades", _, socket) do
    current = socket.assigns.current
    current = %{current | suit: "spades"}
    {:noreply,
      socket
      |> assign(:current, current)
    }
  end

  @impl true
  def handle_event("1", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "1"}
    {:noreply,
      socket
      |> assign(:current, current)
    }
  end

  @impl true
  def handle_event("2", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "2"}
    {:noreply,
      socket
      |> assign(:current, current)
    }
  end

  defp translate_atoms({suit, value}) do
    "#{suit} #{value}\n"
  end
end
