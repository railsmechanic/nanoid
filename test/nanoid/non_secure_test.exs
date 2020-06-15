defmodule Nanoid.NonSecureTest do
  use ExUnit.Case, async: true

  ## --> SETTINGS
  @moduletag timeout: :timer.minutes(5)

  ## --> SETUP
  setup_all do
    %{default_alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"}
  end

  ## --> TEST CASES
  test "that a generated ID is valid" do
    nanoid = Nanoid.NonSecure.generate()
    assert is_binary(nanoid)
    assert byte_size(nanoid) > 0
  end

  test "the correct configured (default) size of an ID generated with default settings" do
    Enum.each(1..1000, fn _ ->
      nanoid_length =
        Nanoid.NonSecure.generate()
        |> String.length()

      assert nanoid_length == Application.get_env(:nanoid, :size, 21)
    end)
  end

  test "the correct size of an ID generated with a given custom size" do
    custom_size = Enum.random(10..64)

    Enum.each(1..1000, fn _ ->
      nanoid_length =
        custom_size
        |> Nanoid.NonSecure.generate()
        |> String.length()

      assert nanoid_length == custom_size
    end)
  end

  test "the consistency of an ID generated with a given custom size" do
    custom_size = Enum.random(10..64)

    generation_result =
      Enum.map(1..1000, fn _ ->
        custom_size
        |> Nanoid.NonSecure.generate()
        |> String.length()
      end)
      |> Enum.into(%MapSet{})

    assert MapSet.size(generation_result) == 1
    assert MapSet.equal?(generation_result, MapSet.new([custom_size]))
  end

  test "that generated IDs are URL-friendly", context do
    Enum.each(1..1000, fn _ ->
      Nanoid.NonSecure.generate()
      |> String.graphemes()
      |> Enum.each(fn grapheme ->
        assert String.contains?(context[:default_alphabet], grapheme)
      end)
    end)
  end

  test "that generated IDs have no collisions for thousands of entries at #{Application.get_env(:nanoid, :size, 21)} characters length" do
    generation_result =
      1..100_000
      |> Enum.map(fn _ -> Nanoid.NonSecure.generate() end)
      |> Enum.into(%MapSet{})

    assert MapSet.size(generation_result) == 100_000
  end

  test "that generated IDs have no collisions for thousands of entries at 9 characters length" do
    generation_result =
      1..100_000
      |> Enum.map(fn _ -> Nanoid.NonSecure.generate(9) end)
      |> Enum.into(%MapSet{})

    assert MapSet.size(generation_result) == 100_000
  end

  test "generates an ID with custom settings" do
    custom_size = 12
    custom_alphabet = "1234567890abcdef"

    nanoid = Nanoid.NonSecure.generate(custom_size, custom_alphabet)
    assert is_binary(nanoid)
    assert byte_size(nanoid) == custom_size

    nanoid
    |> String.graphemes()
    |> Enum.each(fn grapheme ->
      assert String.contains?(custom_alphabet, grapheme)
    end)
  end
end
