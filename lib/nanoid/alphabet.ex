defmodule Nanoid.Alphabet do
  @moduledoc """
  Validation and normalisation of the inputs accepted by the generators.

  This module centralises the checks for the two generator options:

    * `convert_alphabet/1` turns an alphabet into a grapheme tuple for O(1) symbol lookup.
    * `validate_size/1` validates a requested ID length.

  Both functions are pure and never raise: they return `{:ok, value}` on success
  or `:error` on invalid input, leaving the decision of how to react (raise,
  fall back to a default, …) to the caller.

  Alphabets may be given as a binary (e.g. `"abcdef"`) or a charlist
  (e.g. `~c"abcdef"`). Multi-byte graphemes such as `"äöü"` or emoji are
  supported, since the alphabet is split with `String.graphemes/1` rather than
  by byte.
  """

  @doc """
  Converts an alphabet into a tuple of graphemes for O(1) symbol lookup.

  Returns `{:ok, tuple}` when the alphabet contains at least two symbols,
  or `:error` otherwise. Charlists are converted via `List.to_string/1`,
  which is Unicode-aware.

  ## Examples
      iex> Nanoid.Alphabet.convert_alphabet("abc")
      {:ok, {"a", "b", "c"}}

      iex> Nanoid.Alphabet.convert_alphabet(~c"abc")
      {:ok, {"a", "b", "c"}}

      iex> Nanoid.Alphabet.convert_alphabet("äöü")
      {:ok, {"ä", "ö", "ü"}}

      iex> Nanoid.Alphabet.convert_alphabet("a")
      :error

      iex> Nanoid.Alphabet.convert_alphabet("ä")
      :error
  """
  @spec convert_alphabet(binary() | charlist()) :: {:ok, tuple()} | :error
  def convert_alphabet(alphabet) when is_list(alphabet),
    do: alphabet |> List.to_string() |> convert_alphabet()

  def convert_alphabet(alphabet) when is_binary(alphabet) do
    tuple = alphabet |> String.graphemes() |> List.to_tuple()

    if tuple_size(tuple) > 1, do: {:ok, tuple}, else: :error
  end

  @doc """
  Validates a requested ID size.

  Returns `{:ok, size}` for a positive integer, or `:error` otherwise.

  ## Examples
      iex> Nanoid.Alphabet.validate_size(16)
      {:ok, 16}

      iex> Nanoid.Alphabet.validate_size(0)
      :error

      iex> Nanoid.Alphabet.validate_size(-5)
      :error

      iex> Nanoid.Alphabet.validate_size("16")
      :error
  """
  @spec validate_size(term()) :: {:ok, pos_integer()} | :error
  def validate_size(size) when is_integer(size) and size > 0, do: {:ok, size}
  def validate_size(_size), do: :error
end
