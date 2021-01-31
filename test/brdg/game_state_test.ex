defmodule Brdg.GameStateTest do
  use Brdg.DataCase

  alias Brdg.GameState

  describe "add_player/3" do
    test "add first player to state" do
      name = "Eager Player"

      state =
        %GameState{}
        |> GameState.add_player(:n, name)

      assert state.players_count == 1
      assert state.available_positions == [:s, :e, :w]
      assert state.players == %{n: name, s: nil, e: nil, w: nil}
    end

    test "add four players to state" do
      first_name = "First Player"
      second_name = "Second Player"
      third_name = "Third Player"
      fourth_name = "Fourth Player"

      state =
        %GameState{}
        |> GameState.add_player(:n, first_name)
        |> GameState.add_player(:s, second_name)
        |> GameState.add_player(:e, third_name)
        |> GameState.add_player(:w, fourth_name)

      assert state.players_count == 4
      assert state.available_positions == []
      assert state.players == %{n: first_name, s: second_name, e: third_name, w: fourth_name}
    end
  end
end
