defprotocol Orderable do
  @moduledoc """


  Orderable is a simple Elixir package that allows you to make your custom data types orderable, so you can:

  - Compare them
  - Sort them

  ## How to write an implementation for my datatype?

  There is only a single function to implement: `Orderable.ordered/1`.
  This function should return a datatype that can be used with Erlang's built-in ordering to decide which is 'first'.
  In general, use:

  - Integers if you have a predefined, strict order.
  - Floats if you have some calculations that make it difficult or impractical to work with integers.
  - Strings/symbols will be ordered alphabetically (unicode-codepoint ordering).

  Tuples can be used to return an ordering whose second element only is considered if the first element is the same (and the third is only used if the second elements are the same, etc.)
  So if you have a struct `%Address{city: String.t, street: String.t, house_number: integer}` that you'd like to sort, you could implement it as follows:

      defimpl Orderable, for: Address do
        def ordered(address) do
          Orderable.ordered({address.city, address.street, address.house_number})
        end
      end

  This will sort by city, and if they match by street, and if they match by house number.

  Note also that we call `Orderable.ordered` recursively on the tuple we are building.
  While this is only required if you know you might have custom values inside your data structur
  (for which Orderable might also be implemented), it is considered good style, so you do not forget it later on when your data model changes.
  For lists and tuples, Orderable.ordered will be called for each of the elements automatically.

  ## Full-scale Example

  An example of a custom data structure that you'd want to order:

      defmodule Rating do
        defstruct [:subject, :rating, :user]
        @ratings ~w{bad mediocre neutral good superb}a

        def new(subject, rating, user), do: %__MODULE__{subject: subject, rating: rating, user: user}

        @ratings_indexes @ratings |> Enum.with_index |> Enum.into(%{})

        @doc false
        def ratings_indexes do
          @ratings_indexes
        end

        defimpl Orderable do
          def ordered(rating) do
            Orderable.ordered({rating.subject, Rating.ratings_indexes[rating.rating], rating.user})
          end
        end
      end

  Now, you can use it as follows:

      iex> rating1 = Rating.new("Elixir", :superb, "Qqwy")
      iex> rating2 = Rating.new("Erlang", :good, "Qqwy")
      iex> rating3 = Rating.new("Peanut Butter", :bad, "Qqwy")
      iex> rating4 = Rating.new("Doing the Dishes", :neutral, "Qqwy")
      iex> rating5 = Rating.new("Elixir", :superb, "Nobbz")
      iex> rating6 = Rating.new("Elixir", :neutral, "Timmy the Cat")
      iex> unsorted = [rating1, rating2, rating3, rating4, rating5, rating6]
      iex> unsorted |> Enum.sort_by(&Orderable.ordered/1)
      [
        %Rating{rating: :neutral, subject: "Doing the Dishes", user: "Qqwy"},
        %Rating{rating: :neutral, subject: "Elixir", user: "Timmy the Cat"},
        %Rating{rating: :superb, subject: "Elixir", user: "Nobbz"},
        %Rating{rating: :superb, subject: "Elixir", user: "Qqwy"},
        %Rating{rating: :good, subject: "Erlang", user: "Qqwy"},
        %Rating{rating: :bad, subject: "Peanut Butter", user: "Qqwy"}
      ]

  ## default protocol implementations

  Default implementations exist for all datatypes that are common to be compared.

  For the following primitive values, calling `Orderable.ordered` is a no-op:

  - Integers
  - Floats
  - Binaries
  - Atoms

  For the following ordered collection types, Orderable.ordered will automatically be called for each element:

  - Lists
  - Tuples

  There are no default implementations for Maps, MapSets and other set-like things,
  because these datatypes are only partially ordered (when using the common subset-based way of ordering things.)

  There are also no default implementations for Functions, Pids, Ports and References,
  because those are not things we usually order in a _semantical_ way (They are part of the built-in Erlang ordering only
  so they can immediately be used as unique keys inside dictionary-like datatypes).

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
