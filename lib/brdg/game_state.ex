defmodule Brdg.GameState do
  defstruct players_count: 0,
            players: %{n: nil, s: nil, e: nil, w: nil},
            available_positions: [:n, :s, :e, :w],
            hands: %{n: nil, s: nil, e: nil, w: nil},
            # bidding, playing
            state: :waiting,
            current_bid: nil,
            passes_count: 0,
            best_bid: nil,
            current_player: :n

  def bid(%{best_bid: nil, passes_count: 3} = state, {:pass}) do
    %{
      state
      | state: :restart
    }
  end

  def bid(%{passes_count: 2, best_bid: {s, v, p}} = state, {:pass}) do
    %{
      state
      | state: :playing
    }
  end

  def bid(state, {:pass}) do
    %{
      state
      | current_bid: {:pass, state.current_player},
        passes_count: state.passes_count + 1,
        current_player: next_player(state.current_player)
    }
  end

  def bid(state, {s, v}) do
    %{
      state
      | current_bid: {s, v, state.current_player},
        best_bid: {s, v, state.current_player},
        passes_count: 0,
        current_player: next_player(state.current_player)
    }
  end

  defp next_player(:n), do: :e
  defp next_player(:e), do: :s
  defp next_player(:s), do: :w
  defp next_player(:w), do: :s

  defp paired_player(:n), do: :s
  defp paired_player(:s), do: :n
  defp paired_player(:w), do: :e
  defp paired_player(:e), do: :w

  def create_grandpa(state) do
    {_, _, player1_position} = state.best_bid

    grandpa_position = player1_position |> paired_player

    case state.players[grandpa_position] do
      nil -> create_grandpa(state, grandpa_position)
      _ -> change_position(state, grandpa_position) |> create_grandpa(grandpa_position)
    end
  end

  defp change_position(state, _), do: state

  defp create_grandpa(%{players: players} = state, :n) do
    players = %{players | n: "grandpa"}

    %{
      state | players: players
    }
  end

  defp create_grandpa(%{players: players} = state, :s) do
    players = %{players | s: "grandpa"}

    %{
      state
      | players: players
    }
  end

  defp create_grandpa(%{players: players} = state, :e) do
    players = %{players | e: "grandpa"}

    %{
      state
      | players: players
    }
  end

  defp create_grandpa(%{players: players} = state, :w) do
    players = %{players | w: "grandpa"}

    %{
      state
      | players: players
    }
  end

  def change_state(state, new_state) do
    %{state | state: new_state}
  end

  def deal_hands(state) do
    deck = Brdg.Cards.shuffle_deck()
    result = deal_hands(deck, %{n: [], s: [], e: [], w: []})

    %{state | hands: result}
  end

  defp deal_hands([], result) do
    result
  end

  defp deal_hands(deck, %{n: h1, s: h2, e: h3, w: h4}) do
    [n, s, e, w] ++ rest = deck

    deal_hands(rest, %{n: h1 ++ [n], s: h2 ++ [s], e: h3 ++ [e], w: h4 ++ [w]})
  end

  def add_player(state, :n, name) do
    players_count = state.players_count + 1
    players = %{state.players | n: name}
    available_positions = Enum.filter(state.available_positions, fn x -> x != :n end)

    %{
      state
      | players_count: players_count,
        players: players,
        available_positions: available_positions
    }
  end

  def add_player(state, :s, name) do
    players_count = state.players_count + 1
    players = %{state.players | s: name}
    available_positions = Enum.filter(state.available_positions, fn x -> x != :s end)

    %{
      state
      | players_count: players_count,
        players: players,
        available_positions: available_positions
    }
  end

  def add_player(state, :e, name) do
    players_count = state.players_count + 1
    players = %{state.players | e: name}
    available_positions = Enum.filter(state.available_positions, fn x -> x != :e end)

    %{
      state
      | players_count: players_count,
        players: players,
        available_positions: available_positions
    }
  end

  def add_player(state, :w, name) do
    players_count = state.players_count + 1
    players = %{state.players | w: name}
    available_positions = Enum.filter(state.available_positions, fn x -> x != :w end)

    %{
      state
      | players_count: players_count,
        players: players,
        available_positions: available_positions
    }
  end
end
