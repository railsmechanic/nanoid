# Nanoid port for Elixir [![Build Status](https://travis-ci.org/railsmechanic/nanoid.svg?branch=master)](https://travis-ci.org/railsmechanic/nanoid)

Elixir port of NanoID ([https://github.com/ai/nanoid](https://github.com/ai/nanoid)), a tiny, secure URL-friendly unique string ID generator.

**Safe.** It uses cryptographically strong random APIs and tests distribution of symbols.

**Compact.** t uses a larger alphabet than UUID `(A-Za-z0-9_-)`. So ID size was reduced from 36 to 21 symbols.


## Installation

The package can be installed as Hex package:

  1. Add nanoid to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:nanoid, "~> 2.0.1"}]
  end
  ```

  2. Run `mix deps.get` to fetch the package from hex

## Introducing a new generator
With version 2.0.0 **[ai](https://github.com/ai/nanoid)** introduces a new `non-secure` way for creating NanoIDs.
In order to keep this port close to the original, this possibility was also introduced in this port.
To ensure a certain level of security, `nanoid` uses per default the `secure` token generator.
But according to your preferences, if you don't need "cryptographically strong random tokens", just use the `non-secure` token generator.


## Configuration
Starting with version 2.0.0 of nanoid for Elixir it's possible to use `config.exs` to configure nanoid defaults e.g. for different environments.

```elixir
config :nanoid,
  size: 21,
  alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
```

## Usage

### Using the "secure" (default) generator
#### Generate secure NanoIDs of custom size by using the default alphabet

Generate a secure NanoID with the default size of 21 characters.
```elixir
iex> Nanoid.generate()
"mJUHrGXZBZpNX50x2xkzf"
```

Generate a secure NanoID with a custom size of 64 characters.
```elixir
iex> Nanoid.generate(64)
"wk9fsUrhK9k~MxY0hLazRKpcSlic8XYDFusks7Jb8FwCVnoQaKFSPsmmLHzP7qCX"
```

#### Generate secure NanoIDs of custom size by using a custom alphabet

Generate a secure NanoID with the default size of 21 characters and an individual alphabet.
```elixir
iex> Nanoid.generate(21, "abcdef123")
"d1dcd2dee333cae1bfdea"
```

Generate a secure NanoID with custom size of 64 characters and an individual alphabet.
```elixir
iex> Nanoid.generate(64, "abcdef123")
"aabbaca3c11accca213babed2bcd1213efb3e3fa1ad23ecbf11c2ffc123f3bbe"
```

### Using the "non-secure" generator
#### Generate non-secure NanoIDs of custom size by using the default alphabet

Generate a non-secure NanoID with the default size of 21 characters.
```elixir
iex> Nanoid.generate_non_secure()
"YBctoD1RuZqv0DLfzDxl2"
```

Generate a non-secure NanoID with a custom size of 64 characters.
```elixir
iex> Nanoid.generate_non_secure(64)
"D2WBHGWQOVds4YKuErmOGJ-oYfp5rik5Z-qo7kN1Dw3gv_1qQs6POmhqZdabkf8s"
```

#### Generate non-secure NanoIDs of custom size and with a custom alphabet

Generate a non-secure NanoID with the default size of 21 characters and an individual alphabet.
```elixir
iex> Nanoid.generate_non_secure(21, "abcdef123")
"b12c2fac2bdbcdfcfb2da"
```

Generate a non-secure NanoID with custom size of 64 characters and an individual alphabet.
```elixir
iex> Nanoid.generate_non_secure(64, "abcdef123")
"dfc1ed3ea22bed1c3c2df2eb21bbd33efdfae3abd3ca2abcca1efcfbf31a3b3f"
```

## License
The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
