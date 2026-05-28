defmodule Nanoid.NonSecure do
  @moduledoc """
  Generate a URL-friendly unique ID using the non-secure, predictable `:rand` PRNG.

  By default the ID has 21 symbols, with a collision probability similar to UUID v4.

  Use `generate/0` for the all-defaults shortcut, or `generate_with/1` with
  `:size` and/or `:alphabet` for custom IDs. The positional `generate/1,2`
  variants remain available for backward compatibility but are deprecated.
  """
  alias Nanoid.Alphabet
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

  def generate(_size),
    do: generate_with([])

  @deprecated "Use Nanoid.NonSecure.generate_with/1 instead"
  @doc """
  Generate a non-secure NanoID using a custom size and an individual alphabet.

  Deprecated — use `generate_with/1` with the `:size` and `:alphabet` options instead:

      Nanoid.NonSecure.generate_with(size: 12, alphabet: "abcdef123")
  """
  @spec generate(non_neg_integer(), binary() | charlist()) :: binary()
  def generate(size, alphabet) when is_integer(size) and size > 0 and (is_binary(alphabet) or is_list(alphabet)) do
    case Alphabet.convert_alphabet(alphabet) do
      {:ok, _tuple} -> generate_with(size: size, alphabet: alphabet)
      :error -> generate_with(size: size)
    end
  end

  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate_with(size: size)

  def generate(_size, _alphabet),
    do: generate_with([])

  @spec generate_default(term()) :: binary()
  defp generate_default(size) do
    case Alphabet.validate_size(size) do
      {:ok, size} ->
        pick_symbols(size, Configuration.default_alphabet_tuple(), Configuration.default_alphabet_length())

      :error ->
        raise ArgumentError, "size must be a positive integer, got: #{inspect(size)}"
    end
  end

  @spec generate_custom(term(), binary() | charlist()) :: binary()
  defp generate_custom(size, alphabet) do
    with {:size, {:ok, size}} <- {:size, Alphabet.validate_size(size)},
         {:alphabet, {:ok, alphabet_tuple}} <- {:alphabet, Alphabet.convert_alphabet(alphabet)} do
      pick_symbols(size, alphabet_tuple, tuple_size(alphabet_tuple))
    else
      {:size, :error} ->
        raise ArgumentError, "size must be a positive integer, got: #{inspect(size)}"

      {:alphabet, :error} ->
        raise ArgumentError, "alphabet must contain at least two symbols, got: #{inspect(alphabet)}"
    end
  end

  @spec pick_symbols(pos_integer(), tuple(), pos_integer()) :: binary()
  defp pick_symbols(size, alphabet_tuple, alphabet_length) do
    for _ <- 1..size, into: [] do
      elem(alphabet_tuple, :rand.uniform(alphabet_length) - 1)
    end
    |> IO.iodata_to_binary()
  end
end
