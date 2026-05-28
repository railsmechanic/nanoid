defmodule Nanoid.ConfigurationTest do
  use ExUnit.Case, async: true
  alias Nanoid.Configuration

  ## SETTINGS
  @moduletag timeout: :timer.minutes(5)

  ## SETUP
  setup_all do
    %{
      default_mask: 63,
      default_size: 21,
      default_alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }
  end

  ## TEST CASES
  describe "default_mask/0" do
    test "to get the default mask of 63", context do
      assert Configuration.default_mask() == context[:default_mask]
    end
  end

  describe "default_size/0" do
    test "to use the fallback size when no individual size is configured", context do
      assert Configuration.default_size() == context[:default_size]
    end
  end

  describe "default_alphabet/0" do
    test "to use the fallback alphabet when no individual alphabet is configured", context do
      assert Configuration.default_alphabet() == context[:default_alphabet]
    end
  end

  describe "default_alphabet_length/0" do
    test "to use the length of the fallback alphabet when no individual alphabet is configured", context do
      assert Configuration.default_alphabet_length() == String.length(context[:default_alphabet])
    end
  end

  describe "default_alphabet_tuple/0" do
    test "returns the default alphabet as a grapheme tuple", context do
      tuple = Configuration.default_alphabet_tuple()

      assert is_tuple(tuple)
      assert tuple_size(tuple) == Configuration.default_alphabet_length()
      assert Tuple.to_list(tuple) == String.graphemes(context[:default_alphabet])
    end
  end
end
