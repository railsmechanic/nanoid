defmodule Nanoid.NonSecure do
  @moduledoc """
  Generate an URL-friendly unique ID. This method use the non-secure, predictable random generator.
  By default, the ID will have 21 symbols with a collision probability similar to UUID v4.
  """
  alias Nanoid.Configuration

  @doc """
  Generates a non-secure NanoID using the default alphabet.
  ## Example
  Generate a non-secure NanoID with the default size of 21 characters.
      iex> Nanoid.NonSecure.generate()
      "mJUHrGXZBZpNX50x2xkzf"

  Generate a non-secure NanoID with a custom size of 64 characters.
      iex> Nanoid.NonSecure.generate(64)
      "wk9fsUrhK9k-MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
  """
  @spec generate(non_neg_integer()) :: binary()
  def generate(size \\ Configuration.default_size())

  def generate(size) when is_integer(size) and size > 0,
    do: generator(size, Configuration.default_alphabet())

  def generate(_size),
    do: generator(Configuration.default_size(), Configuration.default_alphabet())

  @doc """
  Generate a non-secure NanoID using a custom size and an individual alphabet.
  ## Example
  Generate a non-secure NanoID with the default size of 21 characters and an individual alphabet.
      iex> Nanoid.NonSecure.generate(21, "abcdef123")
      "d1dcd2dee333cae1bfdea"

  Generate a non-secure NanoID with custom size of 64 characters and an individual alphabet.
      iex> Nanoid.NonSecure.generate(64, "abcdef123")
      "aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
  """
  @spec generate(non_neg_integer(), binary() | list()) :: binary()
  def generate(size, alphabet)

  def generate(size, alphabet) when is_integer(size) and size > 0 and is_binary(alphabet),
    do: generator(size, alphabet)

  def generate(size, alphabet) when is_integer(size) and size > 0 and is_list(alphabet),
    do: generator(size, alphabet)

  def generate(size, _alphabet) when is_integer(size) and size > 0,
    do: generate(size, Configuration.default_alphabet())

  def generate(_size, _alphabet),
    do: generate(Configuration.default_size(), Configuration.default_alphabet())

  @spec generator(non_neg_integer(), binary() | list()) :: binary()
  defp generator(size, alphabet)

  defp generator(size, alphabet) when is_integer(size) and size > 0 and is_binary(alphabet),
    do: _generate(size, alphabet)

  defp generator(size, alphabet) when is_integer(size) and size > 0 and is_list(alphabet) and length(alphabet) > 1 do
    1..size
    |> Enum.reduce([], fn _, acc -> [Enum.random(alphabet) | acc] end)
    |> Enum.join()
  end

  defp generator(_size, _alphabet),
    do: generator(Configuration.default_size(), Configuration.default_alphabet())

  defp _generate(size, alphabet) when size > 0 do
    codepoint = :binary.at(alphabet, :rand.uniform(byte_size(alphabet)) - 1)
    <<codepoint, _generate(size - 1, alphabet)::bytes>>
  end

  defp _generate(_size = 0, _alphabet), do: <<>>
end
