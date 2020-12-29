defmodule Nanoid.Configuration do
  @moduledoc """
  Configuration module used by NanoID generators to get the required configuration.
  """

  ## -- DEFAULT ATTRIBUTES
  @default_mask 63
  @default_size 21
  @default_alphabet "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  @default_alphabet_length String.length(@default_alphabet)

  @doc """
  Returns the default mask used by the secure generator.
  ## Example
      iex> Nanoid.Configuration.default_mask()
      63
  """
  @spec default_mask :: Integer.t()
  def default_mask, do: @default_mask

  @doc """
  Returns the default size of a nanoid used by the generators.
  ## Example
      iex> Nanoid.Configuration.default_mask()
      21
  """
  @spec default_size :: Integer.t()
  def default_size, do: Application.get_env(:nanoid, :size, @default_size)

  @doc """
  Returns the default alphabet of a nanoid used by the generators.
  ## Example
      iex> Nanoid.Configuration.default_alphabet()
      "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  """
  @spec default_alphabet :: String.t()
  def default_alphabet, do: Application.get_env(:nanoid, :alphabet, @default_alphabet)

  @doc """
  Returns the length of the default alphabet.
  ## Example
      iex> Nanoid.Configuration.default_alphabet_length()
      64
  """
  @spec default_alphabet_length :: Integer.t()
  def default_alphabet_length, do: @default_alphabet_length
end
