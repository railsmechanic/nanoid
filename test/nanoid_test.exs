defmodule NanoidTest do
  use ExUnit.Case, async: true

  ## -> SETUP
  setup_all do
    %{custom_alphabet: "0123456789abcdefghij", custom_length: 10}
  end

  ## -> TEST CASES
  describe "Secure functions" do
    test "are exported by the module with the intended arity" do
      Code.ensure_loaded!(Nanoid)
      assert :erlang.function_exported(Nanoid, :generate, 0)
      assert :erlang.function_exported(Nanoid, :generate, 1)
      assert :erlang.function_exported(Nanoid, :generate, 2)
    end

    test "generate/1 to generate an ID of the correct size with default settings" do
      Enum.each(1..100, fn _ ->
        nanoid_length = Nanoid.generate() |> String.length()
        assert nanoid_length == Application.get_env(:nanoid, :size, 21)
      end)
    end

    test "generate/1 to generate an ID of the correct size with custom settings", context do
      Enum.each(1..100, fn _ ->
        nanoid_length = Nanoid.generate(context[:custom_length]) |> String.length()
        assert nanoid_length == context[:custom_length]
      end)
    end

    test "generate/2 to generate an ID of the correct size with custom settings", context do
      Enum.each(1..100, fn _ ->
        nanoid_length = Nanoid.generate(context[:custom_length], context[:custom_alphabet]) |> String.length()

        assert nanoid_length == context[:custom_length]
      end)
    end
  end

  describe "Secure generate_with" do
    test "is exported by the module" do
      Code.ensure_loaded!(Nanoid)
      assert :erlang.function_exported(Nanoid, :generate_with, 1)
    end

    test "with an empty option list falls back to defaults" do
      assert String.length(Nanoid.generate_with([])) == Application.get_env(:nanoid, :size, 21)
    end

    test "with size: option produces an ID of that size", context do
      assert String.length(Nanoid.generate_with(size: context[:custom_length])) == context[:custom_length]
    end

    test "with alphabet: option uses that alphabet only", context do
      Nanoid.generate_with(alphabet: context[:custom_alphabet])
      |> String.graphemes()
      |> Enum.each(fn grapheme ->
        assert String.contains?(context[:custom_alphabet], grapheme)
      end)
    end

    test "with size: and alphabet: options", context do
      nanoid = Nanoid.generate_with(size: context[:custom_length], alphabet: context[:custom_alphabet])
      assert String.length(nanoid) == context[:custom_length]

      nanoid
      |> String.graphemes()
      |> Enum.each(fn grapheme ->
        assert String.contains?(context[:custom_alphabet], grapheme)
      end)
    end
  end

  describe "Non-Secure functions" do
    test "are exported by the module with the intended arity" do
      Code.ensure_loaded!(Nanoid)
      assert :erlang.function_exported(Nanoid, :generate_non_secure, 0)
      assert :erlang.function_exported(Nanoid, :generate_non_secure, 1)
      assert :erlang.function_exported(Nanoid, :generate_non_secure, 2)
    end

    test "generate_non_secure/1 to generate an ID of the correct size with default settings" do
      Enum.each(1..100, fn _ ->
        nanoid_length = Nanoid.generate_non_secure() |> String.length()
        assert nanoid_length == Application.get_env(:nanoid, :size, 21)
      end)
    end

    test "generate_non_secure/1 to generate an ID of the correct size with custom settings",
         context do
      Enum.each(1..100, fn _ ->
        nanoid_length = Nanoid.generate_non_secure(context[:custom_length]) |> String.length()
        assert nanoid_length == context[:custom_length]
      end)
    end

    test "generate_non_secure/2 to generate an ID of the correct size with custom settings",
         context do
      Enum.each(1..100, fn _ ->
        nanoid_length =
          Nanoid.generate_non_secure(context[:custom_length], context[:custom_alphabet])
          |> String.length()

        assert nanoid_length == context[:custom_length]
      end)
    end
  end

  describe "Non-Secure generate_non_secure_with" do
    test "is exported by the module" do
      Code.ensure_loaded!(Nanoid)
      assert :erlang.function_exported(Nanoid, :generate_non_secure_with, 1)
    end

    test "with an empty option list falls back to defaults" do
      assert String.length(Nanoid.generate_non_secure_with([])) == Application.get_env(:nanoid, :size, 21)
    end

    test "with size: option produces an ID of that size", context do
      assert String.length(Nanoid.generate_non_secure_with(size: context[:custom_length])) == context[:custom_length]
    end

    test "with alphabet: option uses that alphabet only", context do
      Nanoid.generate_non_secure_with(alphabet: context[:custom_alphabet])
      |> String.graphemes()
      |> Enum.each(fn grapheme ->
        assert String.contains?(context[:custom_alphabet], grapheme)
      end)
    end

    test "with size: and alphabet: options", context do
      nanoid = Nanoid.generate_non_secure_with(size: context[:custom_length], alphabet: context[:custom_alphabet])
      assert String.length(nanoid) == context[:custom_length]

      nanoid
      |> String.graphemes()
      |> Enum.each(fn grapheme ->
        assert String.contains?(context[:custom_alphabet], grapheme)
      end)
    end
  end
end
