defmodule Nanoid.Configuration do
  @moduledoc """
  Configuration module used by NanoID generators to get the required configuration.
  """

  ## -- DEFAULT ATTRIBUTES
  @default_mask 63
  @default_size Application.compile_env(:nanoid, :size, 21)
  @default_alphabet Application.compile_env(:nanoid, :alphabet, "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  @default_alphabet_length String.length(@default_alphabet)

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
      iex> Nanoid.Configuration.default_mask()
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
  Returns the length of the default alphabet.
  ## Example
      iex> Nanoid.Configuration.default_alphabet_length()
      64
  """
  @spec default_alphabet_length :: non_neg_integer()
  def default_alphabet_length, do: @default_alphabet_length
end
