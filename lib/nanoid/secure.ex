defmodule Nanoid.Secure do
  @moduledoc """
  Generate a secure URL-friendly unique ID. This method uses the secure and non predictable random generator.
  By default, the ID will have 21 symbols with a collision probability similar to UUID v4.
  """

  use Bitwise

  ## -- DEFAULT ATTRIBUTES
  @default_mask 63
  @default_size Application.get_env(:nanoid, :size, 21)
  @default_alphabet Application.get_env(
                      :nanoid,
                      :alphabet,
                      "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    )
  @default_alphabet_length String.length(@default_alphabet)

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
  @spec generate(Integer.t()) :: String.t()
  def generate(size \\ @default_size)

  def generate(size) when is_integer(size) and size > 0 do
    step = calculate_step(@default_mask, size, @default_alphabet_length)
    do_generate(size, @default_alphabet, @default_mask, step)
  end

  def generate(_size), do: generate(@default_size)

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
  @spec generate(Integer.t(), String.t()) :: String.t()
  def generate(size, alphabet)

  def generate(size, alphabet)
      when is_integer(size) and size > 0 and is_binary(alphabet) and byte_size(alphabet) > 1 do
    alphabet_length = String.length(alphabet)
    mask = calculate_mask(alphabet_length)
    step = calculate_step(mask, size, alphabet_length)
    do_generate(size, alphabet, mask, step)
  end

  def generate(size, alphabet) when is_list(alphabet),
    do: generate(size, to_string(alphabet))

  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate(size, @default_alphabet)

  def generate(_size, _alphabet),
    do: generate(@default_size, @default_alphabet)

  # Generate NanoID recursively as long as the given size is reached
  @spec do_generate(Integer.t(), String.t(), Integer.t(), Integer.t(), String.t()) :: String.t()
  defp do_generate(size, alphabet, mask, step, acc \\ "")

  defp do_generate(size, _alphabet, _mask, _step, acc)
       when is_binary(acc) and byte_size(acc) >= size,
       do: String.slice(acc, 0, size)

  defp do_generate(size, alphabet, mask, step, acc) when is_binary(acc) and byte_size(acc) < size,
    do: do_generate(size, alphabet, mask, step, acc <> generator(step, alphabet, mask))

  defp do_generate(size, alphabet, mask, step, _acc),
    do: do_generate(size, alphabet, mask, step, "")

  @spec generator(Integer.t(), String.t(), Integer.t()) :: String.t()
  defp generator(size, alphabet, mask)

  defp generator(size, alphabet, mask)
       when is_integer(size) and size > 0 and
              is_binary(alphabet) and byte_size(alphabet) > 1 and
              is_integer(mask) and mask > 0 do
    size
    |> random_bytes()
    |> Enum.map(&(&1 &&& mask))
    |> Enum.map(&String.at(alphabet, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.join()
  end

  defp generator(_size, _alphabet, _mask),
    do: generator(@default_size, @default_alphabet, @default_mask)

  @spec calculate_mask(Integer.t()) :: Integer.t()
  defp calculate_mask(alphabet_length)

  defp calculate_mask(alphabet_length) when is_integer(alphabet_length) and alphabet_length > 1,
    do: (2 <<< round(Float.floor(:math.log(alphabet_length - 1) / :math.log(2)))) - 1

  defp calculate_mask(_alphabet_length),
    do: calculate_mask(2)

  @spec calculate_step(Integer.t(), Integer.t(), Integer.t()) :: Integer.t()
  defp calculate_step(mask, size, alphabet_length)

  defp calculate_step(mask, size, alphabet_length)
       when is_integer(alphabet_length) and alphabet_length > 0,
       do: round(Float.ceil(1.6 * mask * size / alphabet_length))

  defp calculate_step(mask, size, _alphabet_length),
    do: calculate_step(mask, size, 1)

  @spec random_bytes(Integer.t()) :: nonempty_list(Integer.t())
  defp random_bytes(size)

  defp random_bytes(size) when is_integer(size) and size > 0 do
    size
    |> :crypto.strong_rand_bytes()
    |> :binary.bin_to_list()
  end

  defp random_bytes(_size), do: random_bytes(@default_size)
end
