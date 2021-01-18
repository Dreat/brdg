defmodule Brdg.Cards do

  @suits [:clubs, :diamonds, :hearts, :spades]
  @values [2, 3, 4, 5, 6, 7, 8, 9, 10, "w", "q", "k", "a"]


  def deck do
    for s <- @suits, v <- @values, do: {s, v}
  end

  def deal_hands() do
    deck()
    |> Enum.shuffle()
    |> Enum.slice(0..11)
  end


end
