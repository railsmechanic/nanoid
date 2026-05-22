defmodule Nanoid.NonSecure do
  @moduledoc """
  Generate a URL-friendly unique ID using the non-secure, predictable `:rand` PRNG.

  By default the ID has 21 symbols, with a collision probability similar to UUID v4.

  Use `generate/0` for the all-defaults shortcut, or `generate_with/1` with
  `:size` and/or `:alphabet` for custom IDs. The positional `generate/1,2`
  variants remain available for backward compatibility but are deprecated.
  """
  alias Nanoid.Configuration

  @doc """
  Generates a non-secure NanoID using a keyword list of options.

  Always pass at least one option — for the no-options shortcut, use `generate/0`.

  ## Options
    * `:size` - the desired ID length in symbols (defaults to `Nanoid.Configuration.default_size/0`)
    * `:alphabet` - the alphabet to draw from, as a binary or charlist
      (defaults to `Nanoid.Configuration.default_alphabet/0`).
      Multi-byte graphemes (e.g. `"äöü"` or emoji) are supported.

  ## Examples
      iex> Nanoid.NonSecure.generate_with(size: 16)
      "IRFa-VaY2b-NU5xX"

      iex> Nanoid.NonSecure.generate_with(alphabet: "abcdef123")
      "d1dcd2dee333cae1bfdea"

      iex> Nanoid.NonSecure.generate_with(size: 12, alphabet: "abcdef123")
      "d1dcd2dee333"
  """
  @spec generate_with(keyword()) :: binary()
  def generate_with(opts) when is_list(opts) do
    size = Keyword.get(opts, :size, Configuration.default_size())

    case Keyword.fetch(opts, :alphabet) do
      {:ok, alphabet} -> generate_custom(size, alphabet)
      :error -> generate_default(size)
    end
  end

  @doc """
  Generates a non-secure NanoID using the default size and alphabet.

  Quick-access shortcut, equivalent to `generate_with([])`.

  ## Example
      iex> Nanoid.NonSecure.generate()
      "mJUHrGXZBZpNX50x2xkzf"
  """
  @spec generate :: binary()
  def generate, do: generate_with([])

  @deprecated "Use Nanoid.NonSecure.generate_with/1 instead"
  @doc """
  Generates a non-secure NanoID with the given size.

  Deprecated — use `generate_with(size: size)`.
  """
  @spec generate(non_neg_integer()) :: binary()
  def generate(size) when is_integer(size) and size > 0,
    do: generate_with(size: size)

  def generate(_size), do: generate_with([])

  @deprecated "Use Nanoid.NonSecure.generate_with/1 instead"
  @doc """
  Generate a non-secure NanoID using a custom size and an individual alphabet.

  Deprecated — use `generate_with/1` with the `:size` and `:alphabet` options instead:

      Nanoid.NonSecure.generate_with(size: 12, alphabet: "abcdef123")
  """
  @spec generate(non_neg_integer(), binary() | list()) :: binary()
  def generate(size, alphabet)

  def generate(size, alphabet) when is_integer(size) and size > 0 and (is_binary(alphabet) or is_list(alphabet)),
    do: generate_with(size: size, alphabet: alphabet)

  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate_with(size: size)

  def generate(_size, _alphabet),
    do: generate_with([])

  defp generate_default(size) when is_integer(size) and size > 0 do
    pick_symbols(size, Configuration.default_alphabet_tuple(), Configuration.default_alphabet_length())
  end

  defp generate_custom(size, alphabet) when is_integer(size) and size > 0 and is_binary(alphabet) do
    alphabet_tuple = alphabet |> String.graphemes() |> List.to_tuple()
    generate_from_tuple(size, alphabet_tuple)
  end

  defp generate_custom(size, alphabet) when is_integer(size) and size > 0 and is_list(alphabet) do
    generate_from_tuple(size, List.to_tuple(alphabet))
  end

  defp generate_from_tuple(size, alphabet_tuple) do
    alphabet_length = tuple_size(alphabet_tuple)

    if alphabet_length > 1 do
      pick_symbols(size, alphabet_tuple, alphabet_length)
    else
      raise ArgumentError, "alphabet must contain at least two symbols"
    end
  end

  defp pick_symbols(size, alphabet_tuple, alphabet_length) do
    for _ <- 1..size, into: [] do
      elem(alphabet_tuple, :rand.uniform(alphabet_length) - 1)
    end
    |> IO.iodata_to_binary()
  end
end
