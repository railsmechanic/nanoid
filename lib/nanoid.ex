defmodule Nanoid do
  @moduledoc """
  Elixir port of NanoID ([https://github.com/ai/nanoid](https://github.com/ai/nanoid)),
  a tiny, secure URL-friendly unique string ID generator.

  **Safe.** It uses cryptographically strong random APIs and guarantees a proper
  distribution of symbols.

  **Compact.** It uses a larger alphabet than UUID (`A-Za-z0-9_-`) and has a similar
  number of unique IDs in just 21 symbols instead of 36.

  ## Quick start

      iex> Nanoid.generate()
      "mJUHrGXZBZpNX50x2xkzf"

      iex> Nanoid.generate_with(size: 16, alphabet: "abcdef123")
      "d1dcd2dee333cae1b"

  Use `generate_non_secure/0` or `generate_non_secure_with/1` if cryptographic
  strength is not required.
  """

  @doc """
  Generates a secure NanoID using a keyword list of options.

  Always pass at least one option — for the no-options shortcut, use `generate/0`.

  ## Options
    * `:size` - the desired ID length in symbols (defaults to `Nanoid.Configuration.default_size/0`)
    * `:alphabet` - the alphabet to draw from (defaults to `Nanoid.Configuration.default_alphabet/0`)

  ## Examples
      iex> Nanoid.generate_with(size: 16)
      "IRFa-VaY2b-NU5xX"

      iex> Nanoid.generate_with(alphabet: "abcdef123")
      "d1dcd2dee333cae1bfdea"

      iex> Nanoid.generate_with(size: 12, alphabet: "abcdef123")
      "d1dcd2dee333"
  """
  @spec generate_with(keyword()) :: binary()
  defdelegate generate_with(opts), to: Nanoid.Secure

  @doc """
  Generates a non-secure NanoID using a keyword list of options.

  Always pass at least one option — for the no-options shortcut, use `generate_non_secure/0`.

  ## Options
    * `:size` - the desired ID length in symbols (defaults to `Nanoid.Configuration.default_size/0`)
    * `:alphabet` - the alphabet to draw from, as a binary or charlist
      (defaults to `Nanoid.Configuration.default_alphabet/0`)

  ## Examples
      iex> Nanoid.generate_non_secure_with(size: 16)
      "IRFa-VaY2b-NU5xX"

      iex> Nanoid.generate_non_secure_with(alphabet: "abcdef123")
      "d1dcd2dee333cae1bfdea"

      iex> Nanoid.generate_non_secure_with(size: 12, alphabet: "abcdef123")
      "d1dcd2dee333"
  """
  @spec generate_non_secure_with(keyword()) :: binary()
  defdelegate generate_non_secure_with(opts), to: Nanoid.NonSecure, as: :generate_with

  @doc """
  Generates a secure NanoID using the default size and alphabet.

  Quick-access shortcut, equivalent to `generate_with([])`.

  ## Example
      iex> Nanoid.generate()
      "mJUHrGXZBZpNX50x2xkzf"
  """
  @spec generate :: binary()
  defdelegate generate, to: Nanoid.Secure

  @deprecated "Use Nanoid.generate_with/1 instead"
  @doc """
  Generates a secure NanoID with the given size.

  Deprecated — use `generate_with(size: size)`.
  """
  @spec generate(non_neg_integer()) :: binary()
  defdelegate generate(size), to: Nanoid.Secure

  @deprecated "Use Nanoid.generate_with/1 instead"
  @doc """
  Generates a secure NanoID with the given size and alphabet.

  Deprecated — use `generate_with(size: size, alphabet: alphabet)`.
  """
  @spec generate(non_neg_integer(), binary() | charlist()) :: binary()
  defdelegate generate(size, alphabet), to: Nanoid.Secure

  @doc """
  Generates a non-secure NanoID using the default size and alphabet.

  Quick-access shortcut, equivalent to `generate_non_secure_with([])`.

  ## Example
      iex> Nanoid.generate_non_secure()
      "mJUHrGXZBZpNX50x2xkzf"
  """
  @spec generate_non_secure :: binary()
  defdelegate generate_non_secure, to: Nanoid.NonSecure, as: :generate

  @deprecated "Use Nanoid.generate_non_secure_with/1 instead"
  @doc """
  Generates a non-secure NanoID with the given size.

  Deprecated — use `generate_non_secure_with(size: size)`.
  """
  @spec generate_non_secure(non_neg_integer()) :: binary()
  defdelegate generate_non_secure(size), to: Nanoid.NonSecure, as: :generate

  @deprecated "Use Nanoid.generate_non_secure_with/1 instead"
  @doc """
  Generates a non-secure NanoID with the given size and alphabet.

  Deprecated — use `generate_non_secure_with(size: size, alphabet: alphabet)`.
  """
  @spec generate_non_secure(non_neg_integer(), binary() | charlist()) :: binary()
  defdelegate generate_non_secure(size, alphabet), to: Nanoid.NonSecure, as: :generate
end
