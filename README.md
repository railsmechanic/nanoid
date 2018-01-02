# Nanoid port for Elixir

Elixir port of the NanoID ([https://github.com/ai/nanoid](https://github.com/ai/nanoid)) ID generator.
A tiny, secure URL-friendly unique string ID generator.

**Safe.** It uses cryptographically strong random APIs and guarantees a proper distribution of symbols.

**Small.** Only 179 bytes (minified and gzipped). No dependencies. It uses Size Limit to control size.

**Compact.** It uses a larger alphabet than UUID (A-Za-z0-9_~) and has a similar number of unique IDs in just 21 symbols instead of 36.


## Installation

The package can be installed as Hex package:

  1. Add nanoid to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:nanoid, "~> 1.0.0"}]
  end
  ```

  2. Run `mix deps.get` to fetch the package from hex


## Usage

### Generate NanoIDs of indivdiual lengths and with the default alphabet

Generate a NanoID with the default of 21 characters length
```elixir
iex> Nanoid.generate()
"mJUHrGXZBZpNX50x2xkzf"
```

Generate a NanoID with 64 characters length
```elixir
iex> Nanoid.generate(64)
"wk9fsUrhK9k~MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
```

### Generate NanoIDs of indivdiual lengths and with a custom alphabet

Generate a NanoID with the default of 21 characters length
```elixir
iex> Nanoid.generate(21, "abcdef123")
"d1dcd2dee333cae1bfdea"
```

Generate a NanoID with 64 characters length
```elixir
iex> Nanoid.generate(64, "abcdef123")
"aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
```

## License
The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
