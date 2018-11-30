defmodule Nanoid.SecureTest do
  use ExUnit.Case, async: true

  ## --> SETTINGS
  @moduletag timeout: 180_000

  ## --> SETUP
  setup_all do
    %{default_alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"}
  end

  ## --> TEST CASES
  test "that a generated ID is valid" do
    nanoid = Nanoid.Secure.generate()
    assert is_binary(nanoid)
    assert byte_size(nanoid) > 0
  end

  test "the correct size of an ID generated with default settings" do
    Enum.each(1..100, fn _ ->
      nanoid_length =
        Nanoid.Secure.generate()
        |> String.length()

      assert nanoid_length == Application.get_env(:nanoid, :size, 21)
    end)
  end

  test "that generated IDs are URL-friendly", context do
    Enum.each(1..100, fn _ ->
      Nanoid.Secure.generate()
      |> String.graphemes()
      |> Enum.each(fn grapheme ->
        assert String.contains?(context[:default_alphabet], grapheme)
      end)
    end)
  end

  test "that generated IDs have no collisions for thousands of entries at #{
         Application.get_env(:nanoid, :size, 21)
       } characters length" do
    Enum.reduce(1..100_000, %{}, fn _, acc ->
      nanoid = Nanoid.Secure.generate()
      refute Map.has_key?(acc, nanoid)
      Map.put(acc, nanoid, true)
    end)
  end

  test "that generated IDs have no collisions for thousands of entries at 9 characters length" do
    Enum.reduce(1..100_000, %{}, fn _, acc ->
      nanoid = Nanoid.Secure.generate(9)
      refute Map.has_key?(acc, nanoid)
      Map.put(acc, nanoid, true)
    end)
  end

  test "generates an ID with custom settings" do
    custom_size = 12
    custom_alphabet = "1234567890abcdef"

    nanoid = Nanoid.Secure.generate(custom_size, custom_alphabet)
    assert is_binary(nanoid)
    assert byte_size(nanoid) == custom_size

    nanoid
    |> String.graphemes()
    |> Enum.each(fn grapheme ->
      assert String.contains?(custom_alphabet, grapheme)
    end)
  end
end
