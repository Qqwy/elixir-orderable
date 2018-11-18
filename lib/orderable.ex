defprotocol Orderable do
  @moduledoc """

  There are no default implementations for Maps, MapSets and other set-like things,
  because these datatypes are only partially ordered (when using the common subset-based way of ordering things.)

  There are also no default implementations for Functions, Pids, Ports and References,
  because those are not things we usually order in a _semantical_ way (They are ordered only
  so they can be used as unique keys inside dictionary-like datatypes).


  }> Enum.sort_by(&Orderable.ordered/1)
  """

  @spec ordered(Orderable.t) :: any()
  def ordered(thing)
end

defimpl Orderable, for: [Atom, BitString, Integer, Float] do
  def ordered(already_ordered_primitive), do: already_ordered_primitive
end


defimpl Orderable, for: List do
  def ordered(things) do
    things
    |> Enum.map(&Orderable.ordered/1)
  end
end

defimpl Orderable, for: Tuple do
  def ordered(things_tuple) do
    things_tuple
    |> Tuple.to_list
    |> Enum.map(&Orderable.ordered/1)
    |> List.to_tuple
  end
end
