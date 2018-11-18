defmodule CustomOrderTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Orderable # <- Doctests turned off because we create a module with a struct in the moduledoc example.

  property "Calling Orderable.ordered on primitive datatypes does not change their sort order" do
    check all list <- list_of(one_of([integer(), float(), binary(), bitstring(), atom(:alphanumeric)])) do
      assert Enum.sort(list) == Enum.sort_by(list, &Orderable.ordered/1)
    end
  end

  test "Custom datatypes with nested implementations" do
    f1 = ChessFighter.new(:player, :king, {3, 3})
    f2 = ChessFighter.new(:player, :bishop, {0, 0})
    f3 = ChessFighter.new(:opponent, :king, {3, 3})
    f4 = ChessFighter.new(:opponent, :bishop, {0, 0})
    f5 = ChessFighter.new(:opponent, :pawn, {0, 0})

    assert [f1, f2, f3, f4, f5] == [f3, f1, f5, f2, f4] |> Enum.sort_by(&Orderable.ordered/1)
  end
end
