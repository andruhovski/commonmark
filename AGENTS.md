# Repository Guidelines

## Project Structure & Module Organization

This repository provides `commonmark`, a UTF-8 CommonMark parser for V ported from MD4C. `md4c.v` contains the core parser and public event/detail types; `parser.v` provides convenience methods and flag constants. The module has no V package dependencies.

`md4c_test.v` covers internal behavior, while `tests/public_api_test.v` verifies usage from another module. `examples/events/main.v` implements an event-stream CLI. `tests/reference/` holds the C reference parser and harness for differential testing; it is not a runtime dependency. CI is defined in `.github/workflows/`.

## Build, Test, and Development Commands

Run these commands from the repository root with V on `PATH` (development was validated with V 0.5.2):

- `v test md4c_test.v tests/public_api_test.v` — run module and external API tests.
- `v fmt -verify md4c.v parser.v md4c_test.v examples/events/main.v tests/public_api_test.v` — check the formatting enforced by CI. Use `v fmt -w <file.v>` to format changes.
- `v -o commonmark-events.exe examples/events` — build the Windows example; run `./commonmark-events.exe document.md`. Omit `.exe` on Unix.
- `pwsh -File ./tests/compare.ps1` — compare V and C event streams using fixed and deterministic random inputs. Requires Clang and PowerShell 7; generated artifacts stay in ignored `tests/.validation/`.

## Coding Style & Naming Conventions

Follow `.editorconfig`: UTF-8, LF endings, a final newline, no trailing whitespace, and tabs for V indentation. Use `v fmt` for V formatting. Follow existing `snake_case` function/constant names and `PascalCase` types. Preserve MD4C-derived flag names and bit values, translated parser conventions, and upstream license notices.

## Testing Guidelines

Use V's built-in tests: files end in `_test.v`, and test functions begin with `test_`. Add regression cases for parser fixes and external-import tests for public API changes. Run differential tests for parsing or callback changes. Cover relevant flags, event details, cancellation, and attribute ownership. No numeric coverage threshold is configured.

## Commit & Pull Request Guidelines

This checkout has no Git metadata, so historical commit conventions cannot be verified. Use concise, imperative commit subjects describing the change. PRs should explain behavior changes, link relevant issues, and report validation commands and results. Include a minimal Markdown input and expected events for parser fixes; update README examples when public behavior changes.

## Memory & API Safety

Callback text and detail pointers are temporary. Respect explicit lengths and copy retained data before callbacks return; `Attribute.str()` creates an owned copy. Keep unsafe operations consistent with the parser's explicit storage management.
