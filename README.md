# Nanoid port for Elixir

Elixir port of NanoID ([https://github.com/ai/nanoid](https://github.com/ai/nanoid)), a tiny, secure URL-friendly unique string ID generator.

**Safe.** It uses cryptographically strong random APIs and tests distribution of symbols.

**Compact.** It uses a larger alphabet than UUID `(A-Za-z0-9_-)`. So ID size was reduced from 36 to 21 symbols.

**Unicode-aware.** Custom alphabets containing multi-byte graphemes (e.g. `"äöü"` or emoji) are supported.


## Installation

The package can be installed as a Hex package:

  1. Add nanoid to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:nanoid, "~> 3.0"}]
  end
  ```

  2. Run `mix deps.get` to fetch the package from hex.

> **3.0 is currently a release candidate.** Pre-release versions are not
> resolved by `~> 3.0` — pin explicitly while the RC is in flight:
> ```elixir
> {:nanoid, "~> 3.0.0-rc"}
> ```

## Generators

NanoID ships two generators:

- A **secure** generator (default) backed by `:crypto.strong_rand_bytes/1`. Use this when cryptographic strength matters.
- A **non-secure** generator backed by `:rand`. Faster, but predictable — only use it when collision resistance, not unpredictability, is what you need.

## Usage

The canonical API uses keyword options:

### Secure generator

For the all-defaults case use `Nanoid.generate/0`:

```elixir
iex> Nanoid.generate()
"mJUHrGXZBZpNX50x2xkzf"
```

For anything else use `Nanoid.generate_with/1` with keyword options:

```elixir
iex> Nanoid.generate_with(size: 16)
"IRFa-VaY2b-NU5xX"

iex> Nanoid.generate_with(alphabet: "abcdef123")
"d1dcd2dee333cae1bfdea"

iex> Nanoid.generate_with(size: 12, alphabet: "abcdef123")
"d1dcd2dee333"
```

### Non-secure generator

```elixir
iex> Nanoid.generate_non_secure()
"YBctoD1RuZqv0DLfzDxl2"

iex> Nanoid.generate_non_secure_with(size: 16)
"D2WBHGWQOVds4YKu"

iex> Nanoid.generate_non_secure_with(size: 12, alphabet: "abcdef123")
"b12c2fac2bdb"
```

## Configuration

The default ID size and alphabet are baked into the compiled code via
`Application.compile_env/3`, so they can be overridden in your application's
`config/config.exs`:

```elixir
config :nanoid,
  size: 21,
  alphabet: "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
```

After changing the configuration you must re-compile nanoid:

```sh
$ mix deps.compile nanoid --force
```

> Why re-compile? The defaults are read at compile time so they end up as
> module attributes rather than runtime `Application.get_env/3` calls. This
> avoids a measurable hot-path overhead in production.

## Deprecated API (pre-3.0 style)

The positional-argument functions `Nanoid.generate/1,2` and
`Nanoid.generate_non_secure/1,2` are still available but marked as
`@deprecated`. They forward to the new keyword API and will continue to work
through the 3.x line.

> `Nanoid.generate/0` and `Nanoid.generate_non_secure/0` are **not**
> deprecated — they remain as the quick-access shortcut for the all-defaults
> case.

```elixir
# old style — still works, emits a compile-time deprecation warning
Nanoid.generate(16)
Nanoid.generate(16, "abcdef123")
Nanoid.generate_non_secure(16)

# new style — preferred
Nanoid.generate_with(size: 16)
Nanoid.generate_with(size: 16, alphabet: "abcdef123")
Nanoid.generate_non_secure_with(size: 16)
```

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
