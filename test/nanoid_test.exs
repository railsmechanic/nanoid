defmodule NanoidTest do
  use ExUnit.Case, async: true

  test "that a generated ID is valid" do
    nanoid = Nanoid.generate()
    assert is_binary(nanoid)
    assert byte_size(nanoid) > 0
  end

  test "the correct size of an ID generated with default settings" do
    Enum.each((1..100), fn(_) ->
      nanoid_length =
        Nanoid.generate()
        |> String.length()
      assert nanoid_length == 21
    end)
  end

  test "that generated IDs are URL-friendly" do
    safe_alphabet = "_~0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Enum.each((1..100), fn(_) ->
      Nanoid.generate()
      |> String.graphemes()
      |> Enum.each(fn(grapheme) ->
        assert String.contains?(safe_alphabet, grapheme)
      end)
    end)
  end

  test "that generated IDs have no collisions for thousands of entries at 21 characters length" do
    Enum.reduce((1..100_000), %{}, fn(_, acc) ->
      nanoid = Nanoid.generate()
      refute Map.has_key?(acc, nanoid)
      Map.put(acc, nanoid, true)
    end)
  end

  test "that generated IDs have no collisions for thousands of entries at 9 characters length" do
    Enum.reduce((1..100_000), %{}, fn(_, acc) ->
      nanoid = Nanoid.generate(9)
      refute Map.has_key?(acc, nanoid)
      Map.put(acc, nanoid, true)
    end)
  end

  test "generates an ID with custom settings" do
    size     = 12
    alphabet = "1234567890abcdef"

    nanoid = Nanoid.generate(size, alphabet)
    assert is_binary(nanoid)
    assert byte_size(nanoid) == size

    nanoid
    |> String.graphemes()
    |> Enum.each(fn(grapheme) ->
      assert String.contains?(alphabet, grapheme)
    end)
  end

end
