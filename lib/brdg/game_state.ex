defmodule Brdg.GameState do
  defstruct players_count: 0,
            players: %{n: nil, s: nil, e: nil, w: nil},
            available_positions: [:n, :s, :e, :w],
            hands: %{n: nil, s: nil, e: nil, w: nil},
            # bidding, playing
            state: :waiting,
            current_bet: nil,
            passes_count: 0,
            best_bet: nil,
            current_player: :n

  def bet(state, {:pass}) do
    %{
      state
      | current_bet: {:pass, state.current_player},
        passes_count: state.passes_count + 1,
        current_player: next_player(state.current_player)
    }
  end

  def bet(state, {s, v}) do
    %{
      state
      | current_bet: {s, v, state.current_player},
        best_bet: {s, v, state.current_player},
        passes_count: 0,
        current_player: next_player(state.current_player)
    }
  end

  defp next_player(:n), do: :e
  defp next_player(:e), do: :s
  defp next_player(:s), do: :w
  defp next_player(:w), do: :s

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
