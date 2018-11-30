defmodule Nanoid do
  @moduledoc """
  Elixir port of NanoID ([https://github.com/ai/nanoid](https://github.com/ai/nanoid)), a tiny, secure URL-friendly unique string ID generator.

  **Safe.** It uses cryptographically strong random APIs and guarantees a proper distribution of symbols.

  **Small.** Only 179 bytes (minified and gzipped). No dependencies. It uses Size Limit to control size.

  **Compact.** It uses a larger alphabet than UUID (A-Za-z0-9_~) and has a similar number of unique IDs in just 21 symbols instead of 36.
  """

  @doc """
  Generates a secure NanoID using the default alphabet.
  ## Example
  Generate a NanoID with the default size of 21 characters.
      iex> Nanoid.generate()
      "mJUHrGXZBZpNX50x2xkzf"
  """
  defdelegate generate, to: Nanoid.Secure

  @doc """
  Generates a secure NanoID using the default alphabet.
  ## Example
  Generate a secure NanoID with a custom size of 64 characters.
      iex> Nanoid.generate(64)
      "wk9fsUrhK9k-MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
  """
  defdelegate generate(size), to: Nanoid.Secure

  @doc """
  Generates a secure NanoID using a custom size and an individual alphabet.
  ## Example
  Generate a secure NanoID with the default size of 21 characters and an individual alphabet.
      iex> Nanoid.generate(21, "abcdef123")
      "d1dcd2dee333cae1bfdea"

  Generate a secure NanoID with custom size of 64 characters and an individual alphabet.
      iex> Nanoid.generate(64, "abcdef123")
      "aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
  """
  defdelegate generate(size, alphabet), to: Nanoid.Secure

  @doc """
  Generates a non-secure NanoID using the default alphabet.
  ## Example
  Generate a non-secure NanoID with the default size of 21 characters.
      iex> Nanoid.generate_non_secure()
      "mJUHrGXZBZpNX50x2xkzf"
  """
  defdelegate generate_non_secure, to: Nanoid.NonSecure, as: :generate

  @doc """
  Generates a non-secure NanoID using the default alphabet.
  ## Example
  Generate a non-secure NanoID with a custom size of 64 characters.
      iex> Nanoid.generate_non_secure(64)
      "wk9fsUrhK9k-MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
  """
  defdelegate generate_non_secure(size), to: Nanoid.NonSecure, as: :generate

  @doc """
  Generate a non-secure NanoID using a custom size and an individual alphabet.
  ## Example
  Generate a non-secure NanoID with the default size of 21 characters and an individual alphabet.
      iex> Nanoid.generate_non_secure(21, "abcdef123")
      "d1dcd2dee333cae1bfdea"

  Generate a non-secure NanoID with custom size of 64 characters and an individual alphabet.
      iex> Nanoid.generate_non_secure(64, "abcdef123")
      "aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
  """
  defdelegate generate_non_secure(size, alphabet), to: Nanoid.NonSecure, as: :generate
end
