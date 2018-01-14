defmodule Nanoid do
  @moduledoc """
  Elixir port of NanoID ([https://github.com/ai/nanoid](https://github.com/ai/nanoid)), a tiny, secure URL-friendly unique string ID generator.

  **Safe.** It uses cryptographically strong random APIs and guarantees a proper distribution of symbols.

  **Small.** Only 179 bytes (minified and gzipped). No dependencies. It uses Size Limit to control size.

  **Compact.** It uses a larger alphabet than UUID (A-Za-z0-9_~) and has a similar number of unique IDs in just 21 symbols instead of 36.
  """
  use Bitwise

  ## -- DEFAULT ATTRIBUTES
  @default_size     21
  @default_mask     63
  @default_alphabet "_~0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


  @doc """
  Generates a NanoID using the default alphabet.
  ## Example
  Generate a NanoID with the default size of 21 characters.
      iex> Nanoid.generate()
      "mJUHrGXZBZpNX50x2xkzf"

  Generate a NanoID with a custom size of 64 characters.
      iex> Nanoid.generate(64)
      "wk9fsUrhK9k~MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
  """
  @spec generate(Integer.t) :: String.t
  def generate(size \\ @default_size)
  def generate(size) when is_integer(size) and size > 0,
    do: generator(@default_alphabet, size, @default_mask)
  def generate(_size),
    do: generator(@default_alphabet, @default_size, @default_mask)

  @doc """
  Generate a NanoID using a custom size and an individual alphabet.
  ## Example
  Generate a NanoID with the default size of 21 characters and an individual alphabet.
      iex> Nanoid.generate(21, "abcdef123")
      "d1dcd2dee333cae1bfdea"

  Generate a NanoID with custom size of 64 characters and an individual alphabet.
      iex> Nanoid.generate(64, "abcdef123")
      "aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
  """
  @spec generate(Integer.t, String.t) :: String.t
  def generate(size, alphabet)
  def generate(size, alphabet) when is_integer(size) and size > 0 and is_binary(alphabet) and byte_size(alphabet) > 1 do
    alphabet_length = String.length(alphabet)
    mask            = ((2 <<< round(Float.floor(:math.log(alphabet_length - 1) / :math.log(2)))) - 1)
    step            = round(Float.ceil(1.6 * mask * size / alphabet_length))
    do_generate(size, alphabet, mask, step)
  end
  def generate(size, alphabet)  when is_list(alphabet),
    do: generate(size, to_string(alphabet))
  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate(size, @default_alphabet)
  def generate(_size, _alphabet),
    do: generate(@default_size, @default_alphabet)

  @spec do_generate(Integer.t, String.t, Integer.t, Integer.t, String.t) :: String.t
  defp do_generate(size, alphabet, mask, step, acc \\ "")
  defp do_generate(size, _alphabet, _mask, _step, acc) when is_binary(acc) and byte_size(acc) >= size,
    do: String.slice(acc, 0, size)
  defp do_generate(size, alphabet, mask, step, acc)    when is_binary(acc) and byte_size(acc) < size,
    do: do_generate(size, alphabet, mask, step, acc <> generator(alphabet, step, mask))
  defp do_generate(size, alphabet, mask, step, _acc),
    do: do_generate(size, alphabet, mask, step, "")


  @spec generator(String.t, Integer.t, Integer.t) :: String.t
  defp generator(alphabet, size, mask)
  defp generator(alphabet, size, mask) when is_binary(alphabet) and byte_size(alphabet) > 1 and is_integer(size) and size > 0 and is_integer(mask) and mask > 0 do
    size
    |> random_bytes()
    |> Enum.map(&(&1 &&& mask))
    |> Enum.map(&String.at(alphabet, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join()
  end
  defp generator(_alphabet, _size, _mask), do: generator(@default_alphabet, @default_size, @default_mask)

  @spec random_bytes(Integer.t) :: nonempty_list(Integer.t)
  defp random_bytes(size)
  defp random_bytes(size) when is_integer(size) and size > 0 do
    size
    |> :crypto.strong_rand_bytes()
    |> :binary.bin_to_list()
  end
  defp random_bytes(_size), do: random_bytes(@default_size)

end
