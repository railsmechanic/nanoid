# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.0.0-rc.1 — 2026-05-22

Release candidate for the upcoming 3.0.0 release. API is considered stable;
please report any issues before the final release.

### Added
- New keyword-based API: `Nanoid.generate_with/1` and `Nanoid.generate_non_secure_with/1` (plus the underlying `Nanoid.Secure.generate_with/1` and `Nanoid.NonSecure.generate_with/1`). Pass `:size` and/or `:alphabet` as options. The function requires at least an (empty) options list; use `generate/0` / `generate_non_secure/0` for the no-options shortcut.
- Unicode-safe alphabets: multi-byte graphemes (`"äöü"`, emoji, combining marks) are now handled correctly. The alphabet is converted to a tuple of graphemes once per call and indexed via `elem/2`, dropping the per-symbol grapheme traversal that `String.at/2` performed previously.
- `Nanoid.Configuration.default_alphabet_tuple/0` exposes the precomputed grapheme tuple for the default alphabet.
- `CHANGELOG.md` added and linked from the Hex package.

### Changed
- **Breaking:** Minimum Elixir version bumped from `~> 1.12` to `~> 1.15`.
- **Breaking:** The library no longer ships a `config/config.exs`. Defaults remain unchanged and can still be overridden via the consuming application's config — see the README.
- `Nanoid.Configuration.default_alphabet_length/0` is now computed from the precomputed grapheme list rather than via `String.length/1`.
- `ex_doc` dev dependency bumped to `~> 0.34`; the redundant direct `earmark` dependency was removed.

### Deprecated
- The positional-argument functions `Nanoid.generate/1,2`, `Nanoid.generate_non_secure/1,2`, `Nanoid.Secure.generate/1,2` and `Nanoid.NonSecure.generate/1,2` — use the `generate_with/1` / `generate_non_secure_with/1` variants. The deprecated functions still work and preserve their previous "fall back to defaults on invalid input" behaviour so existing call sites are not broken at runtime.
- The arity-0 functions (`Nanoid.generate/0`, `Nanoid.generate_non_secure/0` and their submodule counterparts) are **not** deprecated: they remain the quick-access shortcut for the all-defaults case.

### Removed
- Dead unreachable clauses in `Nanoid.Secure` (`do_generate/5` fallback, `generator/3` fallback, `calculate_mask/1` fallback, `calculate_step/3` fallback, `random_bytes/1` fallback) and in `Nanoid.NonSecure` (`generator/2` fallback).
- Direct `earmark` dependency.
- `config/config.exs` from the library itself.

### Fixed
- `@spec` for `Nanoid.generate_non_secure/2` corrected from `binary() | any()` (effectively `any()`) to `binary() | list()`.
- Travis CI badge removed from the README; license link updated to point at the actual `LICENSE` file.

## 2.1.0

Previous release; see git history for details.
