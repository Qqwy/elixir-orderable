defmodule ChessPiece do
  @moduledoc """
  An example custom module/struct with custom ordering.
  """

  @piece_types ~w{king queen bishop knight rook pawn}a
  defstruct [:type]
  defguard is_type(piece_type) when piece_type in @piece_types

  def new(type) when is_type(type), do: %__MODULE__{type: type}
  @piece_type_indexes @piece_types |> Enum.with_index |> Enum.into(%{})

  @doc false
  def piece_type_indexes do
    @piece_type_indexes
  end

  defimpl Orderable do
    def ordered(chess_piece) do
      ChessPiece.piece_type_indexes[chess_piece.type]
    end
  end
end

defmodule ChessFighter do
  @moduledoc """
  An example custom module/struct with custom ordering,
  that wraps another custom struct, and has multiple layers of ordering, based on the fields:
  ('sort on owner. If owner is the same, sort on piece type. If piece type is the same, sort on position'.)
  """

  @type owner ::  :player | :opponent

  defstruct [:owner, :piece, :position]
  @type t :: %__MODULE__{owner: owner(), piece: ChessPiece.t(), position: {integer, integer}}

  def new(owner, piece, position) when owner in [:player, :opponent] and tuple_size(position) == 2 do
    %__MODULE__{owner: owner, piece: ChessPiece.new(piece), position: position}
  end


  defimpl Orderable do
    def ordered(%ChessFighter{owner: owner, piece: piece, position: position}) do
      Orderable.ordered({owner_ordered(owner), piece, position})
    end

    defp owner_ordered(:player), do: 0
    defp owner_ordered(:opponent), do: 1
  end
end
