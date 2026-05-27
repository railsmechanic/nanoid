defmodule Nanoid.Secure do
  @moduledoc """
  Generate a secure URL-friendly unique ID using `:crypto.strong_rand_bytes/1`.

  By default the ID has 21 symbols, with a collision probability similar to UUID v4.

  Use `generate/0` for the all-defaults shortcut, or `generate_with/1` with
  `:size` and/or `:alphabet` for custom IDs. The positional `generate/1,2`
  variants remain available for backward compatibility but are deprecated.
  """
  import Bitwise
  alias Nanoid.Configuration

  @doc """
  Generates a secure NanoID using a keyword list of options.

  Always pass at least one option — for the no-options shortcut, use `generate/0`.

  ## Options
    * `:size` - the desired ID length in symbols (defaults to `Nanoid.Configuration.default_size/0`)
    * `:alphabet` - the alphabet to draw from, as a binary
      (defaults to `Nanoid.Configuration.default_alphabet/0`).
      Multi-byte graphemes (e.g. `"äöü"` or emoji) are supported.

  ## Examples
      iex> Nanoid.Secure.generate_with(size: 16)
      "IRFa-VaY2b-NU5xX"

      iex> Nanoid.Secure.generate_with(alphabet: "abcdef123")
      "d1dcd2dee333cae1bfdea"

      iex> Nanoid.Secure.generate_with(size: 12, alphabet: "abcdef123")
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
  Generates a secure NanoID using the default size and alphabet.

  Quick-access shortcut, equivalent to `generate_with([])`.

  ## Example
      iex> Nanoid.Secure.generate()
      "mJUHrGXZBZpNX50x2xkzf"
  """
  @spec generate :: binary()
  def generate, do: generate_with([])

  @deprecated "Use Nanoid.Secure.generate_with/1 instead"
  @doc """
  Generates a secure NanoID with the given size.

  Deprecated — use `generate_with(size: size)`.
  """
  @spec generate(non_neg_integer()) :: binary()
  def generate(size) when is_integer(size) and size > 0,
    do: generate_with(size: size)

  def generate(_size),
    do: generate_with([])

  @deprecated "Use Nanoid.Secure.generate_with/1 instead"
  @doc """
  Generates a secure NanoID using a custom size and an individual alphabet.

  Deprecated — use `generate_with/1` with the `:size` and `:alphabet` options instead:

      Nanoid.Secure.generate_with(size: 12, alphabet: "abcdef123")
  """
  @spec generate(non_neg_integer(), binary()) :: binary()
  def generate(size, alphabet)

  def generate(size, alphabet) when is_integer(size) and size > 0 and is_binary(alphabet) and byte_size(alphabet) > 1,
    do: generate_with(size: size, alphabet: alphabet)

  def generate(size, alphabet) when is_list(alphabet),
    do: generate(size, to_string(alphabet))

  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate_with(size: size)

  def generate(_size, _alphabet),
    do: generate_with([])

  # Fast path: default alphabet — mask, length and tuple are compile-time constants.
  defp generate_default(size) when is_integer(size) and size > 0 do
    mask = Configuration.default_mask()
    alphabet_length = Configuration.default_alphabet_length()
    step = calculate_step(mask, size, alphabet_length)
    do_generate(size, Configuration.default_alphabet_tuple(), alphabet_length, mask, step)
  end

  defp generate_custom(size, alphabet)
       when is_integer(size) and size > 0 and is_binary(alphabet) and byte_size(alphabet) > 1 do
    alphabet_tuple = alphabet |> String.graphemes() |> List.to_tuple()
    alphabet_length = tuple_size(alphabet_tuple)
    mask = calculate_mask(alphabet_length)
    step = calculate_step(mask, size, alphabet_length)
    do_generate(size, alphabet_tuple, alphabet_length, mask, step)
  end

  defp generate_custom(size, alphabet) when is_list(alphabet),
    do: generate_custom(size, to_string(alphabet))

  defp do_generate(size, alphabet_tuple, alphabet_length, mask, step, acc \\ [], acc_count \\ 0)

  defp do_generate(size, _alphabet_tuple, _alphabet_length, _mask, _step, acc, acc_count)
       when acc_count >= size do
    acc
    |> Enum.reverse()
    |> Enum.take(size)
    |> IO.iodata_to_binary()
  end

  defp do_generate(size, alphabet_tuple, alphabet_length, mask, step, acc, acc_count) do
    {new_acc, new_count} =
      step
      |> :crypto.strong_rand_bytes()
      |> :binary.bin_to_list()
      |> Enum.reduce({acc, acc_count}, fn byte, {chars, count} ->
        idx = byte &&& mask

        if idx < alphabet_length do
          {[elem(alphabet_tuple, idx) | chars], count + 1}
        else
          {chars, count}
        end
      end)

    do_generate(size, alphabet_tuple, alphabet_length, mask, step, new_acc, new_count)
  end

  defp calculate_mask(alphabet_length) when is_integer(alphabet_length) and alphabet_length > 1,
    do: (2 <<< round(Float.floor(:math.log(alphabet_length - 1) / :math.log(2)))) - 1

  defp calculate_step(mask, size, alphabet_length) when is_integer(alphabet_length) and alphabet_length > 0,
    do: round(Float.ceil(1.6 * mask * size / alphabet_length))
end
