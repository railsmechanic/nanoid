defmodule Nanoid.Configuration do
  @moduledoc """
  Configuration module used by NanoID generators to get the required configuration.
  """

  @default_mask 63
  @default_size Application.compile_env(:nanoid, :size, 21)
  @default_alphabet Application.compile_env(:nanoid, :alphabet, "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  @default_alphabet_graphemes String.graphemes(@default_alphabet)
  @default_alphabet_length Kernel.length(@default_alphabet_graphemes)
  @default_alphabet_tuple List.to_tuple(@default_alphabet_graphemes)

  @doc """
  Returns the default mask used by the secure generator.
  ## Example
      iex> Nanoid.Configuration.default_mask()
      63
  """
  @spec default_mask :: non_neg_integer()
  def default_mask, do: @default_mask

  @doc """
  Returns the default size of a nanoid used by the generators.
  ## Example
      iex> Nanoid.Configuration.default_size()
      21
  """
  @spec default_size :: non_neg_integer()
  def default_size, do: @default_size

  @doc """
  Returns the default alphabet of a nanoid used by the generators.
  ## Example
      iex> Nanoid.Configuration.default_alphabet()
      "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  """
  @spec default_alphabet :: binary()
  def default_alphabet, do: @default_alphabet

  @doc """
  Returns the length of the default alphabet (in graphemes).
  ## Example
      iex> Nanoid.Configuration.default_alphabet_length()
      64
  """
  @spec default_alphabet_length :: non_neg_integer()
  def default_alphabet_length, do: @default_alphabet_length

  @doc """
  Returns the default alphabet as a precomputed tuple of graphemes,
  enabling O(1) symbol lookup at runtime.
  """
  @spec default_alphabet_tuple :: tuple()
  def default_alphabet_tuple, do: @default_alphabet_tuple
end
