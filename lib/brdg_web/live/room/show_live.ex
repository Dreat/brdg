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
    <h2>Select bet 
    <%= if @current.is_pass do %>
      pass
      <% else %>
    <%= @current.suit %><%= @current.value %>
      <% end %>
    <h2>
    <h2>Current bet 
    <%= if @current.is_pass do %>
      pass
      <% else %>
    <%= @current.current %>
      <% end %>
    <%= for h <- @hand do %>
     <%= h %> <br/>
    <% end %>

    <button phx-click="hearts">Clubs</button>
    <button phx-click="hearts">Diamonds</button>
    <button phx-click="hearts">Hearts</button>
    <button phx-click="spades">Spades</button>
    <button phx-click="1">1</button>
    <button phx-click="2">2</button>
    <button phx-click="3">3</button>
    <button phx-click="4">4</button>
    <button phx-click="5">5</button>
    <button phx-click="6">6</button>
    <button phx-click="7">7</button>

    <button phx-click="pass">pass</button>

    <button phx-click="bet">bet</button>
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
         |> assign(:current, %{suit: "", value: "", current: "", is_pass: false})}
    end
  end

  @impl true
  def handle_event("clubs", _, socket) do
    current = socket.assigns.current
    current = %{current | suit: "clubs"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("diamonds", _, socket) do
    current = socket.assigns.current
    current = %{current | suit: "diamonds"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("hearts", _, socket) do
    current = socket.assigns.current
    current = %{current | suit: "hearts"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("spades", _, socket) do
    current = socket.assigns.current
    current = %{current | suit: "spades"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("1", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "1"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("2", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "2"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("3", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "3"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("4", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "4"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("5", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "5"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("6", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "6"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("7", _, socket) do
    current = socket.assigns.current
    current = %{current | value: "7"}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("pass", _, socket) do
    current = socket.assigns.current
    current = %{current | is_pass: !current.is_pass}

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  @impl true
  def handle_event("bet", _, socket) do
    current = socket.assigns.current

    current =
      if current.is_pass do
        %{current | current: "pass"}
      else
        %{current | current: "#{current.value} #{current.suit}"}
      end

    {:noreply,
     socket
     |> assign(:current, current)}
  end

  defp translate_atoms({suit, value}) do
    "#{suit} #{value}\n"
  end
end
