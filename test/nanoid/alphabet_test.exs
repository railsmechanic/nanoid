defmodule Nanoid.AlphabetTest do
  use ExUnit.Case, async: true
  doctest Nanoid.Alphabet

  alias Nanoid.Alphabet

  describe "convert_alphabet/1" do
    test "converts a binary into a grapheme tuple" do
      assert Alphabet.convert_alphabet("abc") == {:ok, {"a", "b", "c"}}
    end

    test "converts a charlist via List.to_string/1" do
      assert Alphabet.convert_alphabet(~c"abc") == {:ok, {"a", "b", "c"}}
    end

    test "splits multi-byte graphemes correctly (not by byte)" do
      assert Alphabet.convert_alphabet("äöü") == {:ok, {"ä", "ö", "ü"}}
      assert Alphabet.convert_alphabet("🚀🎉") == {:ok, {"🚀", "🎉"}}
    end

    test "returns :error for a single ASCII symbol" do
      assert Alphabet.convert_alphabet("a") == :error
    end

    test "returns :error for a single multi-byte symbol" do
      # "ä" is 2 bytes but only 1 grapheme — must not be treated as length >= 2.
      assert Alphabet.convert_alphabet("ä") == :error
    end

    test "returns :error for an empty alphabet" do
      assert Alphabet.convert_alphabet("") == :error
    end
  end

  describe "validate_size/1" do
    test "wraps a positive integer" do
      assert Alphabet.validate_size(16) == {:ok, 16}
      assert Alphabet.validate_size(1) == {:ok, 1}
    end

    test "returns :error for zero or negative integers" do
      assert Alphabet.validate_size(0) == :error
      assert Alphabet.validate_size(-5) == :error
    end

    test "returns :error for non-integer values" do
      assert Alphabet.validate_size("16") == :error
      assert Alphabet.validate_size(16.0) == :error
      assert Alphabet.validate_size(nil) == :error
    end
  end
end
