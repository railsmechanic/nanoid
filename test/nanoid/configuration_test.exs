defmodule Nanoid.ConfigurationTest do
  use ExUnit.Case, async: true
  alias Nanoid.Configuration

  ## --> SETTINGS
  @moduletag timeout: :timer.minutes(5)

  ## --> SETUP
  setup_all do
    %{
      default_mask: 63,
      default_size: 21,
      default_alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }
  end

  setup context do
    on_exit(fn ->
      Application.put_env(:nanoid, :size, context[:default_size])
      Application.put_env(:nanoid, :alphabet, context[:default_alphabet])
    end)
  end

  ## --> TEST CASES
  describe "default_mask/0" do
    test "to get the default mask of 63", context do
      assert Configuration.default_mask() == context[:default_mask]
    end
  end

  describe "default_size/0" do
    test "to use the fallback size when no individual size is configured", context do
      assert Configuration.default_size() == context[:default_size]
    end

    test "to use the individually configured size" do
      Application.put_env(:nanoid, :size, 10)
      assert Configuration.default_size() == 10
    end
  end

  describe "default_alphabet/0" do
    test "to use the fallback alphabet when no individual alphabet is configured", context do
      assert Configuration.default_alphabet() == context[:default_alphabet]
    end

    test "to use the individually configured alphabet" do
      custom_alphabet = "0123456789abcdef"

      Application.put_env(:nanoid, :alphabet, custom_alphabet)
      assert Configuration.default_alphabet() == custom_alphabet
    end
  end

  describe "default_alphabet_length/0" do
    test "to use the length of the fallback alphabet when no individual alphabet is configured",
         context do
      assert Configuration.default_alphabet_length() == String.length(context[:default_alphabet])
    end

    test "to use the length of the individually configured alphabet" do
      custom_alphabet = "0123456789abcdef"

      Application.put_env(:nanoid, :alphabet, custom_alphabet)
      assert Configuration.default_alphabet_length() == String.length(custom_alphabet)
    end
  end
end
