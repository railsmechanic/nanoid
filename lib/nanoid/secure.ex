defmodule Nanoid.Secure do
  @moduledoc """
  Generate a secure URL-friendly unique ID. This method uses the secure and non predictable random generator.
  By default, the ID will have 21 symbols with a collision probability similar to UUID v4.
  """
  import Bitwise
  alias Nanoid.Configuration

  @doc """
  Generates a secure NanoID using the default alphabet.
  ## Example
  Generate a NanoID with the default size of 21 characters.
      iex> Nanoid.Secure.generate()
      "mJUHrGXZBZpNX50x2xkzf"

  Generate a secure NanoID with a custom size of 64 characters.
      iex> Nanoid.Secure.generate(64)
      "wk9fsUrhK9k-MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
  """
  @spec generate(non_neg_integer()) :: binary()
  def generate(size \\ Configuration.default_size())

  def generate(size) when is_integer(size) and size > 0 do
    step = calculate_step(Configuration.default_mask(), size, Configuration.default_alphabet_length())
    do_generate(size, Configuration.default_alphabet(), Configuration.default_mask(), step)
  end

  def generate(_size), do: generate(Configuration.default_size())

  @doc """
  Generates a secure NanoID using a custom size and an individual alphabet.
  ## Example
  Generate a secure NanoID with the default size of 21 characters and an individual alphabet.
      iex> Nanoid.Secure.generate(21, "abcdef123")
      "d1dcd2dee333cae1bfdea"

  Generate a secure NanoID with custom size of 64 characters and an individual alphabet.
      iex> Nanoid.Secure.generate(64, "abcdef123")
      "aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
  """
  @spec generate(non_neg_integer(), binary()) :: binary()
  def generate(size, alphabet)

  def generate(size, alphabet) when is_integer(size) and size > 0 and is_binary(alphabet) and byte_size(alphabet) > 1 do
    alphabet_length = String.length(alphabet)
    mask = calculate_mask(alphabet_length)
    step = calculate_step(mask, size, alphabet_length)
    do_generate(size, alphabet, mask, step)
  end

  def generate(size, alphabet) when is_list(alphabet),
    do: generate(size, to_string(alphabet))

  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate(size, Configuration.default_alphabet())

  def generate(_size, _alphabet),
    do: generate(Configuration.default_size(), Configuration.default_alphabet())

  # Generate NanoID recursively as long as the given size is reached
  @spec do_generate(non_neg_integer(), binary(), non_neg_integer(), non_neg_integer(), binary()) :: binary()
  defp do_generate(size, alphabet, mask, step, acc \\ "")

  defp do_generate(size, _alphabet, _mask, _step, acc) when is_binary(acc) and byte_size(acc) >= size,
    do: String.slice(acc, 0, size)

  defp do_generate(size, alphabet, mask, step, acc) when is_binary(acc) and byte_size(acc) < size,
    do: do_generate(size, alphabet, mask, step, acc <> generator(step, alphabet, mask))

  defp do_generate(size, alphabet, mask, step, _acc),
    do: do_generate(size, alphabet, mask, step, "")

  @spec generator(non_neg_integer(), binary(), non_neg_integer()) :: binary()
  defp generator(size, alphabet, mask)

  defp generator(size, alphabet, mask)
       when is_integer(size) and size > 0 and is_binary(alphabet) and byte_size(alphabet) > 1 and is_integer(mask) and mask > 0 do
    size
    |> random_bytes()
    |> Enum.map(&(&1 &&& mask))
    |> Enum.map(&String.at(alphabet, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join()
  end

  defp generator(_size, _alphabet, _mask),
    do:
      generator(
        Configuration.default_size(),
        Configuration.default_alphabet(),
        Configuration.default_mask()
      )

  @spec calculate_mask(non_neg_integer()) :: non_neg_integer()
  defp calculate_mask(alphabet_length)

  defp calculate_mask(alphabet_length) when is_integer(alphabet_length) and alphabet_length > 1,
    do: (2 <<< round(Float.floor(:math.log(alphabet_length - 1) / :math.log(2)))) - 1

  defp calculate_mask(_alphabet_length),
    do: calculate_mask(2)

  @spec calculate_step(non_neg_integer(), non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  defp calculate_step(mask, size, alphabet_length)

  defp calculate_step(mask, size, alphabet_length) when is_integer(alphabet_length) and alphabet_length > 0,
    do: round(Float.ceil(1.6 * mask * size / alphabet_length))

  defp calculate_step(mask, size, _alphabet_length),
    do: calculate_step(mask, size, 1)

  @spec random_bytes(non_neg_integer()) :: nonempty_list(non_neg_integer())
  defp random_bytes(size)

  defp random_bytes(size) when is_integer(size) and size > 0 do
    size
    |> :crypto.strong_rand_bytes()
    |> :binary.bin_to_list()
  end

  defp random_bytes(_size), do: random_bytes(Configuration.default_size())
end
