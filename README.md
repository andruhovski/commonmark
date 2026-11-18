# commonmark

A UTF-8 CommonMark parser for V, ported from [MD4C](https://github.com/mity/md4c).
The module reports block, span, and text events through callbacks. It supports
CommonMark plus optional tables, task lists, footnotes, strikethrough, autolinks,
and the other extensions present in the bundled MD4C reference.

## Project layout

- `md4c.v`: parser implementation, callback types, enums, and detail structures.
- `parser.v`: string parsing wrapper, owned attribute strings, and flag constants.
- `examples/events/`: CLI that prints the complete parser event stream.
- `examples/md2html/`: Markdown to HTML/XHTML command line converter.
- `md4c_test.v` and `tests/public_api_test.v`: module and external-import tests.
- `tests/reference/` and `tests/compare.ps1`: C reference and differential checks.

## Install

Install directly from Git using V's `--git` option:

```sh
v install --git https://github.com/andruhovski/commonmark
```

Then import the module in your application:

```v
import commonmark
```

The module has no V package dependencies. Development was validated with
V 0.5.2; no `-enable-globals` or `-translated` command-line flags are required.

## Usage

```v
module main

import commonmark

fn on_block(_ commonmark.BlockType, _ voidptr, _ voidptr) i32 {
    return 0
}

fn on_span(_ commonmark.SpanType, _ voidptr, _ voidptr) i32 {
    return 0
}

fn on_text(_ commonmark.TextType, text &commonmark.Char, size commonmark.Size, _ voidptr) i32 {
    print(unsafe { tos(&u8(text), int(size)) })
    return 0
}

fn main() {
    parser := commonmark.Parser{
        flags: commonmark.dialect_github
        enter_block: on_block
        leave_block: on_block
        enter_span: on_span
        leave_span: on_span
        text: on_text
    }
    result := commonmark.parse('# Hello, *V*!', &parser, unsafe { nil })
    if result != 0 {
        eprintln('Parsing stopped: ${result}')
        exit(1)
    }
}
```

For this input, the example prints `Hello, V!`. It forwards text callback
bytes directly; a full text renderer must also handle break events, NUL
replacement, and entity decoding. Rendering HTML requires handling block and
span events, escaping text, and deciding how to handle raw HTML and link URLs.
A complete event-stream example, including detail casts, is
in [`examples/events/main.v`](examples/events/main.v).

## Public API

- `parse(markdown string, parser &Parser, userdata voidptr) int` parses a V string.
- `parse_raw(text &Char, size Size, parser &Parser, userdata voidptr) i32` exposes
  the lower-level buffer interface.
- `Parser` contains `flags`, five rendering callbacks, an optional `debug_log`
  callback, and reserved `abi_version` / `syntax` fields. Set all five rendering
  callbacks; leave reserved fields at their defaults.
- `BlockType`, `SpanType`, `TextType`, and `Align` identify events. Enum members
  follow MD4C names without the prefix: `.h`, `.p`, `.a`, `.em`, `.normal`, etc.
- `BlockHeadingDetail`, `BlockCodeDetail`, `BlockTableDetail`, `SpanLinkDetail`,
  and the other public detail structures describe their respective events.
- `Attribute` contains UTF-8 text plus substring types and offsets for entities
  and NULs. `attribute.str()` returns an owned copy; it does not decode entities.
- `flag_*` constants retain the MD4C flag names without `MD_`, for example
  `flag_tables`, `flag_strikethrough`, and `flag_footnotes`. Combine them with `|`.
  `dialect_commonmark` is zero. This port's `dialect_github` combines permissive
  autolinks, tables, strikethrough, task lists, admonitions, and footnotes.

For selected extensions, set `Parser.flags` to a bitmask such as
`commonmark.flag_tables | commonmark.flag_strikethrough`. See
[`parser.v`](parser.v) for all flags, including math spans, wiki links,
underline, spoilers, superscripts, subscripts, highlighting, inserted text,
and blank-line preservation. The preset follows the bundled MD4C definition;
it is not a guarantee of complete GitHub renderer compatibility.

Parsing is synchronous. The `userdata` pointer passes through unchanged to
callbacks. Return `0` from rendering callbacks to continue; any nonzero return
stops parsing and is propagated to the caller. The parser itself returns `0`
on success or `-1` on failure. A callback returning `-1` therefore cannot be
distinguished from parser failure by the result alone.

`Size` and `Offset` are `u32` byte counts/offsets, not Unicode character counts.
`parse` rejects strings larger than `0xffffffff` bytes. With `parse_raw`, the
caller supplies a valid buffer and its explicit byte length.

Callback text and detail pointers are temporary and strings need not be NUL
terminated. Respect their lengths and copy anything retained beyond the
callback. For a link callback, for example:

```v
if kind == .a {
    detail := unsafe { &commonmark.SpanLinkDetail(detail_ptr) }
    href := detail.href.str()
    // href remains valid after the callback returns.
    println(href)
}
```

## Examples and development

From the repository root:

```sh
v -o commonmark-events examples/events
./commonmark-events document.md
./commonmark-events document.md 256
v test md4c_test.v tests/public_api_test.v
v fmt -verify md4c.v parser.v md4c_test.v examples/events/main.v tests/public_api_test.v
```

On Windows, use `-o commonmark-events.exe` and run `./commonmark-events.exe`.
With no filename the example reads standard input. It defaults to CommonMark
(flags `0`). Its second argument is a decimal flag mask; `256` enables tables.
`B+`/`B-` and `S+`/`S-` mark block/span entry and exit; `T` records text,
`D` records details, and `A` records attributes. Text and attributes print as
hex bytes so embedded NULs and line endings remain visible.

The external-import test verifies public types, parser callbacks, details,
constants, and attribute ownership. To also compare against the C implementation,
install Clang and PowerShell 7, then run:

```powershell
pwsh -File ./tests/compare.ps1
```

This builds both parsers and compares complete event streams, callback details,
and attribute substring types/offsets for fixed and deterministic random inputs
across CommonMark, GitHub, and extension flag combinations. Generated files stay
in ignored `tests/.validation/`. The GitHub Actions workflow runs formatting,
V tests, the example build, and these differential tests on Linux. CI builds
the latest V checkout rather than pinning a compiler release. For contribution
conventions, see [`AGENTS.md`](AGENTS.md).

### Markdown to HTML

Build and run the converter from the repository root:

```sh
v -o md2html examples/md2html
./md2html --help
./md2html document.md
./md2html --gfm --full-html --html-title="My document" --html-css=style.css -o document.html document.md
```

On Windows, build with `-o md2html.exe`. With no input file (or `-`), the
converter reads standard input. Output defaults to standard output; `-o FILE`
writes a file. Use `--` before filenames that begin with a dash. `--stat` reports
parser and renderer callback time on standard error, in microseconds.

CommonMark is the default dialect. `--gfm` and `--github` select this module's
GitHub preset. Dialect options replace earlier parser flags; extension options
such as `--ftables`, `--ffootnotes`, and `--fno-html` add flags to the current
preset. `--help` lists every supported option.

The default output is an HTML fragment. `--full-html` adds the document wrapper,
escaped title, and optional CSS links (repeat `--html-css` for multiple stylesheets).
`--xhtml` uses XML-style void elements; combine it with `--full-html` for an XHTML
document. Entity references are decoded and escaped by default;
`--fverbatim-entities` preserves them. Math spans use `\(...\)` and `\[...\]`
delimiters inside spans for a client-side math renderer. Spoilers and admonitions
have CSS classes for styling. Raw HTML and link destinations are passed through;
this example does not sanitize untrusted Markdown.

Run converter regression tests with `v test examples/md2html`.

## Implementation and scope

The parser algorithms run in V. The port retains MD4C's pointer-based design,
unions, explicitly managed parser storage, and V's `@[translated]` mode. It uses
standard C allocation, memory, sorting, and search functions. It does not link
the original C parser. Lookup tables initialize once at startup; parse calls
use separate contexts.

Only UTF-8 is supported. ASCII-only and UTF-16 variants and the original MD4C
HTML renderer are outside this module. The md2html example implements its own
renderer and uses V's standard library for entity decoding. Tests provide regression coverage,
not a claim of exhaustive CommonMark conformance.

`tests/reference/` contains the original C parser and a small test harness solely
for differential testing. They are not dependencies of the V module.

## License

This project is licensed under the [MIT License](LICENSE). The original MD4C
copyright and permission notice is preserved in [LICENSE-md4c](LICENSE-md4c)
and `md4c.v`.
