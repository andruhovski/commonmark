@[translated]
module commonmark

// C-linkage functions supplied by external libraries
fn C.bsearch(voidptr, voidptr, uint, uint, fn (voidptr, voidptr) i32) voidptr
fn C.free(voidptr)
fn C.malloc(uint) voidptr
fn C.memchr(voidptr, i32, uint) voidptr
fn C.memcmp(voidptr, voidptr, uint) i32
fn C.memcpy(voidptr, voidptr, uint) voidptr
fn C.memmove(voidptr, voidptr, uint) voidptr
fn C.memset(voidptr, i32, uint) voidptr
fn C.qsort(voidptr, uint, uint, fn (voidptr, voidptr) i32)
fn C.realloc(voidptr, uint) voidptr
fn C.strchr(&i8, i32) &i8
fn C.strlen(&i8) uint

#include <limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

fn c2v_pointer_postfix[T](storage voidptr, pointer &T, delta int) &T {
	mut __c2v_lhs_tmp_0 := unsafe { &&T(storage) }
	unsafe { *__c2v_lhs_tmp_0 = pointer + delta }
	old := pointer
	return old
}

fn c2v_pointer_prefix[T](storage voidptr, pointer &T, delta int) &T {
	updated := unsafe { pointer + delta }
	mut __c2v_lhs_tmp_1 := unsafe { &&T(storage) }
	unsafe { *__c2v_lhs_tmp_1 = updated }
	return updated
}

@[weak]
__global md_is_unicode_whitespace___whitespace_map [8]u32

@[weak]
__global md_is_unicode_punct___punct_map [613]u32

@[weak]
__global md_get_unicode_fold_info_fold_map_1 [302]u32

@[weak]
__global md_get_unicode_fold_info_fold_map_1_data [302]u32

@[weak]
__global md_get_unicode_fold_info_fold_map_2 [53]u32

@[weak]
__global md_get_unicode_fold_info_fold_map_2_data [106]u32

@[weak]
__global md_get_unicode_fold_info_fold_map_3 [16]u32

@[weak]
__global md_get_unicode_fold_info_fold_map_3_data [48]u32

struct AnonStruct_808_40643 {
	map_         &u32
	data         &u32
	map_size     uint
	n_codepoints u32
}

@[weak]
__global md_get_unicode_fold_info_fold_map_list [3]AnonStruct_808_40643

fn md_assume(condition bool) {}

@[weak]
__global md_is_html_cdata_open_str [10]Char

fn c2v_address_of(address voidptr) voidptr {
	return address
}

struct AnonStruct_3510_131083 {
	scheme      &Char
	scheme_size Size
	suffix      &Char
	suffix_size Size
}

@[weak]
__global md_collect_marks_scheme_map [3]AnonStruct_3510_131083

fn c2v_prefix_add[T](target &T, delta T) T {
	unsafe {
		*target += delta
		return *target
	}
}

@[weak]
__global md_analyze_table_alignment_align_map [4]Align

@[weak]
__global md_process_verbatim_block_contents_indent_chunk_str [17]Char

union AnonStruct_5547_207092 {
	header BlockHeadingDetail
	code   BlockCodeDetail
	table  BlockTableDetail
	blank  BlockBlankDetail
}

union AnonStruct_5680_211728 {
	ul  BlockUlDetail
	ol  BlockOlDetail
	li  BlockLiDetail
	adm BlockAdmonitionDetail
}

@[weak]
__global md_is_html_block_start_condition_map6 [26]&TAG

// External C type declarations (from headers)

/*
 * MD4C: Markdown parser for C
 * (https://github.com/mity/md4c)
 *
 * Copyright (c) 2016-2026 Martin Mitáš
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

pub type Char = i8
pub type Size = u32
pub type Offset = u32

// Block represents a part of document hierarchy structure like a paragraph
// *or list item.
//

pub enum BlockType {
	// <body>...</body>
	doc = 0
	// <blockquote>...</blockquote>
	quote
	// <ul>...</ul>
	//     *Detail: Structure BlockUlDetail.
	ul
	// <ol>...</ol>
	//     *Detail: Structure BlockOlDetail.
	ol
	// <li>...</li>
	//     *Detail: Structure BlockLiDetail.
	li
	// <hr>
	hr
	// <h1>...</h1> (for levels up to 6)
	//     *Detail: Structure BlockHeadingDetail.
	h
	// <pre><code>...</code></pre>
	//     *Note the text lines within code blocks are terminated with '\n'
	//     *instead of explicit MD_TEXT_BR.
	code
	// Raw HTML block. This itself does not correspond to any particular HTML
	//     *tag. The contents of it _is_ raw HTML source intended to be put
	//     *in verbatim form to the HTML output.
	html
	// <p>...</p>
	p
	// <table>...</table> and its contents.
	//     *Detail: Structure BlockTableDetail (for MD_BLOCK_TABLE),
	//     *        structure BlockCellDetail (for MD_BLOCK_TH and MD_BLOCK_TD)
	//     *Note all of these are used only if extension MD_FLAG_TABLES is enabled.
	table
	thead
	tbody
	tr
	th
	td
	// Container for all referenced footnote definitions, rendered at the end
	//     *of the document.
	//     *Detail: NULL.
	//     *Note: Used only if extension MD_FLAG_FOOTNOTES is enabled, and only when
	//     *at least one footnote definition is referenced.
	footnote_def_section
	// A single footnote definition, rendered at the end of the document.
	//     *Detail: Structure BlockFootnoteDefDetail.
	//     *Note: Used only if extension MD_FLAG_FOOTNOTES is enabled.
	//     *Only definitions that are actually referenced in the document are
	//     *emitted, in order of first reference.
	footnote_def
	// Adminition extension.
	//     *Detail BlockAdmonitionDetail.
	//     *Note: Recognized only when MD_FLAG_ADMONITIONS is enabled.
	admonition
	// A run of blank lines separating two blocks. Has no contents.
	//     *Detail: Structure BlockBlankDetail.
	//     *Note: Emitted only when MD_FLAG_PRESERVEBLANKLINES is enabled.
	blank
}

// Span represents an in-line piece of a document which should be rendered with
// *the same font, color and other attributes. A sequence of spans forms a block
// *like paragraph or list item.

pub enum SpanType {
	// <em>...</em>
	em
	// <strong>...</strong>
	strong
	// <a href="xxx">...</a>
	//     *Detail: Structure SpanLinkDetail.
	a
	// <img src="xxx">...</a>
	//     *Detail: Structure SpanImageDetail.
	//     *Note: Image text can contain nested spans and even nested images.
	//     *If rendered into ALT attribute of HTML <IMG> tag, it's responsibility
	//     *of the caller to deal with it.
	//
	img
	// <code>...</code>
	code
	// <ins>...</ins>
	//     *Syntax: ++insert++
	//     *Note: Recognized only when MD_FLAG_INSERT is enabled.
	ins
	// <del>...</del>
	//     *Note: Recognized only when MD_FLAG_STRIKETHROUGH is enabled.
	//
	del
	// For recognizing inline ($) and display ($$) equations
	//     *Note: Recognized only when MD_FLAG_LATEXMATHSPANS is enabled.
	//
	latexmath
	latexmath_display
	// Wiki links
	//     *Note: Recognized only when MD_FLAG_WIKILINKS is enabled.
	//
	wikilink
	// <u>...</u>
	//     *Note: Recognized only when MD_FLAG_UNDERLINE is enabled.
	u
	// Spoiler (hidden content revealed on interaction).
	//     *Syntax: ||hidden text||
	//     *Note: Recognized only when MD_FLAG_SPOILERS is enabled.
	spoiler
	// <sup>...</sup>
	//     *Syntax: ^superscript^
	//     *Note: Recognized only when MD_FLAG_SUPERSCRIPTS is enabled.
	superscript
	// <sub>...</sub>
	//     *Syntax: ~subscript~
	//     *Note: Recognized only when MD_FLAG_SUBSCRIPTS is enabled.
	subscript
	// Footnote reference, e.g. [^1] or [^note].
	//     *Syntax: [^label]
	//     *Note: Recognized only when MD_FLAG_FOOTNOTES is enabled.
	//     *The span is self-contained: no MD_TEXT callbacks fire between enter and
	//     *leave. All needed information is in SpanFootnoteRefDetail.
	footnote_ref
	// <mark>...</mark>
	//     *Syntax: ==highlight==
	//     *Note: Recognized only when MD_FLAG_HIGHLIGHT is enabled.
	mark
}

// Text is the actual textual contents of span.

pub enum TextType {
	// Normal text.
	normal = 0
	// NULL character. CommonMark requires replacing NULL character with
	//     *the replacement char U+FFFD, so this allows caller to do that easily.
	nullchar
	// Line breaks.
	//     *Note these are not sent from blocks with verbatim output (MD_BLOCK_CODE
	//     *or MD_BLOCK_HTML). In such cases, '\n' is part of the text itself.
	br
	// <br> (hard break)
	softbr
	// '\n' in source text where it is not semantically meaningful (soft break)

	// Entity.
	//     *(a) Named entity, e.g. &nbsp;
	//     *    (Note MD4C does not have a list of known entities.
	//     *    Anything matching the regexp /&[A-Za-z][A-Za-z0-9]{1,47};/ is
	//     *    treated as a named entity.)
	//     *(b) Numerical entity, e.g. &#1234;
	//     *(c) Hexadecimal entity, e.g. &#x12AB;
	//     *     *As MD4C is mostly encoding agnostic, application gets the verbatim
	//     *entity text into the Parser::text_callback().
	entity
	// Text in a code block (inside MD_BLOCK_CODE) or inlined code (`code`).
	//     *If it is inside MD_BLOCK_CODE, it includes spaces for indentation and
	//     *'\n' for new lines. MD_TEXT_BR and MD_TEXT_SOFTBR are not sent for this
	//     *kind of text.
	code
	// Text is a raw HTML. If it is contents of a raw HTML block (i.e. not
	//     *an inline raw HTML), then MD_TEXT_BR and MD_TEXT_SOFTBR are not used.
	//     *The text contains verbatim '\n' for the new lines.
	html
	// Text is inside an equation. This is processed the same way as inlined code
	//     *spans (`code`).
	latexmath
}

// Alignment enumeration.

pub enum Align {
	default_ = 0
	// When unspecified.
	left
	center
	right
}

// String attribute.
// * *This wraps strings which are outside of a normal text flow and which are
// *propagated within various detailed structures, but which still may contain
// *string portions of different types like e.g. entities.
// * *So, for example, lets consider this image:
// * *    ![image alt text](http://example.org/image.png 'foo &quot; bar')
// * *The image alt text is propagated as a normal text via the Parser::text()
// *callback. However, the image title ('foo &quot; bar') is propagated as
// *Attribute in SpanImageDetail::title.
// * *Then the attribute SpanImageDetail::title shall provide the following:
// * -- [0]: "foo "   (substr_types[0] == MD_TEXT_NORMAL; substr_offsets[0] == 0)
// * -- [1]: "&quot;" (substr_types[1] == MD_TEXT_ENTITY; substr_offsets[1] == 4)
// * -- [2]: " bar"   (substr_types[2] == MD_TEXT_NORMAL; substr_offsets[2] == 10)
// * -- [3]: (n/a)    (n/a                              ; substr_offsets[3] == 14)
// * *Note that these invariants are always guaranteed:
// * -- substr_offsets[0] == 0
// * -- substr_offsets[LAST+1] == size
// * -- Currently, only MD_TEXT_NORMAL, MD_TEXT_ENTITY, MD_TEXT_NULLCHAR
// *    substrings can appear. This could change only if the specification
// *    changes.
//

pub struct Attribute {
pub:
	text           &Char
	size           Size
	substr_types   &TextType
	substr_offsets &Offset
}

// Detailed info for MD_BLOCK_UL.

pub struct BlockUlDetail {
pub:
	is_tight i32
	// Non-zero if tight list, zero if loose.
	mark Char
	// Item bullet character in MarkDown source of the list, e.g. '-', '+', '*.
}

// Detailed info for MD_BLOCK_OL.

pub struct BlockOlDetail {
pub:
	start u32
	// Start index of the ordered list.
	is_tight i32
	// Non-zero if tight list, zero if loose.
	mark_delimiter Char
	// Character delimiting the item marks in MarkDown source, e.g. '.' or ')'
}

// Detailed info for MD_BLOCK_LI.

pub struct BlockLiDetail {
pub:
	is_task i32
	// Can be non-zero only with MD_FLAG_TASKLISTS
	task_mark Char
	// If is_task, then one of 'x', 'X' or ' '. Undefined otherwise.
	task_mark_offset Offset
	// If is_task, then offset in the input of the char between '[' and ']'.
}

// Detailed info for MD_BLOCK_H.

pub struct BlockHeadingDetail {
pub:
	level u32
	// Header level (1 - 6)
}

// Detailed info for MD_BLOCK_CODE.

pub struct BlockCodeDetail {
pub:
	info       Attribute
	lang       Attribute
	fence_char Char
	// The character used for fenced code block; or zero for indented code block.
}

// Detailed info for MD_BLOCK_TABLE.

pub struct BlockTableDetail {
pub:
	col_count u32
	// Count of columns in the table.
	head_row_count u32
	// Count of rows in the table header (currently always 1)
	body_row_count u32
	// Count of rows in the table body
}

// Detailed info for MD_BLOCK_TH and MD_BLOCK_TD.

pub struct BlockCellDetail {
pub:
	align Align
}

// Detailed info for MD_BLOCK_ADMONITION.

pub struct BlockAdmonitionDetail {
pub:
	type_ Attribute
	// One of "note", "tip", "important", "warning", "caution"
}

// Detailed info for MD_SPAN_A.

pub struct SpanLinkDetail {
pub:
	href        Attribute
	title       Attribute
	is_autolink i32
	// nonzero if this is an autolink
}

// Detailed info for MD_SPAN_IMG.

pub struct SpanImageDetail {
pub:
	src   Attribute
	title Attribute
}

// Detailed info for MD_SPAN_WIKILINK.

pub struct SpanWikiLinkDetail {
pub:
	target Attribute
}

// Detailed info for MD_SPAN_FOOTNOTE_REF.

pub struct SpanFootnoteRefDetail {
pub:
	id u32
	// 1-based identifier of the referenced footnote
	ref_id u32
	// 1-based identifier of this reference among references to the same footnote
	label Attribute
	// Raw label text, e.g. "1" or "note"
}

// Detailed info for MD_BLOCK_FOOTNOTE_DEF.

pub struct BlockFootnoteDefDetail {
pub:
	id u32
	// 1-based identifier of this footnote
	ref_count u32
	// Number of references to this footnote
	label Attribute
	// Raw label text
}

// Detailed info for MD_BLOCK_BLANK.

pub struct BlockBlankDetail {
pub:
	line_count u32
	// Count of blank lines forming the block separation
}

// Flags specifying extensions/deviations from CommonMark specification.
// * *By default (when Parser::flags == 0), we follow CommonMark specification.
// *The following flags may allow some extensions or deviations from it.
//

// In MD_TEXT_NORMAL, collapse non-trivial whitespace into single ' '

// Do not require space in ATX headers ( ###header )

// Recognize URLs as autolinks even without '<', '>'

// Recognize e-mails as autolinks even without '<', '>' and 'mailto:'

// Disable indented code blocks. (Only fenced code works.)

// Disable raw HTML blocks.

// Disable raw HTML (inline).

// Enable tables extension.

// Enable strikethrough extension.

// Enable WWW autolinks (even without any scheme prefix, if they begin with 'www.')

// Enable task list extension.

// Enable $ and $$ containing LaTeX equations.

// Enable wiki links extension.

// Enable underline extension (and disables '_' for normal emphasis).

// Force all soft breaks to act as hard breaks.

// Enable ||hidden text|| spoiler spans.

// Enable ^superscript^ spans.

// Enable ~subscript~ spans.

// Enable admonitions extension.

// Enable [^label] footnote references.

// Enable ==highlight== spans.

// Report blank line runs as MD_BLOCK_BLANK.

// Enable insert extension.

// Convenient sets of flags corresponding to well-known Markdown dialects.
// * *Note we may only support subset of features of the referred dialect.
// *The constant just enables those extensions which bring us as close as
// *possible given what features we implement.
// * *ABI compatibility note: Meaning of these can change in time as new
// *extensions, bringing the dialect closer to the original, are implemented.
//

// Parser structure.
//

pub struct Parser {
pub:
	// Reserved. Set to zero.
	//
	abi_version u32
	// Dialect options. Bitmask of MD_FLAG_xxxx values.
	//
	flags u32
	// Caller-provided rendering callbacks.
	//     *     *For some block/span types, more detailed information is provided in a
	//     *type-specific structure pointed by the argument 'detail'.
	//     *     *The last argument of all callbacks, 'userdata', is just propagated from
	//     *parse_raw() and is available for any use by the application.
	//     *     *Note any strings provided to the callbacks as their arguments or as
	//     *members of any detail structure are generally not zero-terminated.
	//     *Application has to take the respective size information into account.
	//     *     *Any rendering callback may abort further parsing of the document by
	//     *returning non-zero.
	//
	enter_block fn (BlockType, voidptr, voidptr) i32
	leave_block fn (BlockType, voidptr, voidptr) i32
	enter_span  fn (SpanType, voidptr, voidptr) i32
	leave_span  fn (SpanType, voidptr, voidptr) i32
	text        fn (TextType, &Char, Size, voidptr) i32
	// Debug callback. Optional (may be NULL).
	//     *     *If provided and something goes wrong, this function gets called.
	//     *This is intended for debugging and problem diagnosis for developers;
	//     *it is not intended to provide any errors suitable for displaying to an
	//     *end user.
	//
	debug_log fn (&i8, voidptr)
	// Reserved. Set to NULL.
	//
	syntax fn ()
}

// For backward compatibility. Do not use in new code.
//

pub type Renderer = Parser
// Parse the Markdown document stored in the string 'text' of size 'size'.
// *The parser provides callbacks to be called during the parsing so the
// *caller can render the document on the screen or convert the Markdown
// *to another format.
// * *Zero is returned on success. If a runtime error occurs (e.g. a memory
// *fails), -1 is returned. If the processing is aborted due any callback
// *returning non-zero, the return value of the callback is returned.
//

//
// *MD4C: Markdown parser for C
// *(https://github.com/mity/md4c)
// *
// *Copyright (c) 2016-2026 Martin MitÃ¡Å¡
// *
// *Permission is hereby granted, free of charge, to any person obtaining a
// *copy of this software and associated documentation files (the "Software"),
// *to deal in the Software without restriction, including without limitation
// *the rights to use, copy, modify, merge, publish, distribute, sublicense,
// *and/or sell copies of the Software, and to permit persons to whom the
// *Software is furnished to do so, subject to the following conditions:
// *
// *The above copyright notice and this permission notice shall be included in
// *all copies or substantial portions of the Software.
// *
// *THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// *OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// *FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// *AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// *LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// *FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// *IN THE SOFTWARE.
//

//**************
// ** Miscellaneous Stuff  **
// **************

// Make the UTF-8 support the default.

// Magic for making wide literals with MD4C_USE_UTF16.

// Misc. macros.

// For falling through case labels in switch statements.

// Suppress "unused parameter" warnings.

//***************
// ** Some internal limits  **
// ***************/
//
///*We limit code span marks to lower than 32 backticks. This solves the
// *pathologic case of too many openers, each of different length: Their
// *resolving would be then O(n^2).

//************
// ** Internal Types  **
// ************/
//
///*These are omnipresent so lets save some typing.

type MD_MARK = MD_MARK_tag
type MD_BLOCK = MD_BLOCK_tag
type MD_CONTAINER = MD_CONTAINER_tag
type MD_REF_DEF = MD_REF_DEF_tag
type MD_FOOTNOTE_DEF = MD_FOOTNOTE_DEF_tag
// Forward declaration; full definition is below with MD_LINE_tag.

type MD_LINE = MD_LINE_tag
type MD_LABEL_HASH_ENTRY = MD_LABEL_HASH_ENTRY_tag

struct MD_LABEL_HASH_ENTRY_tag {
	label      &Char
	label_size Size
	hash       u32
}

type MD_LABEL_HASH_TABLE = MD_LABEL_HASH_TABLE_tag

union MD_LABEL_HASH_TABLE_tag_c2v_anonymous_5198 {
	defs          voidptr
	ref_defs      &MD_REF_DEF
	footnote_defs &MD_FOOTNOTE_DEF
}

struct MD_LABEL_HASH_TABLE_tag {
	// Flat array of all records.
	c2v_anonymous_5198 MD_LABEL_HASH_TABLE_tag_c2v_anonymous_5198
	def_size           u32
	n_defs             u32
	alloc_defs         u32
	// The hashtable itself, where the actual entries are pointers into the
	//     *array defs[] above.
	buckets   &voidptr
	n_buckets u32
}

// During analyzes of inline marks, we need to manage stacks of unresolved
// *openers of the given type.
// *The stack connects the marks via MD_MARK::next;
//

type MD_MARKSTACK = MD_MARKSTACK_tag

struct MD_MARKSTACK_tag {
	top i32
	// -1 if empty.
}

// Context propagated through all the parsing.

type MD_CTX = MD_CTX_tag

struct MD_CTX_tag {
	// Immutable stuff (parameters of parse_raw()).
	text     &Char
	size     Size
	parser   Parser
	userdata voidptr
	// For optimized scan for new line.
	cr_horizon Offset
	lf_horizon Offset
	// Helper temporary growing buffer.
	buffer       &Char
	alloc_buffer u32
	// Reference definitions.
	ref_def_hashtable  MD_LABEL_HASH_TABLE
	max_ref_def_output Size
	// Footnote definitions.
	footnote_hashtable  MD_LABEL_HASH_TABLE
	next_footnote_index u32
	// 1-based counter for sequential numbering
	footnote_order &&MD_FOOTNOTE_DEF
	// Stack of inline/span markers.
	//     *This is only used for parsing a single block contents but by storing it
	//     *here we may reuse the stack for subsequent blocks; i.e. we have fewer
	//     *(re)allocations.
	marks         &MD_MARK
	n_marks       i32
	alloc_marks   i32
	mark_char_map [256]i8
	// For resolving of inline spans.
	opener_stacks [20]MD_MARKSTACK
	// Opener-only

	// Both opener and closer candidate

	// Opener-only

	// Both opener and closer candidate

	// Stack of dummies which need to call free() for pointers stored in them.
	//     *These are constructed during inline parsing and freed after all the block
	//     *is processed (i.e. all callbacks referring those strings are called).
	ptr_stack MD_MARKSTACK
	// For resolving table rows.
	n_table_cell_boundaries    i32
	table_cell_boundaries_head i32
	table_cell_boundaries_tail i32
	// For resolving links.
	unresolved_link_head i32
	unresolved_link_tail i32
	// For resolving raw HTML.
	html_comment_horizon    Offset
	html_proc_instr_horizon Offset
	html_decl_horizon       Offset
	html_cdata_horizon      Offset
	// For resolving permissive autolinks.
	permissive_autolink_tail_horizon Offset
	// For block analysis.
	//     *Notes:
	//     *  -- It holds MD_BLOCK as well as MD_LINE structures. After each
	//     *     MD_BLOCK, its (multiple) MD_LINE(s) follow.
	//     *  -- For MD_BLOCK_HTML and MD_BLOCK_CODE, MD_VERBATIMLINE(s) are used
	//     *     instead of MD_LINE(s).
	//
	block_bytes       voidptr
	current_block     &MD_BLOCK
	n_block_bytes     i32
	alloc_block_bytes i32
	// Pending count of blank lines not yet reported as MD_BLOCK_BLANK.
	//     *Used only with MD_FLAG_PRESERVEBLANKLINES.
	n_blank_lines u32
	// For container block analysis.
	containers       &MD_CONTAINER
	n_containers     i32
	alloc_containers i32
	// Minimal indentation to call the block "indented code block".
	code_indent_offset u32
	// Contextual info for line analysis.
	code_fence_length Size
	// For checking closing fence length.
	html_block_type i32
	// For checking closing raw HTML condition.
	last_line_has_list_loosening_effect i32
	consecutive_blank_lines             i32
	last_n_implicit_parents_beg         i32
	last_n_implicit_parents_end         i32
}

enum MD_LINETYPE {
	md_line_blank
	md_line_hr
	md_line_atxheader
	md_line_setextheader
	md_line_setextunderline
	md_line_indentedcode
	md_line_fencedcode
	md_line_html
	md_line_text
	md_line_table
	md_line_tableunderline
}

type MD_LINE_ANALYSIS = MD_LINE_ANALYSIS_tag

struct MD_LINE_ANALYSIS_tag {
	type_             MD_LINETYPE
	data              u32
	enforce_new_block i32
	beg               Offset
	end               Offset
	indent            u32
	// Indentation level.
}

struct MD_LINE_tag {
	beg Offset
	end Offset
}

type MD_VERBATIMLINE = MD_VERBATIMLINE_tag

struct MD_VERBATIMLINE_tag {
	beg    Offset
	end    Offset
	indent Offset
}

//********
// ** Helpers  **
// ********

// Character accessors.

// Character classification.
// *Note we assume ASCII compatibility of code points < 128 here.

// wmemchar()

// Case insensitive check of string equality.

fn md_ascii_case_eq(s1 &Char, s2 &Char, n Size) i32 {
	i := Offset(0)
	for i = Offset(0); i < n; i++ {
		ch1 := s1[i]
		ch2 := s2[i]
		if (u32(`a`) <= u32(ch1) && u32(ch1) <= u32(`z`)) {
			ch1 += (i32(`A`) - i32(`a`))
		}
		if (u32(`a`) <= u32(ch2) && u32(ch2) <= u32(`z`)) {
			ch2 += (i32(`A`) - i32(`a`))
		}
		if i32(ch1) != i32(ch2) {
			return 0
		}
	}
	return 1
}

fn md_ascii_eq(s1 &Char, s2 &Char, n Size) i32 {
	return i32(C.memcmp(voidptr(s1), voidptr(s2), n * sizeof(Char)) == 0)
}

fn with_null_replacement(ctx &MD_CTX, type_ TextType, str &Char, size Size) i32 {
	off := Offset(0)
	ret := i32(0)
	for {
		for off < size && i32(str[off]) != i8(`\0`) {
			off++
		}
		if off > Offset(0) {
			ret = ctx.parser.text(type_, str, off, voidptr(ctx.userdata))
			if ret != 0 {
				return ret
			}
			c2v_pointer_prefix(voidptr(&str), str, int(off))
			size -= off
			off = Offset(0)
		}
		if off >= size {
			return 0
		}
		ret = ctx.parser.text(TextType(TextType.nullchar), c'', Size(1), voidptr(ctx.userdata))
		if ret != 0 {
			return ret
		}
		off++
	}
	panic('unreachable after C for (;;)')
}

// If the offset falls into a gap between line, we return the following
// *line.

fn md_lookup_line(off Offset, lines &MD_LINE, n_lines Size, p_line_index &Size) &MD_LINE {
	lo := Size(0)
	hi := Size(0)

	pivot := Size(0)
	line := &MD_LINE(0)
	lo = Size(0)
	hi = n_lines - Size(1)
	for lo <= hi {
		pivot = (lo + hi) / Size(2)
		line = unsafe { lines + pivot }
		if off < line.beg {
			if hi == Size(0) || lines[hi - Size(1)].end < off {
				if uint(p_line_index) != uint((voidptr(0))) {
					unsafe { *p_line_index = pivot }
				}
				return line
			}
			hi = pivot - Size(1)
		} else if off > line.end {
			lo = pivot + Size(1)
		} else {
			if uint(p_line_index) != uint((voidptr(0))) {
				unsafe { *p_line_index = pivot }
			}
			return line
		}
	}
	return unsafe { nil }
}

//************
// ** Unicode Support  **
// ************

type MD_UNICODE_FOLD_INFO = MD_UNICODE_FOLD_INFO_tag

struct MD_UNICODE_FOLD_INFO_tag {
	codepoints   [3]u32
	n_codepoints u32
}

// Binary search over sorted "map" of codepoints. Consecutive sequences
//     *of codepoints may be encoded in the map by just using the
//     *(MIN_CODEPOINT | 0x40000000) and (MAX_CODEPOINT | 0x80000000).
//     *
//     *Returns index of the found record in the map (in the case of ranges,
//     *the minimal value is used); or -1 on failure.

fn md_unicode_bsearch__(codepoint u32, map_ &u32, map_size uint) i32 {
	beg := i32(0)
	end := i32(0)

	pivot_beg := i32(0)
	pivot_end := i32(0)

	beg = 0
	end = i32(map_size) - 1
	for beg <= end {
		// Pivot may be a range, not just a single value.

		pivot_end = (beg + end) / 2
		pivot_beg = pivot_end
		if map_[pivot_end] & u32(1073741824) {
			pivot_end++
		}
		if map_[pivot_beg] & u32(2147483648) {
			pivot_beg--
		}
		if codepoint < (map_[pivot_beg] & u32(16777215)) {
			end = pivot_beg - 1
		} else if codepoint > (map_[pivot_end] & u32(16777215)) {
			beg = pivot_end + 1
		} else {
			return pivot_beg
		}
	}
	return -1
}

fn md_is_unicode_whitespace__(codepoint u32) i32 {
	// Unicode "Zs" category.
	//         *(generated by scripts/build_whitespace_map.py)

	// The ASCII ones are the most frequently used ones, also CommonMark
	//         *specification requests few more in this range.

	if codepoint <= u32(127) {
		return i32(((codepoint == u32(` `) || codepoint == u32(`\t`)) || (codepoint == u32(`\v`) || codepoint == u32(`\f`))))
	}
	return i32((md_unicode_bsearch__(codepoint, &md_is_unicode_whitespace___whitespace_map[0], 8) >= 0))
}

fn md_is_unicode_punct__(codepoint u32) i32 {
	// Unicode general "P" and "S" categories.
	//         *(generated by scripts/build_punct_map.py)

	// The ASCII ones are the most frequently used ones, also CommonMark
	//         *specification requests few more in this range.

	if codepoint <= u32(127) {
		return i32(((u32(33) <= u32(codepoint) && u32(codepoint) <= u32(47)) || (u32(58) <= u32(codepoint) && u32(codepoint) <= u32(64)) || (u32(91) <= u32(codepoint) && u32(codepoint) <= u32(96)) || (u32(123) <= u32(codepoint) && u32(codepoint) <= u32(126))))
	}
	return i32((md_unicode_bsearch__(codepoint, &md_is_unicode_punct___punct_map[0], 613) >= 0))
}

fn md_get_unicode_fold_info(codepoint u32, info &MD_UNICODE_FOLD_INFO) {
	// Unicode "Pc", "Pd", "Pe", "Pf", "Pi", "Po", "Ps" categories.
	//         *(generated by scripts/build_folding_map.py)

	i := i32(0)
	// Fast path for ASCII characters.

	if codepoint <= u32(127) {
		info.codepoints[0] = codepoint
		if (u32(`A`) <= u32(codepoint) && u32(codepoint) <= u32(`Z`)) {
			info.codepoints[0] += u32(i32(`a`) - i32(`A`))
		}
		info.n_codepoints = u32(1)
		return
	}
	// Try to locate the codepoint in any of the maps.

	for i = 0; i < 3; i++ {
		index := i32(0)
		index = md_unicode_bsearch__(codepoint, md_get_unicode_fold_info_fold_map_list[i].map_, md_get_unicode_fold_info_fold_map_list[i].map_size)
		if index >= 0 {
			// Found the mapping.

			n_codepoints := md_get_unicode_fold_info_fold_map_list[i].n_codepoints
			map_ := md_get_unicode_fold_info_fold_map_list[i].map_
			codepoints := md_get_unicode_fold_info_fold_map_list[i].data + (u32(index) * n_codepoints)
			C.memcpy(info.codepoints, voidptr(codepoints), sizeof(u32) * n_codepoints)
			info.n_codepoints = n_codepoints
			if md_get_unicode_fold_info_fold_map_list[i].map_[index] != codepoint {
				// The found mapping maps whole range of codepoints,
				//                     *i.e. we have to offset info->codepoints[0] accordingly.

				if (map_[index] & u32(16777215)) + u32(1) == codepoints[0] {
					// Alternating type of the range.

					info.codepoints[0] = codepoint + u32((if (codepoint & u32(1)) == (map_[index] & u32(1)) {
						1
					} else {
						0
					}))
				} else {
					// Range to range kind of mapping.

					info.codepoints[0] += (codepoint - (map_[index] & u32(16777215)))
				}
			}
			return
		}
	}
	// No mapping found. Map the codepoint to itself.

	info.codepoints[0] = codepoint
	info.n_codepoints = u32(1)
}

// No whitespace uses surrogates, so no decoding needed here.

fn md_decode_utf8__(str &Char, str_size Size, p_size &Size) u32 {
	if !(i32(u8(str[0])) <= 127) {
		if ((i32(u8(str[0])) & 224) == 192) {
			if Size(1) < str_size && ((i32(u8(str[1])) & 192) == 128) {
				if uint(p_size) != uint((voidptr(0))) {
					unsafe { *p_size = Size(2) }
				}
				return ((u32(str[0]) & u32(31)) << 6) | ((u32(str[1]) & u32(63)) << 0)
			}
		} else if ((i32(u8(str[0])) & 240) == 224) {
			if Size(2) < str_size && ((i32(u8(str[1])) & 192) == 128) && ((i32(u8(str[2])) & 192) == 128) {
				if uint(p_size) != uint((voidptr(0))) {
					unsafe { *p_size = Size(3) }
				}
				return ((u32(str[0]) & u32(15)) << 12) | ((u32(str[1]) & u32(63)) << 6) | ((u32(str[2]) & u32(63)) << 0)
			}
		} else if ((i32(u8(str[0])) & 248) == 240) {
			if Size(3) < str_size && ((i32(u8(str[1])) & 192) == 128) && ((i32(u8(str[2])) & 192) == 128) && ((i32(u8(str[3])) & 192) == 128) {
				if uint(p_size) != uint((voidptr(0))) {
					unsafe { *p_size = Size(4) }
				}
				return ((u32(str[0]) & u32(7)) << 18) | ((u32(str[1]) & u32(63)) << 12) | ((u32(str[2]) & u32(63)) << 6) | ((u32(str[3]) & u32(63)) << 0)
			}
		}
	}
	if uint(p_size) != uint((voidptr(0))) {
		unsafe { *p_size = Size(1) }
	}
	return u32(str[0])
}

fn md_decode_utf8_before__(ctx &MD_CTX, off Offset) u32 {
	if !(i32(u8(ctx.text[(off - Offset(1))])) <= 127) {
		if off > Offset(1) && ((i32(u8(ctx.text[(off - Offset(2))])) & 224) == 192) && ((i32(u8(ctx.text[(off - Offset(1))])) & 192) == 128) {
			return ((u32(ctx.text[(off - Offset(2))]) & u32(31)) << 6) | ((u32(ctx.text[(off - Offset(1))]) & u32(63)) << 0)
		}
		mut __c2v_condition_0 := false
		mut __c2v_condition_1 := false
		__c2v_condition_1 = off > Offset(2)
		if __c2v_condition_1 {
			__c2v_condition_1 = ((i32(u8(ctx.text[(off - Offset(3))])) & 240) == 224)
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = ((i32(u8(ctx.text[(off - Offset(2))])) & 192) == 128)
		}
		if __c2v_condition_1 {
			__c2v_condition_1 = ((i32(u8(ctx.text[(off - Offset(1))])) & 192) == 128)
		}
		__c2v_condition_0 = __c2v_condition_1
		if __c2v_condition_0 {
			return ((u32(ctx.text[(off - Offset(3))]) & u32(15)) << 12) | ((u32(ctx.text[(off - Offset(2))]) & u32(63)) << 6) | ((u32(ctx.text[(off - Offset(1))]) & u32(63)) << 0)
		}
		mut __c2v_condition_2 := false
		mut __c2v_condition_3 := false
		__c2v_condition_3 = off > Offset(3)
		if __c2v_condition_3 {
			__c2v_condition_3 = ((i32(u8(ctx.text[(off - Offset(4))])) & 248) == 240)
		}
		if __c2v_condition_3 {
			__c2v_condition_3 = ((i32(u8(ctx.text[(off - Offset(3))])) & 192) == 128)
		}
		if __c2v_condition_3 {
			__c2v_condition_3 = ((i32(u8(ctx.text[(off - Offset(2))])) & 192) == 128)
		}
		if __c2v_condition_3 {
			__c2v_condition_3 = ((i32(u8(ctx.text[(off - Offset(1))])) & 192) == 128)
		}
		__c2v_condition_2 = __c2v_condition_3
		if __c2v_condition_2 {
			return ((u32(ctx.text[(off - Offset(4))]) & u32(7)) << 18) | ((u32(ctx.text[(off - Offset(3))]) & u32(63)) << 12) | ((u32(ctx.text[(off - Offset(2))]) & u32(63)) << 6) | ((u32(ctx.text[(off - Offset(1))]) & u32(63)) << 0)
		}
	}
	return u32(ctx.text[(off - Offset(1))])
}

fn md_decode_unicode(str &Char, off Offset, str_size Size, p_char_size &Size) u32 {
	return md_decode_utf8__(str + off, str_size - off, p_char_size)
}

//******************
// ** Helper string manipulations  **
// ******************

// Fill buffer with copy of the string between 'beg' and 'end' but replace any
// *line breaks with given replacement character.
// *
// *NOTE: Caller is responsible to make sure the buffer is large enough.
// *(Given the output is always shorter than input, (end - beg) is good idea
// *what the caller should allocate.)
//

fn md_merge_lines(ctx &MD_CTX, beg Offset, end Offset, lines &MD_LINE, n_lines Size, line_break_replacement_char Char, buffer &Char, p_size &Size) {
	ptr := buffer
	line_index := i32(0)
	off := beg

	for {
		line := unsafe { lines + line_index }
		line_end := line.end
		if end < line_end {
			line_end = end
		}
		for off < line_end {
			unsafe { *ptr = ctx.text[off] }
			c2v_pointer_postfix(voidptr(&ptr), ptr, int(1))
			off++
		}
		if off >= end {
			unsafe { *p_size = Size((i64((int(ptr) - int(buffer)) / int(sizeof(i8))))) }
			return
		}
		unsafe { *ptr = line_break_replacement_char }
		c2v_pointer_postfix(voidptr(&ptr), ptr, int(1))
		line_index++
		off = lines[line_index].beg
	}
}

// Wrapper of md_merge_lines() which allocates new buffer for the output string.
//

fn md_merge_lines_alloc(ctx &MD_CTX, beg Offset, end Offset, lines &MD_LINE, n_lines Size, line_break_replacement_char Char, p_str &&Char, p_size &Size) i32 {
	buffer := &Char(0)
	buffer = &Char(C.malloc(sizeof(Char) * (end - beg)))
	if uint(buffer) == uint((voidptr(0))) {
		for {
			if ctx.parser.debug_log != (voidptr(0)) {
				ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
			}
			// while()
			break
		}
		return -1
	}
	md_merge_lines(ctx, beg, end, lines, n_lines, line_break_replacement_char, buffer, p_size)
	unsafe { *p_str = buffer }
	return 0
}

fn md_skip_unicode_whitespace(label &Char, off Offset, size Size) Offset {
	char_size := Size(0)
	codepoint := u32(0)
	for off < size {
		codepoint = md_decode_unicode(label, off, size, &char_size)
		if !md_is_unicode_whitespace__(codepoint) && !(i32(label[off]) == i8(`\r`) || i32(label[off]) == i8(`\n`)) {
			break
		}
		off += char_size
	}
	return off
}

//***************
// ** Recognizing raw HTML  **
// ***************/
//
///*md_is_html_tag() may be called when processing inlines (inline raw HTML)
// *or when breaking document to blocks (checking for start of HTML block type 7).
// *
// *When breaking document to blocks, we do not yet know line boundaries, but
// *in that case the whole tag has to live on a single line. We distinguish this
// *by n_lines == 0.
//

fn md_is_html_tag(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset) i32 {
	attr_state := i32(0)
	off := beg
	line_end := if (n_lines > Size(0)) { lines[0].end } else { ctx.size }
	line_index := Size(0)
	for {
		md_assume((i32(ctx.text[beg]) == i8(`<`)))
		// while()
		break
	}
	if off + Offset(1) >= line_end {
		return 0
	}
	off++
	// For parsing attributes, we need a little state automaton below.
	//     *State -1: no attributes are allowed.
	//     *State 0: attribute could follow after some whitespace.
	//     *State 1: after a whitespace (attribute name may follow).
	//     *State 2: after attribute name ('=' MAY follow).
	//     *State 3: after '=' (value specification MUST follow).
	//     *State 41: in middle of unquoted attribute value.
	//     *State 42: in middle of single-quoted attribute value.
	//     *State 43: in middle of double-quoted attribute value.
	//

	attr_state = 0
	if i32(ctx.text[off]) == i8(`/`) {
		// Closer tag "</ ... >". No attributes may be present.

		attr_state = -1
		off++
	}
	// Tag name

	if off >= line_end || !((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) {
		return 0
	}
	off++
	for off < line_end && ((((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`))) || i32(ctx.text[off]) == i8(`-`)) {
		off++
	}
	// (Optional) attributes (if not closer), (optional) '/' (if not closer)
	//     *and final '>'.

	for {
		for off < line_end && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
			if attr_state > 40 {
				mut __c2v_condition_4 := false
				mut __c2v_condition_5 := false
				__c2v_condition_5 = attr_state == 41
				if __c2v_condition_5 {
					__c2v_condition_5 = ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'"\'=<>`'[0]) }, i32(ctx.text[off]))) != uint((voidptr(0)))))
				}
				__c2v_condition_4 = __c2v_condition_5
				if __c2v_condition_4 {
					attr_state = 0
					off--
				} else if (attr_state == 42 && i32(ctx.text[off]) == i8(`\'`)) || (attr_state == 43 && i32(ctx.text[off]) == i8(`\"`)) {
					attr_state = 0
				}
				off++
			} else if ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
				if attr_state == 0 {
					attr_state = 1
				}
				off++
			} else if attr_state <= 2 && i32(ctx.text[off]) == i8(`>`) {
				// End.

				unsafe {
					goto done
				}
			} else if attr_state <= 2 && i32(ctx.text[off]) == i8(`/`) && off + Offset(1) < line_end && i32(ctx.text[(off + Offset(1))]) == i8(`>`) {
				// End with digraph '/>'

				off++
				unsafe {
					goto done
				}
			} else if (attr_state == 1 || attr_state == 2) && (((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || i32(ctx.text[off]) == i8(`_`) || i32(ctx.text[off]) == i8(`:`)) {
				off++
				// Attribute name

				for off < line_end && ((((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`))) || (i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'_.:-'[0]) }, i32(ctx.text[off]))) != uint((voidptr(0))))) {
					off++
				}
				attr_state = 2
			} else if attr_state == 2 && i32(ctx.text[off]) == i8(`=`) {
				// Attribute assignment sign

				off++
				attr_state = 3
			} else if attr_state == 3 {
				// Expecting start of attribute value.

				if i32(ctx.text[off]) == i8(`\"`) {
					attr_state = 43
				} else if i32(ctx.text[off]) == i8(`\'`) {
					attr_state = 42
				} else if !(i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'"\'=<>`'[0]) }, i32(ctx.text[off]))) != uint((voidptr(0)))) && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
					attr_state = 41
				} else {
					return 0
				}
				off++
			} else {
				return 0
			}
		}
		if n_lines == Size(0) {
			return 0
		}
		line_index++
		if line_index >= n_lines {
			return 0
		}
		off = lines[line_index].beg
		line_end = lines[line_index].end
		if attr_state == 0 || attr_state == 41 {
			attr_state = 1
		}
		if off >= max_end {
			return 0
		}
	}
	done:
	if off >= max_end {
		return 0
	}
	unsafe { *p_end = off + Offset(1) }
	return 1
}

fn md_scan_for_html_closer(ctx &MD_CTX, str &Char, len Size, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset, p_scan_horizon &Offset) i32 {
	off := beg
	line_index := Size(0)
	if off < (unsafe { *p_scan_horizon }) && (unsafe { *p_scan_horizon }) >= max_end - len {
		return 0
	}
	for {
		for off + len <= lines[line_index].end && off + len <= max_end {
			if md_ascii_eq((ctx.text + off), str, len) {
				unsafe { *p_end = off + len }
				return 1
			}
			off++
		}
		line_index++
		if off >= max_end || line_index >= n_lines {
			unsafe { *p_scan_horizon = off }
			return 0
		}
		off = lines[line_index].beg
	}
	panic('unreachable after C for (;;)')
}

fn md_is_html_comment(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg
	for {
		md_assume((i32(ctx.text[beg]) == i8(`<`)))
		// while()
		break
	}
	if off + Offset(4) >= lines[0].end {
		return 0
	}
	if i32(ctx.text[(off + Offset(1))]) != i8(`!`) || i32(ctx.text[(off + Offset(2))]) != i8(`-`) || i32(ctx.text[(off + Offset(3))]) != i8(`-`) {
		return 0
	}
	off += Offset(2)
	return md_scan_for_html_closer(ctx, c'-->', Size(3), lines, n_lines, off, max_end, p_end, &ctx.html_comment_horizon)
}

fn md_is_html_processing_instruction(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg
	if off + Offset(2) >= lines[0].end {
		return 0
	}
	if i32(ctx.text[(off + Offset(1))]) != i8(`?`) {
		return 0
	}
	off += Offset(2)
	return md_scan_for_html_closer(ctx, c'?>', Size(2), lines, n_lines, off, max_end, p_end, &ctx.html_proc_instr_horizon)
}

fn md_is_html_declaration(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg
	if off + Offset(2) >= lines[0].end {
		return 0
	}
	if i32(ctx.text[(off + Offset(1))]) != i8(`!`) {
		return 0
	}
	off += Offset(2)
	if off >= lines[0].end || !((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) {
		return 0
	}
	off++
	for off < lines[0].end && ((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) {
		off++
	}
	return md_scan_for_html_closer(ctx, c'>', Size(1), lines, n_lines, off, max_end, p_end, &ctx.html_decl_horizon)
}

fn md_is_html_cdata(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset) i32 {
	static open_size := 9
	off := beg
	if off + open_size >= lines[0].end {
		return 0
	}
	if C.memcmp(voidptr((ctx.text + off)), voidptr(unsafe { &md_is_html_cdata_open_str[0] }), open_size * sizeof(Char)) != 0 {
		return 0
	}
	off += open_size
	return md_scan_for_html_closer(ctx, c']]>', Size(3), lines, n_lines, off, max_end, p_end, &ctx.html_cdata_horizon)
}

fn md_is_html_any(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, max_end Offset, p_end &Offset) i32 {
	for {
		md_assume((i32(ctx.text[beg]) == i8(`<`)))
		// while()
		break
	}
	return i32((md_is_html_tag(ctx, lines, n_lines, beg, max_end, p_end) || md_is_html_comment(ctx, lines, n_lines, beg, max_end, p_end) || md_is_html_processing_instruction(ctx, lines, n_lines, beg, max_end, p_end) || md_is_html_declaration(ctx, lines, n_lines, beg, max_end, p_end) || md_is_html_cdata(ctx, lines, n_lines, beg, max_end, p_end)))
}

fn md_is_hex_entity_contents(ctx &MD_CTX, text &Char, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg

	for off < max_end && ((u32(`0`) <= u32(text[off]) && u32(text[off]) <= u32(`9`)) || (u32(`A`) <= u32(text[off]) && u32(text[off]) <= u32(`F`)) || (u32(`a`) <= u32(text[off]) && u32(text[off]) <= u32(`f`))) && off - beg <= Offset(8) {
		off++
	}
	if Offset(1) <= off - beg && off - beg <= Offset(6) {
		unsafe { *p_end = off }
		return 1
	} else {
		return 0
	}
}

fn md_is_dec_entity_contents(ctx &MD_CTX, text &Char, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg

	for off < max_end && (u32(`0`) <= u32(text[off]) && u32(text[off]) <= u32(`9`)) && off - beg <= Offset(8) {
		off++
	}
	if Offset(1) <= off - beg && off - beg <= Offset(7) {
		unsafe { *p_end = off }
		return 1
	} else {
		return 0
	}
}

fn md_is_named_entity_contents(ctx &MD_CTX, text &Char, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg

	if off < max_end && ((u32(`A`) <= u32(text[off]) && u32(text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(text[off]) && u32(text[off]) <= u32(`z`))) {
		off++
	} else {
		return 0
	}
	for off < max_end && (((u32(`A`) <= u32(text[off]) && u32(text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(text[off]) && u32(text[off]) <= u32(`z`))) || (u32(`0`) <= u32(text[off]) && u32(text[off]) <= u32(`9`))) && off - beg <= Offset(48) {
		off++
	}
	if Offset(2) <= off - beg && off - beg <= Offset(48) {
		unsafe { *p_end = off }
		return 1
	} else {
		return 0
	}
}

fn md_is_entity_str(ctx &MD_CTX, text &Char, beg Offset, max_end Offset, p_end &Offset) i32 {
	is_contents := i32(0)
	off := beg
	for {
		md_assume((i32(text[off]) == i8(`&`)))
		// while()
		break
	}
	off++
	if off + Offset(2) < max_end && i32(text[off]) == i8(`#`) && (i32(text[off + Offset(1)]) == i8(`x`) || i32(text[off + Offset(1)]) == i8(`X`)) {
		is_contents = md_is_hex_entity_contents(ctx, text, off + Offset(2), max_end, &off)
	} else if off + Offset(1) < max_end && i32(text[off]) == i8(`#`) {
		is_contents = md_is_dec_entity_contents(ctx, text, off + Offset(1), max_end, &off)
	} else {
		is_contents = md_is_named_entity_contents(ctx, text, off, max_end, &off)
	}
	if is_contents && off < max_end && i32(text[off]) == i8(`;`) {
		unsafe { *p_end = off + Offset(1) }
		return 1
	} else {
		return 0
	}
}

fn md_is_entity(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset) i32 {
	return md_is_entity_str(ctx, ctx.text, beg, max_end, p_end)
}

type MD_ATTRIBUTE_BUILD = MD_ATTRIBUTE_BUILD_tag

struct MD_ATTRIBUTE_BUILD_tag {
	text            &Char
	substr_types    &TextType
	substr_offsets  &Offset
	substr_count    Size
	substr_alloc    Size
	trivial_types   [1]TextType
	trivial_offsets [2]Offset
}

fn md_build_attr_append_substr(ctx &MD_CTX, build &MD_ATTRIBUTE_BUILD, type_ TextType, off Offset) i32 {
	if build.substr_count >= build.substr_alloc {
		new_substr_types := &TextType(0)
		new_substr_offsets := &Offset(0)
		new_alloc := (if build.substr_alloc > Size(0) {
			build.substr_alloc + build.substr_alloc / Size(2)
		} else {
			Size(8)
		})
		new_substr_types = &TextType(C.realloc(voidptr(build.substr_types), new_alloc * sizeof(TextType)))
		if uint(new_substr_types) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			return -1
		}
		build.substr_types = new_substr_types
		new_substr_offsets = &Offset(C.realloc(voidptr(build.substr_offsets), (new_alloc + Size(1)) * sizeof(Offset)))
		if uint(new_substr_offsets) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			return -1
		}
		build.substr_offsets = new_substr_offsets
		build.substr_alloc = new_alloc
	}
	build.substr_types[build.substr_count] = type_
	build.substr_offsets[build.substr_count] = off
	build.substr_count++
	return 0
}

fn md_free_attribute(ctx &MD_CTX, build &MD_ATTRIBUTE_BUILD) {
	if uint(build.substr_types) != uint(unsafe { &build.trivial_types[0] }) {
		C.free(voidptr(build.text))
		C.free(voidptr(build.substr_types))
		C.free(voidptr(build.substr_offsets))
		build.text = unsafe { nil }
		build.substr_types = unsafe { nil }
		build.substr_offsets = unsafe { nil }
		build.substr_alloc = Size(0)
		build.substr_count = Size(0)
	}
}

fn md_build_attribute(ctx &MD_CTX, raw_text &Char, raw_size Size, flags u32, attr &Attribute, build &MD_ATTRIBUTE_BUILD) i32 {
	raw_off := Offset(0)
	off := Offset(0)

	is_trivial := i32(0)
	ret := i32(0)
	C.memset(voidptr(build), 0, sizeof(MD_ATTRIBUTE_BUILD))
	is_trivial = 1
	for raw_off = Offset(0); raw_off < raw_size; raw_off++ {
		if (i32(raw_text[raw_off]) == i8(`\\`) || i32(raw_text[raw_off]) == i8(`&`) || i32(raw_text[raw_off]) == i8(`\0`)) {
			is_trivial = 0
			break
		}
	}
	if is_trivial {
		build.text = if raw_size { &Char(raw_text) } else { &Char((voidptr(0))) }
		build.substr_types = unsafe { &build.trivial_types[0] }
		build.substr_offsets = unsafe { &build.trivial_offsets[0] }
		build.substr_count = Size(1)
		build.substr_alloc = Size(0)
		build.trivial_types[0] = TextType.normal
		build.trivial_offsets[0] = Offset(0)
		build.trivial_offsets[1] = raw_size
		off = raw_size
	} else {
		build.text = &Char(C.malloc(raw_size * sizeof(Char)))
		if uint(build.text) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		raw_off = Offset(0)
		off = Offset(0)
		for raw_off < raw_size {
			if i32(raw_text[raw_off]) == i8(`\0`) {
				for {
					ret = md_build_attr_append_substr(ctx, build, TextType(TextType.nullchar), off)
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				C.memcpy(voidptr(build.text + off), voidptr(raw_text + raw_off), sizeof(Char))
				off++
				raw_off++
				continue
			}
			if i32(raw_text[raw_off]) == i8(`&`) {
				ent_end := Offset(0)
				if md_is_entity_str(ctx, raw_text, raw_off, raw_size, &ent_end) {
					for {
						ret = md_build_attr_append_substr(ctx, build, TextType(TextType.entity), off)
						if ret != 0 {
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					C.memcpy(voidptr(build.text + off), voidptr(raw_text + raw_off), (ent_end - raw_off) * sizeof(Char))
					off += ent_end - raw_off
					raw_off = ent_end
					continue
				}
			}
			if build.substr_count == Size(0) || i32(build.substr_types[build.substr_count - Size(1)]) != TextType.normal {
				for {
					ret = md_build_attr_append_substr(ctx, build, TextType(TextType.normal), off)
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
			}
			mut __c2v_condition_6 := false
			mut __c2v_condition_7 := false
			__c2v_condition_7 = !(flags & u32(1))
			if __c2v_condition_7 {
				__c2v_condition_7 = i32(raw_text[raw_off]) == i8(`\\`)
			}
			if __c2v_condition_7 {
				__c2v_condition_7 = raw_off + Offset(1) < raw_size
			}
			if __c2v_condition_7 {
				__c2v_condition_7 = (((u32(33) <= u32(raw_text[raw_off + Offset(1)]) && u32(raw_text[raw_off + Offset(1)]) <= u32(47)) || (u32(58) <= u32(raw_text[raw_off + Offset(1)]) && u32(raw_text[raw_off + Offset(1)]) <= u32(64)) || (u32(91) <= u32(raw_text[raw_off + Offset(1)]) && u32(raw_text[raw_off + Offset(1)]) <= u32(96)) || (u32(123) <= u32(raw_text[raw_off + Offset(1)]) && u32(raw_text[raw_off + Offset(1)]) <= u32(126))) || (i32(raw_text[raw_off + Offset(1)]) == i8(`\r`) || i32(raw_text[raw_off + Offset(1)]) == i8(`\n`)))
			}
			__c2v_condition_6 = __c2v_condition_7
			if __c2v_condition_6 {
				raw_off++
			}
			build.text[off++] = raw_text[raw_off++]
		}
		build.substr_offsets[build.substr_count] = off
	}
	attr.text = build.text
	attr.size = off
	attr.substr_offsets = build.substr_offsets
	attr.substr_types = build.substr_types
	return 0
	abort:
	md_free_attribute(ctx, build)
	return -1
}

fn md_fnv1a(base u32, data voidptr, n uint) u32 {
	buf := &u8(data)
	hash := base
	i := uint(0)
	for i = uint(0); i < n; i++ {
		hash ^= u32(buf[i])
		hash *= 16777619
	}
	return hash
}

fn md_label_hash(label &Char, size Size) u32 {
	hash := u32(2166136261)
	off := Offset(0)
	codepoint := u32(0)
	is_whitespace := i32(0)
	off = md_skip_unicode_whitespace(label, Offset(0), size)
	for off < size {
		char_size := Size(0)
		codepoint = md_decode_unicode(label, off, size, &char_size)
		is_whitespace = md_is_unicode_whitespace__(codepoint) || (i32(label[off]) == i8(`\r`) || i32(label[off]) == i8(`\n`))
		if is_whitespace {
			codepoint = u32(` `)
			hash = md_fnv1a(hash, voidptr(&codepoint), sizeof(u32))
			off = md_skip_unicode_whitespace(label, off, size)
		} else {
			fold_info := MD_UNICODE_FOLD_INFO{}
			md_get_unicode_fold_info(codepoint, &fold_info)
			hash = md_fnv1a(hash, fold_info.codepoints, fold_info.n_codepoints * sizeof(u32))
			off += char_size
		}
	}
	return hash
}

fn md_label_cmp_load_fold_info(label &Char, off Offset, size Size, fold_info &MD_UNICODE_FOLD_INFO) Offset {
	codepoint := u32(0)
	char_size := Size(0)
	if off >= size {
		unsafe {
			goto whitespace
		}
	}
	codepoint = md_decode_unicode(label, off, size, &char_size)
	off += char_size
	if md_is_unicode_whitespace__(codepoint) {
		unsafe {
			goto whitespace
		}
	}
	md_get_unicode_fold_info(codepoint, fold_info)
	return off
	whitespace:
	fold_info.codepoints[0] = u32(` `)
	fold_info.n_codepoints = u32(1)
	return md_skip_unicode_whitespace(label, off, size)
}

fn md_label_cmp(a_label &Char, a_size Size, b_label &Char, b_size Size) i32 {
	a_off := Offset(0)
	b_off := Offset(0)
	a_fi := MD_UNICODE_FOLD_INFO{}

	b_fi := MD_UNICODE_FOLD_INFO{}

	a_fi_off := Offset(0)
	b_fi_off := Offset(0)
	cmp := i32(0)
	a_off = md_skip_unicode_whitespace(a_label, Offset(0), a_size)
	b_off = md_skip_unicode_whitespace(b_label, Offset(0), b_size)
	for a_off < a_size || a_fi_off < a_fi.n_codepoints || b_off < b_size || b_fi_off < b_fi.n_codepoints {
		if a_fi_off >= a_fi.n_codepoints {
			a_fi_off = Offset(0)
			a_off = md_label_cmp_load_fold_info(a_label, a_off, a_size, &a_fi)
		}
		if b_fi_off >= b_fi.n_codepoints {
			b_fi_off = Offset(0)
			b_off = md_label_cmp_load_fold_info(b_label, b_off, b_size, &b_fi)
		}
		cmp = i32(b_fi.codepoints[b_fi_off] - a_fi.codepoints[a_fi_off])
		if cmp != 0 {
			return cmp
		}
		a_fi_off++
		b_fi_off++
	}
	return 0
}

type MD_LABEL_HASH_LIST = MD_LABEL_HASH_LIST_tag

struct MD_LABEL_HASH_LIST_tag {
	n_entries     u32
	alloc_entries u32
	entries       [1]&MD_LABEL_HASH_ENTRY
}

fn md_label_hash_entry_cmp(a voidptr, b voidptr) i32 {
	a_entry := (unsafe { *&&MD_LABEL_HASH_ENTRY(a) })
	b_entry := (unsafe { *&&MD_LABEL_HASH_ENTRY(b) })
	if a_entry.hash < b_entry.hash {
		return -1
	} else if a_entry.hash > b_entry.hash {
		return 1
	} else {
		return md_label_cmp(a_entry.label, a_entry.label_size, b_entry.label, b_entry.label_size)
	}
}

fn md_label_hash_entry_cmp_for_sort(a voidptr, b voidptr) i32 {
	cmp := i32(0)
	cmp = md_label_hash_entry_cmp(voidptr(a), voidptr(b))
	if cmp == 0 {
		a_entry := (unsafe { *&&MD_LABEL_HASH_ENTRY(a) })
		b_entry := (unsafe { *&&MD_LABEL_HASH_ENTRY(b) })
		if uint(a_entry) < uint(b_entry) {
			cmp = -1
		} else if uint(a_entry) > uint(b_entry) {
			cmp = 1
		}
	}
	return cmp
}

fn md_is_complex_label_bucket(table &MD_LABEL_HASH_TABLE, bucket voidptr) i32 {
	if uint(bucket) == uint((voidptr(0))) {
		return 0
	}
	return i32(uint(&MD_LABEL_HASH_ENTRY(bucket)) < uint(&MD_LABEL_HASH_ENTRY(table.c2v_anonymous_5198.defs)) || uint(&MD_LABEL_HASH_ENTRY(bucket)) >= uint(&MD_LABEL_HASH_ENTRY(voidptr((&i8(table.c2v_anonymous_5198.defs) + (table.n_defs * table.def_size))))))
}

fn md_build_label_hashtable(ctx &MD_CTX, table &MD_LABEL_HASH_TABLE) i32 {
	i := u32(0)
	j := u32(0)

	if table.n_defs == u32(0) {
		return 0
	}
	table.n_buckets = (table.n_defs * u32(5)) / u32(4)
	table.buckets = C.malloc(table.n_buckets * sizeof(voidptr))
	if uint(table.buckets) == uint((voidptr(0))) {
		for {
			if ctx.parser.debug_log != (voidptr(0)) {
				ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
			}
			// while()
			break
		}
		unsafe {
			goto abort
		}
	}
	C.memset(voidptr(table.buckets), 0, table.n_buckets * sizeof(voidptr))
	for i = u32(0); i < table.n_defs; i++ {
		entry := &MD_LABEL_HASH_ENTRY(voidptr((&i8(table.c2v_anonymous_5198.defs) + (i * table.def_size))))
		p_bucket := unsafe { table.buckets + (entry.hash % table.n_buckets) }
		list := &MD_LABEL_HASH_LIST(0)
		if uint((unsafe { *p_bucket })) == uint((voidptr(0))) {
			unsafe { *p_bucket = entry }
			continue
		}
		if !md_is_complex_label_bucket(table, voidptr((unsafe { *p_bucket }))) {
			old_entry := &MD_LABEL_HASH_ENTRY((unsafe { *p_bucket }))
			if md_label_cmp(entry.label, entry.label_size, old_entry.label, old_entry.label_size) == 0 {
				continue
			}
			list = &MD_LABEL_HASH_LIST(C.malloc(sizeof(MD_LABEL_HASH_LIST) + 2 * sizeof(voidptr)))
			if uint(list) == uint((voidptr(0))) {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			(&list.entries[0])[0] = old_entry
			(&list.entries[0])[1] = entry
			list.n_entries = u32(2)
			list.alloc_entries = u32(2)
			unsafe { *p_bucket = list }
			continue
		}
		list = unsafe { *p_bucket }
		if list.n_entries >= list.alloc_entries {
			alloc_entries := uint(list.alloc_entries + list.alloc_entries / u32(2))
			list_tmp := &MD_LABEL_HASH_LIST(C.realloc(voidptr(list), sizeof(MD_LABEL_HASH_LIST) + alloc_entries * sizeof(voidptr)))
			if uint(list_tmp) == uint((voidptr(0))) {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			list = list_tmp
			list.alloc_entries = u32(alloc_entries)
			table.buckets[entry.hash % table.n_buckets] = list
		}
		(&list.entries[0])[list.n_entries] = entry
		list.n_entries++
	}
	for i = u32(0); i < table.n_buckets; i++ {
		bucket := table.buckets[i]
		list := &MD_LABEL_HASH_LIST(0)
		if uint(bucket) == uint((voidptr(0))) {
			continue
		}
		if !md_is_complex_label_bucket(table, voidptr(bucket)) {
			continue
		}
		list = &MD_LABEL_HASH_LIST(bucket)
		C.qsort(list.entries, uint(list.n_entries), sizeof(voidptr), md_label_hash_entry_cmp_for_sort)
		for j = u32(1); j < list.n_entries; j++ {
			if md_label_hash_entry_cmp(voidptr(unsafe { &list.entries[0] + (j - u32(1)) }), voidptr(unsafe { &list.entries[0] + j })) == 0 {
				(&list.entries[0])[j] = (&list.entries[0])[j - u32(1)]
			}
		}
	}
	return 0
	abort:
	return -1
}

fn md_free_label_hashtable(ctx &MD_CTX, table &MD_LABEL_HASH_TABLE) {
	if uint(table.buckets) != uint((voidptr(0))) {
		i := u32(0)
		for i = u32(0); i < table.n_buckets; i++ {
			bucket := table.buckets[i]
			if md_is_complex_label_bucket(table, voidptr(bucket)) {
				C.free(voidptr(bucket))
			}
		}
		C.free(voidptr(table.buckets))
	}
}

fn md_lookup_label_hashtable(ctx &MD_CTX, table &MD_LABEL_HASH_TABLE, label &Char, label_size Size) &MD_LABEL_HASH_ENTRY {
	hash := u32(0)
	bucket := voidptr(0)

	if table.n_buckets == u32(0) {
		return unsafe { nil }
	}
	hash = md_label_hash(label, label_size)
	bucket = table.buckets[hash % table.n_buckets]
	if uint(bucket) == uint((voidptr(0))) {
		return unsafe { nil }
	} else if !md_is_complex_label_bucket(table, voidptr(bucket)) {
		entry := &MD_LABEL_HASH_ENTRY(bucket)
		if entry.hash == hash && md_label_cmp(entry.label, entry.label_size, label, label_size) == 0 {
			return entry
		} else {
			return unsafe { nil }
		}
	} else {
		list := &MD_LABEL_HASH_LIST(bucket)
		key_buf := MD_LABEL_HASH_ENTRY{}
		key := &key_buf
		ret := &&MD_LABEL_HASH_ENTRY(0)
		key_buf.label = &Char(label)
		key_buf.label_size = label_size
		key_buf.hash = hash
		ret = &&MD_LABEL_HASH_ENTRY(C.bsearch(voidptr(&&MD_LABEL_HASH_ENTRY(c2v_address_of(&key))), list.entries, uint(list.n_entries), sizeof(voidptr), md_label_hash_entry_cmp))
		if uint(ret) != uint((voidptr(0))) {
			return ret
		} else {
			return unsafe { nil }
		}
	}
}

fn md_add_label_def(ctx &MD_CTX, table &MD_LABEL_HASH_TABLE, label &Char, label_size Size) voidptr {
	entry := &MD_LABEL_HASH_ENTRY(0)
	if table.n_defs >= table.alloc_defs {
		new_alloc_defs := uint(0)
		new_defs := voidptr(0)
		new_alloc_defs = uint((if table.alloc_defs > u32(0) {
			table.alloc_defs + table.alloc_defs / u32(2)
		} else {
			u32(8)
		}))
		new_defs = C.realloc(voidptr(table.c2v_anonymous_5198.defs), new_alloc_defs * uint(table.def_size))
		if uint(new_defs) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			return unsafe { nil }
		}
		table.c2v_anonymous_5198.defs = new_defs
		table.alloc_defs = u32(new_alloc_defs)
	}
	entry = &MD_LABEL_HASH_ENTRY(voidptr((&i8(table.c2v_anonymous_5198.defs) + (table.n_defs * table.def_size))))
	C.memset(voidptr(entry), 0, table.def_size)
	entry.label = label
	entry.label_size = label_size
	entry.hash = md_label_hash(label, label_size)
	table.n_defs++
	return entry
}

struct MD_REF_DEF_tag {
	entry            MD_LABEL_HASH_ENTRY
	title            &Char
	title_size       Size
	dest_beg         Offset
	dest_end         Offset
	label_needs_free u8
	title_needs_free u8
}

fn md_build_ref_def_hashtable(ctx &MD_CTX) i32 {
	return md_build_label_hashtable(ctx, &ctx.ref_def_hashtable)
}

fn md_lookup_ref_def(ctx &MD_CTX, label &Char, label_size Size) &MD_REF_DEF {
	return &MD_REF_DEF(voidptr(md_lookup_label_hashtable(ctx, &ctx.ref_def_hashtable, label, label_size)))
}

struct MD_FOOTNOTE_DEF_tag {
	entry           MD_LABEL_HASH_ENTRY
	index           u32
	ref_count       u32
	content_lines   &MD_LINE
	n_content_lines Size
}

fn md_is_footnote_label(ctx &MD_CTX, beg Offset, p_end &Offset) i32 {
	end := beg
	for end < ctx.size && end - beg <= Offset(75) && !((i32(ctx.text[end]) == i8(` `) || i32(ctx.text[end]) == i8(`\t`)) || (i32(ctx.text[end]) == i8(`\v`) || i32(ctx.text[end]) == i8(`\f`))) && !(i32(ctx.text[end]) == i8(`[`) || i32(ctx.text[end]) == i8(`]`)) {
		end++
	}
	if end - beg > Offset(0) && end < ctx.size && i32(ctx.text[end]) == i8(`]`) {
		if uint(p_end) != uint((voidptr(0))) {
			unsafe { *p_end = end }
		}
		return 1
	} else {
		return 0
	}
}

fn md_is_footnote_definition(ctx &MD_CTX, lines &MD_LINE, n_lines Size) i32 {
	off := Offset(0)
	label_beg := Offset(0)
	label_end := Offset(0)

	mut content_lines := unsafe { &MD_LINE(nil) }
	def := &MD_FOOTNOTE_DEF(0)
	n := Size(0)
	n_content_lines := Size(0)
	ret := i32(0)
	for {
		md_assume((n_lines >= Size(1)))
		// while()
		break
	}
	off = lines[0].beg
	for {
		md_assume((i32(ctx.text[off]) == i8(`[`) && i32(ctx.text[(off + Offset(1))]) == i8(`^`)))
		// while()
		break
	}
	off += Offset(2)
	label_beg = off
	if !md_is_footnote_label(ctx, label_beg, &off) {
		return 0
	}
	label_end = off
	if off >= lines[0].end || i32(ctx.text[off]) != i8(`]`) {
		return 0
	}
	off++
	if off >= lines[0].end || i32(ctx.text[off]) != i8(`:`) {
		return 0
	}
	off++
	for off < lines[0].end && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
		off++
	}
	n = Size(1)
	for n < n_lines {
		def_off := lines[n].beg
		if def_off + Offset(3) < lines[n].end && i32(ctx.text[def_off]) == i8(`[`) && i32(ctx.text[(def_off + Offset(1))]) == i8(`^`) {
			tmp := def_off + Offset(2)
			for tmp < lines[n].end && i32(ctx.text[tmp]) != i8(`]`) && !((i32(ctx.text[tmp]) == i8(` `) || i32(ctx.text[tmp]) == i8(`\t`)) || (i32(ctx.text[tmp]) == i8(`\v`) || i32(ctx.text[tmp]) == i8(`\f`))) && i32(ctx.text[tmp]) != i8(`[`) {
				tmp++
			}
			if tmp > def_off + Offset(2) && tmp + Offset(1) < lines[n].end && i32(ctx.text[tmp]) == i8(`]`) && i32(ctx.text[(tmp + Offset(1))]) == i8(`:`) {
				break
			}
		}
		n++
	}
	n_content_lines = if (off >= lines[0].end && n > Size(1)) { n - Size(1) } else { n }
	content_lines = &MD_LINE(C.malloc(n_content_lines * sizeof(MD_LINE)))
	if uint(content_lines) == uint((voidptr(0))) {
		for {
			if ctx.parser.debug_log != (voidptr(0)) {
				ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
			}
			// while()
			break
		}
		ret = -1
		unsafe {
			goto abort
		}
	}
	if n_content_lines < n {
		C.memcpy(voidptr(content_lines), voidptr(lines + 1), n_content_lines * sizeof(MD_LINE))
	} else {
		content_lines[0].beg = off
		content_lines[0].end = lines[0].end
		if n > Size(1) {
			C.memcpy(voidptr(content_lines + 1), voidptr(lines + 1), (n - Size(1)) * sizeof(MD_LINE))
		}
	}
	def = &MD_FOOTNOTE_DEF(md_add_label_def(ctx, &ctx.footnote_hashtable, &Char((ctx.text + label_beg)), label_end - label_beg))
	if uint(def) == uint((voidptr(0))) {
		ret = -1
		unsafe {
			goto abort
		}
	}
	def.content_lines = content_lines
	def.n_content_lines = n_content_lines
	return i32(n)
	abort:
	C.free(voidptr(content_lines))
	return ret
}

fn md_lookup_footnote_def(ctx &MD_CTX, label &Char, label_size Size) &MD_FOOTNOTE_DEF {
	return &MD_FOOTNOTE_DEF(voidptr(md_lookup_label_hashtable(ctx, &ctx.footnote_hashtable, label, label_size)))
}

fn md_build_footnote_def_hashtable(ctx &MD_CTX) i32 {
	return md_build_label_hashtable(ctx, &ctx.footnote_hashtable)
}

fn md_free_footnote_defs(ctx &MD_CTX) {
	i := u32(0)
	md_free_label_hashtable(ctx, &ctx.footnote_hashtable)
	for i = u32(0); i < ctx.footnote_hashtable.n_defs; i++ {
		C.free(voidptr(ctx.footnote_hashtable.c2v_anonymous_5198.footnote_defs[i].content_lines))
	}
	C.free(voidptr(ctx.footnote_hashtable.c2v_anonymous_5198.footnote_defs))
}

type MD_LINK_ATTR = MD_LINK_ATTR_tag

struct MD_LINK_ATTR_tag {
	dest_beg         Offset
	dest_end         Offset
	title            &Char
	title_size       Size
	title_needs_free i32
}

fn md_is_link_label(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, p_end &Offset, p_beg_line_index &Size, p_end_line_index &Size, p_contents_beg &Offset, p_contents_end &Offset) i32 {
	off := beg
	contents_beg := Offset(0)
	contents_end := Offset(0)
	line_index := Size(0)
	len := i32(0)
	unsafe { *p_beg_line_index = Size(0) }
	if i32(ctx.text[off]) != i8(`[`) {
		return 0
	}
	off++
	for {
		line_end := lines[line_index].end
		for off < line_end {
			mut __c2v_condition_8 := false
			mut __c2v_condition_9 := false
			__c2v_condition_9 = i32(ctx.text[off]) == i8(`\\`)
			if __c2v_condition_9 {
				__c2v_condition_9 = off + Offset(1) < ctx.size
			}
			if __c2v_condition_9 {
				__c2v_condition_9 = (((u32(33) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(47)) || (u32(58) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(64)) || (u32(91) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(96)) || (u32(123) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(126))) || (i32(ctx.text[(off + Offset(1))]) == i8(`\r`) || i32(ctx.text[(off + Offset(1))]) == i8(`\n`)))
			}
			__c2v_condition_8 = __c2v_condition_9
			if __c2v_condition_8 {
				if contents_end == Offset(0) {
					contents_beg = off
					unsafe { *p_beg_line_index = line_index }
				}
				contents_end = off + Offset(2)
				off += Offset(2)
			} else if i32(ctx.text[off]) == i8(`[`) {
				return 0
			} else if i32(ctx.text[off]) == i8(`]`) {
				if contents_beg < contents_end {
					unsafe { *p_contents_beg = contents_beg }
					unsafe { *p_contents_end = contents_end }
					unsafe { *p_end = off + Offset(1) }
					unsafe { *p_end_line_index = line_index }
					return 1
				} else {
					return 0
				}
			} else {
				codepoint := u32(0)
				char_size := Size(0)
				codepoint = md_decode_unicode(ctx.text, off, ctx.size, &char_size)
				if !md_is_unicode_whitespace__(codepoint) {
					if contents_end == Offset(0) {
						contents_beg = off
						unsafe { *p_beg_line_index = line_index }
					}
					contents_end = off + char_size
				}
				off += char_size
			}
			len++
			if len > 999 {
				return 0
			}
		}
		line_index++
		len++
		if line_index < n_lines {
			off = lines[line_index].beg
		} else {
			break
		}
	}
	return 0
}

@[c:'md_is_link_destination_A']
fn md_is_link_destination_a(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset, p_contents_beg &Offset, p_contents_end &Offset) i32 {
	off := beg
	if off >= max_end || i32(ctx.text[off]) != i8(`<`) {
		return 0
	}
	off++
	for off < max_end {
		mut __c2v_condition_10 := false
		mut __c2v_condition_11 := false
		__c2v_condition_11 = i32(ctx.text[off]) == i8(`\\`)
		if __c2v_condition_11 {
			__c2v_condition_11 = off + Offset(1) < max_end
		}
		if __c2v_condition_11 {
			__c2v_condition_11 = ((u32(33) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(47)) || (u32(58) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(64)) || (u32(91) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(96)) || (u32(123) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(126)))
		}
		__c2v_condition_10 = __c2v_condition_11
		if __c2v_condition_10 {
			off += Offset(2)
			continue
		}
		if (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) || i32(ctx.text[off]) == i8(`<`) {
			return 0
		}
		if i32(ctx.text[off]) == i8(`>`) {
			unsafe { *p_contents_beg = beg + Offset(1) }
			unsafe { *p_contents_end = off }
			unsafe { *p_end = off + Offset(1) }
			return 1
		}
		off++
	}
	return 0
}

@[c:'md_is_link_destination_B']
fn md_is_link_destination_b(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset, p_contents_beg &Offset, p_contents_end &Offset) i32 {
	off := beg
	parenthesis_level := i32(0)
	for off < max_end {
		mut __c2v_condition_12 := false
		mut __c2v_condition_13 := false
		__c2v_condition_13 = i32(ctx.text[off]) == i8(`\\`)
		if __c2v_condition_13 {
			__c2v_condition_13 = off + Offset(1) < max_end
		}
		if __c2v_condition_13 {
			__c2v_condition_13 = ((u32(33) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(47)) || (u32(58) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(64)) || (u32(91) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(96)) || (u32(123) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(126)))
		}
		__c2v_condition_12 = __c2v_condition_13
		if __c2v_condition_12 {
			off += Offset(2)
			continue
		}
		if (u32(ctx.text[off]) <= u32(32) || u32(ctx.text[off]) == u32(127)) {
			break
		}
		if i32(ctx.text[off]) == i8(`(`) {
			parenthesis_level++
			if parenthesis_level > 32 {
				return 0
			}
		} else if i32(ctx.text[off]) == i8(`)`) {
			if parenthesis_level == 0 {
				break
			}
			parenthesis_level--
		}
		off++
	}
	if parenthesis_level != 0 || off == beg {
		return 0
	}
	unsafe { *p_contents_beg = beg }
	unsafe { *p_contents_end = off }
	unsafe { *p_end = off }
	return 1
}

fn md_is_link_destination(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset, p_contents_beg &Offset, p_contents_end &Offset) i32 {
	if i32(ctx.text[beg]) == i8(`<`) {
		return md_is_link_destination_a(ctx, beg, max_end, p_end, p_contents_beg, p_contents_end)
	} else {
		return md_is_link_destination_b(ctx, beg, max_end, p_end, p_contents_beg, p_contents_end)
	}
}

fn md_is_link_title(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, p_end &Offset, p_beg_line_index &Size, p_end_line_index &Size, p_contents_beg &Offset, p_contents_end &Offset) i32 {
	off := beg
	closer_char := Char(0)
	line_index := Size(0)
	for off < lines[line_index].end && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
		off++
	}
	if off >= lines[line_index].end {
		line_index++
		if line_index >= n_lines {
			return 0
		}
		off = lines[line_index].beg
	}
	if off == beg {
		return 0
	}
	unsafe { *p_beg_line_index = line_index }
	match ctx.text[off] {
		`\"` { // case comp body kind=BinaryOperator is_enum=true
			closer_char = Char(`\"`)
		}
		`\'` { // case comp body kind=BinaryOperator is_enum=true
			closer_char = Char(`\'`)
		}
		`(` { // case comp body kind=BinaryOperator is_enum=true
			closer_char = Char(`)`)
		}
		else {
			return 0
		}
	}

	off++
	unsafe { *p_contents_beg = off }
	for line_index < n_lines {
		line_end := lines[line_index].end
		for off < line_end {
			mut __c2v_condition_14 := false
			mut __c2v_condition_15 := false
			__c2v_condition_15 = i32(ctx.text[off]) == i8(`\\`)
			if __c2v_condition_15 {
				__c2v_condition_15 = off + Offset(1) < ctx.size
			}
			if __c2v_condition_15 {
				__c2v_condition_15 = (((u32(33) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(47)) || (u32(58) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(64)) || (u32(91) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(96)) || (u32(123) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(126))) || (i32(ctx.text[(off + Offset(1))]) == i8(`\r`) || i32(ctx.text[(off + Offset(1))]) == i8(`\n`)))
			}
			__c2v_condition_14 = __c2v_condition_15
			if __c2v_condition_14 {
				off++
			} else if i32(ctx.text[off]) == i32(closer_char) {
				unsafe { *p_contents_end = off }
				unsafe { *p_end = off + Offset(1) }
				unsafe { *p_end_line_index = line_index }
				return 1
			} else if i32(closer_char) == i8(`)`) && i32(ctx.text[off]) == i8(`(`) {
				return 0
			}
			off++
		}
		line_index++
	}
	return 0
}

fn md_is_link_reference_definition(ctx &MD_CTX, lines &MD_LINE, n_lines Size) i32 {
	label_contents_beg := Offset(0)
	label_contents_end := Offset(0)
	label_contents_line_index := Size(0)
	label_is_multiline := i32(0)
	dest_contents_beg := Offset(0)
	dest_contents_end := Offset(0)
	title_contents_beg := Offset(0)
	title_contents_end := Offset(0)
	title_contents_line_index := Size(0)
	title_is_multiline := i32(0)
	off := Offset(0)
	line_index := Size(0)
	tmp_line_index := Size(0)
	def := unsafe { &MD_REF_DEF(nil) }
	ret := i32(0)
	if !md_is_link_label(ctx, lines, n_lines, lines[0].beg, &off, &label_contents_line_index, &line_index, &label_contents_beg, &label_contents_end) {
		return 0
	}
	label_is_multiline = (label_contents_line_index != line_index)
	if off >= lines[line_index].end || i32(ctx.text[off]) != i8(`:`) {
		return 0
	}
	off++
	for off < lines[line_index].end && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
		off++
	}
	if off >= lines[line_index].end {
		line_index++
		if line_index >= n_lines {
			return 0
		}
		off = lines[line_index].beg
	}
	if !md_is_link_destination(ctx, off, lines[line_index].end, &off, &dest_contents_beg, &dest_contents_end) {
		return 0
	}
	mut __c2v_condition_16 := false
	mut __c2v_condition_17 := false
	__c2v_condition_17 = md_is_link_title(ctx, lines + line_index, n_lines - line_index, off, &off, &title_contents_line_index, &tmp_line_index, &title_contents_beg, &title_contents_end)
	if __c2v_condition_17 {
		__c2v_condition_17 = off >= lines[line_index + tmp_line_index].end
	}
	__c2v_condition_16 = __c2v_condition_17
	if __c2v_condition_16 {
		title_is_multiline = (tmp_line_index != title_contents_line_index)
		title_contents_line_index += line_index
		line_index += tmp_line_index
	} else {
		title_is_multiline = 0
		title_contents_beg = off
		title_contents_end = off
		title_contents_line_index = Size(0)
	}
	if off < lines[line_index].end {
		return 0
	}
	if label_is_multiline {
		label := &Char(0)
		label_size := Size(0)
		for {
			ret = md_merge_lines_alloc(ctx, label_contents_beg, label_contents_end, lines + label_contents_line_index, n_lines - label_contents_line_index, Char(` `), &&Char(&&Char(c2v_address_of(&label))), &label_size)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		def = &MD_REF_DEF(md_add_label_def(ctx, &ctx.ref_def_hashtable, label, label_size))
		if uint(def) == uint((voidptr(0))) {
			ret = -1
			C.free(voidptr(label))
			unsafe {
				goto abort
			}
		}
		def.label_needs_free = u8(1)
	} else {
		def = &MD_REF_DEF(md_add_label_def(ctx, &ctx.ref_def_hashtable, (ctx.text + label_contents_beg), label_contents_end - label_contents_beg))
		if uint(def) == uint((voidptr(0))) {
			ret = -1
			unsafe {
				goto abort
			}
		}
	}
	if title_is_multiline {
		for {
			ret = md_merge_lines_alloc(ctx, title_contents_beg, title_contents_end, lines + title_contents_line_index, n_lines - title_contents_line_index, Char(`\n`), &&Char(&def.title), &def.title_size)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		def.title_needs_free = u8(1)
	} else {
		def.title = &Char((ctx.text + title_contents_beg))
		def.title_size = title_contents_end - title_contents_beg
	}
	def.dest_beg = dest_contents_beg
	def.dest_end = dest_contents_end
	return i32(line_index + Size(1))
	abort:
	return ret
}

fn md_is_link_reference(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, end Offset, attr &MD_LINK_ATTR) i32 {
	def := &MD_REF_DEF(0)
	beg_line := &MD_LINE(0)
	is_multiline := i32(0)
	label := &Char(0)
	label_size := Size(0)
	ret := i32(0)
	for {
		md_assume((i32(ctx.text[beg]) == i8(`[`) || i32(ctx.text[beg]) == i8(`!`)))
		// while()
		break
	}
	for {
		md_assume((i32(ctx.text[(end - Offset(1))]) == i8(`]`)))
		// while()
		break
	}
	if ctx.max_ref_def_output == Size(0) {
		return 0
	}
	beg += Offset((if i32(ctx.text[beg]) == i8(`!`) { 2 } else { 1 }))
	end--
	beg_line = md_lookup_line(beg, lines, n_lines, (voidptr(0)))
	is_multiline = (end > beg_line.end)
	if is_multiline {
		for {
			ret = md_merge_lines_alloc(ctx, beg, end, beg_line, Size(i32((n_lines - (i64((int(beg_line) - int(lines)) / int(sizeof(MD_LINE_tag))))))), Char(` `), &&Char(&&Char(c2v_address_of(&label))), &label_size)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	} else {
		label = &Char((ctx.text + beg))
		label_size = end - beg
	}
	def = md_lookup_ref_def(ctx, label, label_size)
	if uint(def) != uint((voidptr(0))) {
		attr.dest_beg = def.dest_beg
		attr.dest_end = def.dest_end
		attr.title = def.title
		attr.title_size = def.title_size
		attr.title_needs_free = 0
	}
	if is_multiline {
		C.free(voidptr(label))
	}
	if uint(def) != uint((voidptr(0))) {
		output_size_estimation := def.entry.label_size + def.title_size + def.dest_end - def.dest_beg
		if output_size_estimation < ctx.max_ref_def_output {
			ctx.max_ref_def_output -= output_size_estimation
			ret = 1
		} else {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Too many link reference definition instantiations.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			ctx.max_ref_def_output = Size(0)
		}
	}
	abort:
	return ret
}

fn md_is_inline_link_spec(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, p_end &Offset, attr &MD_LINK_ATTR) i32 {
	line_index := Size(0)
	tmp_line_index := Size(0)
	title_contents_beg := Offset(0)
	title_contents_end := Offset(0)
	title_contents_line_index := Size(0)
	title_is_multiline := i32(0)
	off := beg
	ret := i32(0)
	md_lookup_line(off, lines, n_lines, &line_index)
	for {
		md_assume((i32(ctx.text[off]) == i8(`(`)))
		// while()
		break
	}
	off++
	for off < lines[line_index].end && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
		off++
	}
	if off >= lines[line_index].end && (off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`))) {
		line_index++
		if line_index >= n_lines {
			return 0
		}
		off = lines[line_index].beg
	}
	if off < ctx.size && i32(ctx.text[off]) == i8(`)`) {
		attr.dest_beg = off
		attr.dest_end = off
		attr.title = unsafe { nil }
		attr.title_size = Size(0)
		attr.title_needs_free = 0
		off++
		unsafe { *p_end = off }
		return 1
	}
	if !md_is_link_destination(ctx, off, lines[line_index].end, &off, &attr.dest_beg, &attr.dest_end) {
		return 0
	}
	if md_is_link_title(ctx, lines + line_index, n_lines - line_index, off, &off, &title_contents_line_index, &tmp_line_index, &title_contents_beg, &title_contents_end) {
		title_is_multiline = (tmp_line_index != title_contents_line_index)
		title_contents_line_index += line_index
		line_index += tmp_line_index
	} else {
		title_is_multiline = 0
		title_contents_beg = off
		title_contents_end = off
		title_contents_line_index = Size(0)
	}
	for off < lines[line_index].end && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
		off++
	}
	if off >= lines[line_index].end {
		line_index++
		if line_index >= n_lines {
			return 0
		}
		off = lines[line_index].beg
	}
	if i32(ctx.text[off]) != i8(`)`) {
		unsafe {
			goto abort
		}
	}
	off++
	if title_contents_beg >= title_contents_end {
		attr.title = unsafe { nil }
		attr.title_size = Size(0)
		attr.title_needs_free = 0
	} else if !title_is_multiline {
		attr.title = &Char((ctx.text + title_contents_beg))
		attr.title_size = title_contents_end - title_contents_beg
		attr.title_needs_free = 0
	} else {
		for {
			ret = md_merge_lines_alloc(ctx, title_contents_beg, title_contents_end, lines + title_contents_line_index, n_lines - title_contents_line_index, Char(`\n`), &&Char(&attr.title), &attr.title_size)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		attr.title_needs_free = 1
	}
	unsafe { *p_end = off }
	ret = 1
	abort:
	return ret
}

fn md_free_ref_defs(ctx &MD_CTX) {
	i := u32(0)
	md_free_label_hashtable(ctx, &ctx.ref_def_hashtable)
	for i = u32(0); i < ctx.ref_def_hashtable.n_defs; i++ {
		def := unsafe { ctx.ref_def_hashtable.c2v_anonymous_5198.ref_defs + i }
		if def.label_needs_free {
			C.free(voidptr(def.entry.label))
		}
		if def.title_needs_free {
			C.free(voidptr(def.title))
		}
	}
	C.free(voidptr(ctx.ref_def_hashtable.c2v_anonymous_5198.ref_defs))
}

struct MarkOffsets {
	beg Offset
	end Offset
}

union MD_MARK_tag_c2v_anonymous_105093 {
	offsets MarkOffsets
	pointer voidptr
}

struct MD_MARK_tag {
	c2v_anonymous_105093 MD_MARK_tag_c2v_anonymous_105093
	prev                 i32
	next                 i32
	ch                   Char
	flags                u8
}

fn md_emph_stack(ctx &MD_CTX, ch Char, flags u32) &MD_MARKSTACK {
	stack := &MD_MARKSTACK(0)
	match ch {
		`*` { // case comp body kind=BinaryOperator is_enum=true
			stack = unsafe { &ctx.opener_stacks[0] + 0 }
		}
		`_` { // case comp body kind=BinaryOperator is_enum=true
			stack = unsafe { &ctx.opener_stacks[0] + 6 }
		}
		else {
			for {
				md_assume((0 != 0))
				// while()
				break
			}
		}
	}

	if flags & u32(32) {
		c2v_pointer_prefix(voidptr(&stack), stack, int(3))
	}
	match (flags & u32((64 | 128))) {
		u32(64) { // case comp body kind=CompoundAssignOperator is_enum=false
			c2v_pointer_prefix(voidptr(&stack), stack, int(0))
		}
		u32(128) { // case comp body kind=CompoundAssignOperator is_enum=false
			c2v_pointer_prefix(voidptr(&stack), stack, int(1))
		}
		u32((64 | 128)) { // case comp body kind=CompoundAssignOperator is_enum=false
			c2v_pointer_prefix(voidptr(&stack), stack, int(2))
		}
		else {
			for {
				md_assume((0 != 0))
				// while()
				break
			}
		}
	}

	return stack
}

fn md_opener_stack(ctx &MD_CTX, mark_index i32) &MD_MARKSTACK {
	mark := unsafe { ctx.marks + mark_index }
	match mark.ch {
		`*`, `_` {
			return md_emph_stack(ctx, mark.ch, u32(mark.flags))
		}
		`~` { // case comp body kind=ReturnStmt is_enum=true
			return if (mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(1)) {
				unsafe { &ctx.opener_stacks[0] + 12 }
			} else {
				unsafe { &ctx.opener_stacks[0] + 13 }
			}
		}
		`^` { // case comp body kind=ReturnStmt is_enum=true
			return unsafe { &ctx.opener_stacks[0] + 17 }
		}
		`|` { // case comp body kind=ReturnStmt is_enum=true
			return unsafe { &ctx.opener_stacks[0] + 16 }
		}
		`=` { // case comp body kind=ReturnStmt is_enum=true
			return unsafe { &ctx.opener_stacks[0] + 18 }
		}
		`+` { // case comp body kind=ReturnStmt is_enum=true
			return unsafe { &ctx.opener_stacks[0] + 19 }
		}
		else {
			for {
				md_assume((0 != 0))
				// while()
				break
			}
		}
	}
	return unsafe { nil }
}

fn md_add_mark(ctx &MD_CTX) &MD_MARK {
	if ctx.n_marks >= ctx.alloc_marks {
		new_marks := &MD_MARK(0)
		ctx.alloc_marks = (if ctx.alloc_marks > 0 {
			ctx.alloc_marks + ctx.alloc_marks / 2
		} else {
			64
		})
		new_marks = C.realloc(voidptr(ctx.marks), ctx.alloc_marks * sizeof(MD_MARK))
		if uint(new_marks) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			return unsafe { nil }
		}
		ctx.marks = new_marks
	}
	return unsafe { ctx.marks + ctx.n_marks++ }
}

fn md_mark_stack_push(ctx &MD_CTX, stack &MD_MARKSTACK, mark_index i32) {
	ctx.marks[mark_index].next = stack.top
	stack.top = mark_index
}

fn md_mark_stack_pop(ctx &MD_CTX, stack &MD_MARKSTACK) i32 {
	top := stack.top
	if top >= 0 {
		stack.top = ctx.marks[top].next
	}
	return top
}

fn md_mark_store_ptr(ctx &MD_CTX, mark_index i32, ptr voidptr) {
	for {
		md_assume((i32(ctx.marks[mark_index].ch) == i8(`D`)))
		// while()
		break
	}
	ctx.marks[mark_index].c2v_anonymous_105093.pointer = ptr
}

fn md_mark_get_ptr(ctx &MD_CTX, mark_index i32) voidptr {
	for {
		md_assume((i32(ctx.marks[mark_index].ch) == i8(`D`)))
		// while()
		break
	}
	return ctx.marks[mark_index].c2v_anonymous_105093.pointer
}

fn md_resolve_range(ctx &MD_CTX, opener_index i32, closer_index i32) {
	opener := unsafe { ctx.marks + opener_index }
	closer := unsafe { ctx.marks + closer_index }
	opener.next = closer_index
	closer.prev = opener_index
	opener.flags |= 4 | 16
	closer.flags |= 8 | 16
}

fn md_pop_openers(ctx &MD_CTX, opener_index i32) {
	i := i32(0)
	for i = 0; i < 20; i++ {
		stack := unsafe { &ctx.opener_stacks[0] + i }
		for stack.top >= opener_index {
			md_mark_stack_pop(ctx, stack)
		}
	}
}

fn md_disable_marks(ctx &MD_CTX, mark_index0 i32, mark_index1 i32) {
	i := i32(0)
	for i = mark_index0; i < mark_index1; i++ {
		mark := unsafe { ctx.marks + i }
		mark.ch = Char(`D`)
		mark.flags = u8(0)
	}
}

fn md_build_mark_char_map(ctx &MD_CTX) {
	C.memset(ctx.mark_char_map, 0, sizeof([256]i8))
	ctx.mark_char_map[`\\`] = i8(1)
	ctx.mark_char_map[`*`] = i8(1)
	ctx.mark_char_map[`_`] = i8(1)
	ctx.mark_char_map[`\``] = i8(1)
	ctx.mark_char_map[`&`] = i8(1)
	ctx.mark_char_map[`;`] = i8(1)
	ctx.mark_char_map[`<`] = i8(1)
	ctx.mark_char_map[`>`] = i8(1)
	ctx.mark_char_map[`[`] = i8(1)
	ctx.mark_char_map[`!`] = i8(1)
	ctx.mark_char_map[`]`] = i8(1)
	ctx.mark_char_map[`\0`] = i8(1)
	if ctx.parser.flags & u32((512 | 262144)) {
		ctx.mark_char_map[`~`] = i8(1)
	}
	if ctx.parser.flags & u32(131072) {
		ctx.mark_char_map[`^`] = i8(1)
	}
	if ctx.parser.flags & u32(4096) {
		ctx.mark_char_map[`$`] = i8(1)
	}
	if ctx.parser.flags & u32(2097152) {
		ctx.mark_char_map[`=`] = i8(1)
	}
	if ctx.parser.flags & u32(8388608) {
		ctx.mark_char_map[`+`] = i8(1)
	}
	if ctx.parser.flags & u32(8) {
		ctx.mark_char_map[`@`] = i8(1)
	}
	if ctx.parser.flags & u32(4) {
		ctx.mark_char_map[`:`] = i8(1)
	}
	if ctx.parser.flags & u32(1024) {
		ctx.mark_char_map[`.`] = i8(1)
	}
	if (ctx.parser.flags & u32(256)) || (ctx.parser.flags & u32(8192)) || (ctx.parser.flags & u32(65536)) {
		ctx.mark_char_map[`|`] = i8(1)
	}
	if ctx.parser.flags & u32(1) {
		i := i32(0)
		for i = 0; i < i32(sizeof([256]i8)); i++ {
			if ((i == ` ` || i == `\t`) || (i == `\v` || i == `\f`)) {
				ctx.mark_char_map[i] = i8(1)
			}
		}
	}
}

fn md_is_code_span(ctx &MD_CTX, lines &MD_LINE, n_lines Size, beg Offset, opener &MD_MARK, closer &MD_MARK, last_potential_closers &Offset, p_reached_paragraph_end &i32) i32 {
	opener_beg := beg
	opener_end := Offset(0)
	closer_beg := Offset(0)
	closer_end := Offset(0)
	mark_len := Size(0)
	line_end := Offset(0)
	has_space_after_opener := i32(0)
	has_eol_after_opener := i32(0)
	has_space_before_closer := i32(0)
	has_eol_before_closer := i32(0)
	has_only_space := i32(1)
	line_index := Size(0)
	line_end = lines[0].end
	opener_end = opener_beg
	for opener_end < line_end && i32(ctx.text[opener_end]) == i8(`\``) {
		opener_end++
	}
	has_space_after_opener = (opener_end < line_end && i32(ctx.text[opener_end]) == i8(` `))
	has_eol_after_opener = (opener_end == line_end)
	opener.c2v_anonymous_105093.offsets.end = opener_end
	mark_len = opener_end - opener_beg
	if mark_len > Size(32) {
		return 0
	}
	if last_potential_closers[mark_len - Size(1)] >= lines[n_lines - Size(1)].end || ((unsafe { *p_reached_paragraph_end }) && last_potential_closers[mark_len - Size(1)] < opener_end) {
		return 0
	}
	closer_beg = opener_end
	for {
		for closer_beg < line_end && i32(ctx.text[closer_beg]) != i8(`\``) {
			if i32(ctx.text[closer_beg]) != i8(` `) {
				has_only_space = 0
			}
			closer_beg++
		}
		closer_end = closer_beg
		for closer_end < line_end && i32(ctx.text[closer_end]) == i8(`\``) {
			closer_end++
		}
		if closer_end - closer_beg == mark_len {
			has_space_before_closer = (closer_beg > lines[line_index].beg && i32(ctx.text[(closer_beg - Offset(1))]) == i8(` `))
			has_eol_before_closer = (closer_beg == lines[line_index].beg)
			break
		}
		if closer_end - closer_beg > Offset(0) {
			has_only_space = 0
			if closer_end - closer_beg < Offset(32) {
				if closer_beg > last_potential_closers[closer_end - closer_beg - Offset(1)] {
					last_potential_closers[closer_end - closer_beg - Offset(1)] = closer_beg
				}
			}
		}
		if closer_end >= line_end {
			line_index++
			if line_index >= n_lines {
				unsafe { *p_reached_paragraph_end = 1 }
				return 0
			}
			line_end = lines[line_index].end
			closer_beg = lines[line_index].beg
		} else {
			closer_beg = closer_end
		}
	}
	if !has_only_space && (has_space_after_opener || has_eol_after_opener) && (has_space_before_closer || has_eol_before_closer) {
		if has_space_after_opener {
			opener_end++
		} else {
			opener_end = lines[1].beg
		}
		if has_space_before_closer {
			closer_beg--
		} else {
			closer_beg = lines[line_index - Size(1)].end
			for closer_beg < ctx.size && (i32(ctx.text[closer_beg]) == i8(` `) || i32(ctx.text[closer_beg]) == i8(`\t`)) {
				closer_beg++
			}
		}
	}
	opener.ch = Char(`\``)
	opener.c2v_anonymous_105093.offsets.beg = opener_beg
	opener.c2v_anonymous_105093.offsets.end = opener_end
	opener.flags = u8(1)
	closer.ch = Char(`\``)
	closer.c2v_anonymous_105093.offsets.beg = closer_beg
	closer.c2v_anonymous_105093.offsets.end = closer_end
	closer.flags = u8(2)
	return 1
}

fn md_is_autolink_uri(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg + Offset(1)
	for {
		md_assume((i32(ctx.text[beg]) == i8(`<`)))
		// while()
		break
	}
	mut __c2v_condition_18 := false
	mut __c2v_condition_19 := false
	__c2v_condition_19 = off >= max_end
	__c2v_condition_18 = __c2v_condition_19
	if !__c2v_condition_18 {
		mut __c2v_condition_20 := false
		__c2v_condition_20 = !(((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`)))
		__c2v_condition_18 = __c2v_condition_20
	}
	if __c2v_condition_18 {
		return 0
	}
	off++
	for {
		if off >= max_end {
			return 0
		}
		if off - beg > Offset(32) {
			return 0
		}
		if i32(ctx.text[off]) == i8(`:`) && off - beg >= Offset(3) {
			break
		}
		mut __c2v_condition_21 := false
		mut __c2v_condition_22 := false
		__c2v_condition_22 = !(((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`)))
		if __c2v_condition_22 {
			__c2v_condition_22 = i32(ctx.text[off]) != i8(`+`)
		}
		if __c2v_condition_22 {
			__c2v_condition_22 = i32(ctx.text[off]) != i8(`-`)
		}
		if __c2v_condition_22 {
			__c2v_condition_22 = i32(ctx.text[off]) != i8(`.`)
		}
		__c2v_condition_21 = __c2v_condition_22
		if __c2v_condition_21 {
			return 0
		}
		off++
	}
	for off < max_end && i32(ctx.text[off]) != i8(`>`) {
		if (u32(ctx.text[off]) <= u32(32) || u32(ctx.text[off]) == u32(127)) || i32(ctx.text[off]) == i8(`<`) {
			return 0
		}
		off++
	}
	if off >= max_end {
		return 0
	}
	for {
		md_assume((i32(ctx.text[off]) == i8(`>`)))
		// while()
		break
	}
	unsafe { *p_end = off + Offset(1) }
	return 1
}

fn md_is_autolink_email(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset) i32 {
	off := beg + Offset(1)
	label_len := i32(0)
	for {
		md_assume((i32(ctx.text[beg]) == i8(`<`)))
		// while()
		break
	}
	for off < max_end && ((((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`))) || (i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c".!#$%&'*+/=?^_`{|}~-"[0]) }, i32(ctx.text[off]))) != uint((voidptr(0))))) {
		off++
	}
	if off <= beg + Offset(1) {
		return 0
	}
	if off >= max_end || i32(ctx.text[off]) != i8(`@`) {
		return 0
	}
	off++
	label_len = 0
	for off < max_end {
		mut __c2v_condition_23 := false
		mut __c2v_condition_24 := false
		__c2v_condition_24 = (((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`)))
		__c2v_condition_23 = __c2v_condition_24
		if !__c2v_condition_23 {
			mut __c2v_condition_25 := false
			__c2v_condition_25 = (i32(ctx.text[off]) == i8(`-`) && label_len > 0)
			__c2v_condition_23 = __c2v_condition_25
		}
		if __c2v_condition_23 {
			label_len++
		} else if i32(ctx.text[off]) == i8(`.`) && label_len > 0 && i32(ctx.text[(off - Offset(1))]) != i8(`-`) {
			label_len = 0
		} else {
			break
		}
		if label_len > 63 {
			return 0
		}
		off++
	}
	if label_len <= 0 || off >= max_end || i32(ctx.text[off]) != i8(`>`) || i32(ctx.text[(off - Offset(1))]) == i8(`-`) {
		return 0
	}
	unsafe { *p_end = off + Offset(1) }
	return 1
}

fn md_is_autolink(ctx &MD_CTX, beg Offset, max_end Offset, p_end &Offset, p_missing_mailto &i32) i32 {
	if md_is_autolink_uri(ctx, beg, max_end, p_end) {
		unsafe { *p_missing_mailto = 0 }
		return 1
	}
	if md_is_autolink_email(ctx, beg, max_end, p_end) {
		unsafe { *p_missing_mailto = 1 }
		return 1
	}
	return 0
}

fn md_collect_marks(ctx &MD_CTX, lines &MD_LINE, n_lines Size, table_mode i32) i32 {
	line_index := Size(0)
	ret := i32(0)
	mark := &MD_MARK(0)
	codespan_last_potential_closers := [32]Offset{}
	codespan_scanned_till_paragraph_end := i32(0)
	for line_index = Size(0); line_index < n_lines; line_index++ {
		line := unsafe { lines + line_index }
		off := line.beg
		for {
			ch := Char(0)
			for off + Offset(3) < line.end && !ctx.mark_char_map[u8(ctx.text[(off + Offset(0))])] && !ctx.mark_char_map[u8(ctx.text[(off + Offset(1))])] && !ctx.mark_char_map[u8(ctx.text[(off + Offset(2))])] && !ctx.mark_char_map[u8(ctx.text[(off + Offset(3))])] {
				off += Offset(4)
			}
			for off < line.end && !ctx.mark_char_map[u8(ctx.text[(off + Offset(0))])] {
				off++
			}
			if off >= line.end {
				break
			}
			ch = ctx.text[off]
			mut __c2v_condition_26 := false
			mut __c2v_condition_27 := false
			__c2v_condition_27 = i32(ch) == i8(`\\`)
			if __c2v_condition_27 {
				__c2v_condition_27 = off + Offset(1) < ctx.size
			}
			if __c2v_condition_27 {
				__c2v_condition_27 = (((u32(33) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(47)) || (u32(58) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(64)) || (u32(91) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(96)) || (u32(123) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(126))) || (i32(ctx.text[(off + Offset(1))]) == i8(`\r`) || i32(ctx.text[(off + Offset(1))]) == i8(`\n`)))
			}
			__c2v_condition_26 = __c2v_condition_27
			if __c2v_condition_26 {
				if !(i32(ctx.text[(off + Offset(1))]) == i8(`\r`) || i32(ctx.text[(off + Offset(1))]) == i8(`\n`)) || line_index + Size(1) < n_lines {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(2))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(16)
						// while()
						break
					}
				}
				off += Offset(2)
				continue
			}
			if i32(ch) == i8(`*`) || i32(ch) == i8(`_`) {
				tmp := off + Offset(1)
				left_level := i32(0)
				right_level := i32(0)
				for tmp < line.end && i32(ctx.text[tmp]) == i32(ch) {
					tmp++
				}
				if off == line.beg || md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, off)) {
					left_level = 0
				} else if md_is_unicode_punct__(md_decode_utf8_before__(ctx, off)) {
					left_level = 1
				} else {
					left_level = 2
				}
				if tmp == line.end || md_is_unicode_whitespace__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0)))) {
					right_level = 0
				} else if md_is_unicode_punct__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0)))) {
					right_level = 1
				} else {
					right_level = 2
				}
				if i32(ch) == i8(`_`) && left_level == 2 && right_level == 2 {
					left_level = 0
					right_level = 0
				}
				if left_level != 0 || right_level != 0 {
					flags := u32(0)
					if left_level > 0 && left_level >= right_level {
						flags |= u32(2)
					}
					if right_level > 0 && right_level >= left_level {
						flags |= u32(1)
					}
					if flags == u32((1 | 2)) {
						flags |= u32(32)
					}
					// For "the rule of three" we need to remember the original
					//                     *size of the mark (modulo three), before we potentially
					//                     *split the mark when being later resolved partially by some
					//                     *shorter closer.

					match ((tmp - off) % Offset(3)) {
						0 { // case comp body kind=CompoundAssignOperator is_enum=true
							flags |= u32(64)
						}
						1 { // case comp body kind=CompoundAssignOperator is_enum=true
							flags |= u32(128)
						}
						2 { // case comp body kind=CompoundAssignOperator is_enum=true
							flags |= u32((64 | 128))
						}
						else {}
					}

					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = tmp
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(flags)
						// while()
						break
					}
					// During resolving, multiple asterisks may have to be
					//                     *split into independent span start/ends. Consider e.g.
					//                     *"*foo*bar*. Therefore we push also some empty dummy
					//                     *marks to have enough space for that.

					off++
					for off < tmp {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = off
							mark.c2v_anonymous_105093.offsets.end = off
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(`D`)
							mark.flags = u8(0)
							// while()
							break
						}
						off++
					}
					continue
				}
				off = tmp
				continue
			}
			// A potential code span start/end.

			if i32(ch) == i8(`\``) {
				opener := MD_MARK{}
				closer := MD_MARK{}
				is_code_span := i32(0)
				is_code_span = md_is_code_span(ctx, line, n_lines - line_index, off, &opener, &closer, &codespan_last_potential_closers[0], &codespan_scanned_till_paragraph_end)
				if is_code_span {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = opener.c2v_anonymous_105093.offsets.beg
						mark.c2v_anonymous_105093.offsets.end = opener.c2v_anonymous_105093.offsets.end
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(opener.ch)
						mark.flags = opener.flags
						// while()
						break
					}
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = closer.c2v_anonymous_105093.offsets.beg
						mark.c2v_anonymous_105093.offsets.end = closer.c2v_anonymous_105093.offsets.end
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(closer.ch)
						mark.flags = closer.flags
						// while()
						break
					}
					md_resolve_range(ctx, ctx.n_marks - 2, ctx.n_marks - 1)
					off = closer.c2v_anonymous_105093.offsets.end
					// Advance the current line accordingly.

					if off > line.end {
						line = md_lookup_line(off, lines, n_lines, &line_index)
					}
					continue
				}
				off = opener.c2v_anonymous_105093.offsets.end
				continue
			}
			// A potential entity start.

			if i32(ch) == i8(`&`) {
				for {
					for {
						mark = md_add_mark(ctx)
						if uint(mark) == uint((voidptr(0))) {
							ret = -1
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					mark.c2v_anonymous_105093.offsets.beg = off
					mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
					mark.prev = -1
					mark.next = -1
					mark.ch = i8(ch)
					mark.flags = u8(1)
					// while()
					break
				}
				off++
				continue
			}
			// A potential entity end.

			if i32(ch) == i8(`;`) {
				// We surely cannot be entity unless the previous mark is '&'.

				if ctx.n_marks > 0 && i32(ctx.marks[ctx.n_marks - 1].ch) == i8(`&`) {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(2)
						// while()
						break
					}
				}
				off++
				continue
			}
			// A potential autolink or raw HTML start/end.

			if i32(ch) == i8(`<`) {
				is_autolink := i32(0)
				autolink_end := Offset(0)
				missing_mailto := i32(0)
				if !(ctx.parser.flags & u32(64)) {
					is_html := i32(0)
					html_end := Offset(0)
					// Given the nature of the raw HTML, we have to recognize
					//                     *it here. Doing so later in md_analyze_lt_gt() could
					//                     *open can of worms of quadratic complexity.

					is_html = md_is_html_any(ctx, line, n_lines - line_index, off, lines[n_lines - Size(1)].end, &html_end)
					if is_html {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = off
							mark.c2v_anonymous_105093.offsets.end = off
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(`<`)
							mark.flags = u8((4 | 16))
							// while()
							break
						}
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = html_end
							mark.c2v_anonymous_105093.offsets.end = html_end
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(`>`)
							mark.flags = u8((8 | 16))
							// while()
							break
						}
						ctx.marks[ctx.n_marks - 2].next = ctx.n_marks - 1
						ctx.marks[ctx.n_marks - 1].prev = ctx.n_marks - 2
						off = html_end
						// Advance the current line accordingly.

						if off > line.end {
							line = md_lookup_line(off, lines, n_lines, &line_index)
						}
						continue
					}
				}
				is_autolink = md_is_autolink(ctx, off, lines[n_lines - Size(1)].end, &autolink_end, &missing_mailto)
				if is_autolink {
					flags := u32(16 | 32)
					if missing_mailto {
						flags |= u32(64)
					}
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(`<`)
						mark.flags = u8((u32(4) | flags))
						// while()
						break
					}
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = (autolink_end - Offset(1))
						mark.c2v_anonymous_105093.offsets.end = autolink_end
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(`>`)
						mark.flags = u8((u32(8) | flags))
						// while()
						break
					}
					ctx.marks[ctx.n_marks - 2].next = ctx.n_marks - 1
					ctx.marks[ctx.n_marks - 1].prev = ctx.n_marks - 2
					off = autolink_end
					continue
				}
				off++
				continue
			}
			// A potential link, footnote and similar or its part.

			if i32(ch) == i8(`[`) || (i32(ch) == i8(`!`) && off + Offset(1) < line.end && i32(ctx.text[(off + Offset(1))]) == i8(`[`)) {
				if i32(ch) == i8(`!`) {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = (off + Offset(1))
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(2))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8((1 | 32))
						// while()
						break
					}
					off += Offset(2)
				} else {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(1)
						// while()
						break
					}
					off += Offset(1)
				}
				// Two dummies to make enough place for data we need if it is
				//                 *a link.

				for {
					for {
						mark = md_add_mark(ctx)
						if uint(mark) == uint((voidptr(0))) {
							ret = -1
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					mark.c2v_anonymous_105093.offsets.beg = off
					mark.c2v_anonymous_105093.offsets.end = off
					mark.prev = -1
					mark.next = -1
					mark.ch = i8(`D`)
					mark.flags = u8(0)
					// while()
					break
				}
				for {
					for {
						mark = md_add_mark(ctx)
						if uint(mark) == uint((voidptr(0))) {
							ret = -1
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					mark.c2v_anonymous_105093.offsets.beg = off
					mark.c2v_anonymous_105093.offsets.end = off
					mark.prev = -1
					mark.next = -1
					mark.ch = i8(`D`)
					mark.flags = u8(0)
					// while()
					break
				}
				continue
			}
			if i32(ch) == i8(`]`) {
				for {
					for {
						mark = md_add_mark(ctx)
						if uint(mark) == uint((voidptr(0))) {
							ret = -1
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					mark.c2v_anonymous_105093.offsets.beg = off
					mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
					mark.prev = -1
					mark.next = -1
					mark.ch = i8(ch)
					mark.flags = u8(2)
					// while()
					break
				}
				off++
				continue
			}
			// A potential permissive e-mail autolink.

			if i32(ch) == i8(`@`) {
				mut __c2v_condition_28 := false
				mut __c2v_condition_29 := false
				__c2v_condition_29 = line.beg + Offset(1) <= off
				if __c2v_condition_29 {
					__c2v_condition_29 = (((u32(`A`) <= u32(ctx.text[(off - Offset(1))]) && u32(ctx.text[(off - Offset(1))]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[(off - Offset(1))]) && u32(ctx.text[(off - Offset(1))]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[(off - Offset(1))]) && u32(ctx.text[(off - Offset(1))]) <= u32(`9`)))
				}
				if __c2v_condition_29 {
					__c2v_condition_29 = off + Offset(3) < line.end
				}
				if __c2v_condition_29 {
					__c2v_condition_29 = (((u32(`A`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`9`)))
				}
				__c2v_condition_28 = __c2v_condition_29
				if __c2v_condition_28 {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(1)
						// while()
						break
					}
					// Push a dummy as a reserve for a closer.

					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = line.beg
						mark.c2v_anonymous_105093.offsets.end = line.end
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(`D`)
						mark.flags = u8(0)
						// while()
						break
					}
				}
				off++
				continue
			}
			// A potential permissive URL autolink.

			if i32(ch) == i8(`:`) {
				scheme_index := i32(0)
				for scheme_index = 0; scheme_index < 3; scheme_index++ {
					scheme := md_collect_marks_scheme_map[scheme_index].scheme
					scheme_size := md_collect_marks_scheme_map[scheme_index].scheme_size
					suffix := md_collect_marks_scheme_map[scheme_index].suffix
					suffix_size := md_collect_marks_scheme_map[scheme_index].suffix_size
					mut __c2v_condition_30 := false
					mut __c2v_condition_31 := false
					__c2v_condition_31 = line.beg + scheme_size <= off
					if __c2v_condition_31 {
						__c2v_condition_31 = md_ascii_eq((ctx.text + (off - scheme_size)), scheme, scheme_size)
					}
					if __c2v_condition_31 {
						__c2v_condition_31 = off + Offset(1) + suffix_size < line.end
					}
					if __c2v_condition_31 {
						__c2v_condition_31 = md_ascii_eq((ctx.text + (off + Offset(1))), suffix, suffix_size)
					}
					__c2v_condition_30 = __c2v_condition_31
					if __c2v_condition_30 {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = (off - scheme_size)
							mark.c2v_anonymous_105093.offsets.end = (off + Offset(1) + suffix_size)
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(ch)
							mark.flags = u8(1)
							// while()
							break
						}
						// Push a dummy as a reserve for a closer.

						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = line.beg
							mark.c2v_anonymous_105093.offsets.end = line.end
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(`D`)
							mark.flags = u8(0)
							// while()
							break
						}
						off += Size(1) + suffix_size
						break
					}
				}
				off++
				continue
			}
			// A potential permissive WWW autolink.

			if i32(ch) == i8(`.`) {
				mut __c2v_condition_32 := false
				mut __c2v_condition_33 := false
				__c2v_condition_33 = line.beg + Offset(3) <= off
				if __c2v_condition_33 {
					__c2v_condition_33 = md_ascii_eq((ctx.text + (off - Offset(3))), c'www', Size(3))
				}
				if __c2v_condition_33 {
					__c2v_condition_33 = (off - Offset(3) == line.beg || md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, off - Offset(3))) || md_is_unicode_punct__(md_decode_utf8_before__(ctx, off - Offset(3))))
				}
				__c2v_condition_32 = __c2v_condition_33
				if __c2v_condition_32 {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = (off - Offset(3))
						mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(1)
						// while()
						break
					}
					// Push a dummy as a reserve for a closer.

					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = line.beg
						mark.c2v_anonymous_105093.offsets.end = line.end
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(`D`)
						mark.flags = u8(0)
						// while()
						break
					}
					off++
					continue
				}
				off++
				continue
			}
			// We may need pipes for tables (cell delimiter), for wiki-links
			//             *Note we coalesce spans of pipes into a single mark.
			//             *
			//             * - Tables may use spans of any length.
			//             * - Wiki-links use only (unresolved) spans of length 1.
			//             * - Spoilers use use only (unresolved) spans of length 2.
			//

			if i32(ch) == i8(`|`) {
				tmp := off + Offset(1)
				for tmp < line.end && i32(ctx.text[tmp]) == i32(ch) {
					tmp++
				}
				if table_mode || (tmp - off == Offset(1) && (ctx.parser.flags & u32(8192))) || (tmp - off == Offset(2) && (ctx.parser.flags & u32(65536))) {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = tmp
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8((1 | 2))
						// while()
						break
					}
				}
				off = tmp
				continue
			}
			// A potential superscript, highlight, or insert

			if (i32(ch) == i8(`=`) || i32(ch) == i8(`+`) || i32(ch) == i8(`^`)) {
				tmp := off + Offset(1)
				for tmp < line.end && i32(ctx.text[tmp]) == i32(ch) {
					tmp++
				}
				// Only a single caret is a superscript.
				//                 *Only two equals signs form a highlight.
				//                 *Only two plus signs form a insert.

				if ((i32(ch) == i8(`=`) || i32(ch) == i8(`+`)) && tmp - off == Offset(2)) || (i32(ch) == i8(`^`) && tmp - off == Offset(1)) {
					flags := u32(1 | 2)
					// Cannot open before whitespace; cannot close after whitespace.

					if tmp >= line.end || md_is_unicode_whitespace__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0)))) {
						flags &= u32(~1)
					}
					if off == line.beg || md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, off)) {
						flags &= u32(~2)
					}
					if flags != u32(0) {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = off
							mark.c2v_anonymous_105093.offsets.end = tmp
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(ch)
							mark.flags = u8(flags)
							// while()
							break
						}
					}
				}
				off = tmp
				continue
			}
			// A potential strikethrough/subscript start/end.

			if i32(ch) == i8(`~`) {
				tmp := off + Offset(1)
				for tmp < line.end && i32(ctx.text[tmp]) == i32(ch) {
					tmp++
				}
				if tmp - off == Offset(1) && (ctx.parser.flags & u32(262144)) {
					// Subscript: can open after any non-whitespace, cannot open
					//                     *before whitespace; cannot close after whitespace.

					flags := u32(1 | 2)
					if tmp >= line.end || md_is_unicode_whitespace__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0)))) {
						flags &= u32(~1)
					}
					if off == line.beg || md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, off)) {
						flags &= u32(~2)
					}
					if flags != u32(0) {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = off
							mark.c2v_anonymous_105093.offsets.end = tmp
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(ch)
							mark.flags = u8(flags)
							// while()
							break
						}
					}
				} else if tmp - off <= Offset(2) && (ctx.parser.flags & u32(512)) {
					// Strikethrough: standard GFM left/right-flanking rules.

					flags := u32(1 | 2)
					if off > line.beg && !md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, off)) && !md_is_unicode_punct__(md_decode_utf8_before__(ctx, off)) {
						flags &= u32(~1)
					}
					mut __c2v_condition_34 := false
					mut __c2v_condition_35 := false
					__c2v_condition_35 = tmp < line.end
					if __c2v_condition_35 {
						__c2v_condition_35 = !md_is_unicode_whitespace__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0))))
					}
					if __c2v_condition_35 {
						__c2v_condition_35 = !md_is_unicode_punct__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0))))
					}
					__c2v_condition_34 = __c2v_condition_35
					if __c2v_condition_34 {
						flags &= u32(~2)
					}
					if flags != u32(0) {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = off
							mark.c2v_anonymous_105093.offsets.end = tmp
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(ch)
							mark.flags = u8(flags)
							// while()
							break
						}
					}
				}
				off = tmp
				continue
			}
			// A potential equation start/end.

			if i32(ch) == i8(`$`) {
				tmp := off + Offset(1)
				for tmp < line.end && i32(ctx.text[tmp]) == i32(ch) {
					tmp++
				}
				if tmp - off <= Offset(2) {
					flags := u32(1 | 2)
					if off > line.beg && !md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, off)) && !md_is_unicode_punct__(md_decode_utf8_before__(ctx, off)) {
						flags &= u32(~1)
					}
					mut __c2v_condition_36 := false
					mut __c2v_condition_37 := false
					__c2v_condition_37 = tmp < line.end
					if __c2v_condition_37 {
						__c2v_condition_37 = !md_is_unicode_whitespace__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0))))
					}
					if __c2v_condition_37 {
						__c2v_condition_37 = !md_is_unicode_punct__(md_decode_utf8__((ctx.text + tmp), ctx.size - tmp, (voidptr(0))))
					}
					__c2v_condition_36 = __c2v_condition_37
					if __c2v_condition_36 {
						flags &= u32(~2)
					}
					if flags != u32(0) {
						for {
							for {
								mark = md_add_mark(ctx)
								if uint(mark) == uint((voidptr(0))) {
									ret = -1
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							mark.c2v_anonymous_105093.offsets.beg = off
							mark.c2v_anonymous_105093.offsets.end = tmp
							mark.prev = -1
							mark.next = -1
							mark.ch = i8(ch)
							mark.flags = u8(flags)
							// while()
							break
						}
					}
				}
				off = tmp
				continue
			}
			// Turn non-trivial whitespace into single space.

			if ((i32(ch) == i8(` `) || i32(ch) == i8(`\t`)) || (i32(ch) == i8(`\v`) || i32(ch) == i8(`\f`))) {
				tmp := off + Offset(1)
				for tmp < line.end && ((i32(ctx.text[tmp]) == i8(` `) || i32(ctx.text[tmp]) == i8(`\t`)) || (i32(ctx.text[tmp]) == i8(`\v`) || i32(ctx.text[tmp]) == i8(`\f`))) {
					tmp++
				}
				if tmp - off > Offset(1) || i32(ch) != i8(` `) {
					for {
						for {
							mark = md_add_mark(ctx)
							if uint(mark) == uint((voidptr(0))) {
								ret = -1
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.beg = off
						mark.c2v_anonymous_105093.offsets.end = tmp
						mark.prev = -1
						mark.next = -1
						mark.ch = i8(ch)
						mark.flags = u8(16)
						// while()
						break
					}
				}
				off = tmp
				continue
			}
			// NULL character.

			if i32(ch) == i8(`\0`) {
				for {
					for {
						mark = md_add_mark(ctx)
						if uint(mark) == uint((voidptr(0))) {
							ret = -1
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					mark.c2v_anonymous_105093.offsets.beg = off
					mark.c2v_anonymous_105093.offsets.end = (off + Offset(1))
					mark.prev = -1
					mark.next = -1
					mark.ch = i8(ch)
					mark.flags = u8(16)
					// while()
					break
				}
				off++
				continue
			}
			off++
		}
	}
	// Add a dummy mark at the end of the mark vector to simplify
	//     *process_inlines().

	for {
		for {
			mark = md_add_mark(ctx)
			if uint(mark) == uint((voidptr(0))) {
				ret = -1
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		mark.c2v_anonymous_105093.offsets.beg = ctx.size
		mark.c2v_anonymous_105093.offsets.end = ctx.size
		mark.prev = -1
		mark.next = -1
		mark.ch = i8(127)
		mark.flags = u8(16)
		// while()
		break
	}
	abort:
	return ret
}

fn md_analyze_bracket(ctx &MD_CTX, mark_index i32) {
	// We cannot really resolve links here as for that we would need
	//     *more context. E.g. a following pair of brackets (reference link),
	//     *or enclosing pair of brackets (if the inner is the link, the outer
	//     *one cannot be.)
	//     *
	//     *Therefore we here only construct a list of '[' ']' pairs ordered by
	//     *position of the closer. This allows us to analyze what is or is not
	//     *link in the right order, from inside to outside in case of nested
	//     *brackets.
	//     *
	//     *The resolving itself is deferred to md_resolve_brackets().
	//

	mark := unsafe { ctx.marks + mark_index }
	if i32(mark.flags) & 1 {
		if ctx.opener_stacks[14].top >= 0 {
			ctx.marks[ctx.opener_stacks[14].top].flags |= 64
		}
		// Retain the parent even after the initial pairing. A bracket in a
		//         *link destination may later be disabled, freeing its closer.

		ctx.marks[mark_index + 1].next = ctx.opener_stacks[14].top
		md_mark_stack_push(ctx, unsafe { &ctx.opener_stacks[0] + 14 }, mark_index)
		return
	}
	if ctx.opener_stacks[14].top >= 0 {
		opener_index := md_mark_stack_pop(ctx, unsafe { &ctx.opener_stacks[0] + 14 })
		opener := unsafe { ctx.marks + opener_index }
		// Interconnect the opener and closer.

		opener.next = mark_index
		mark.prev = opener_index
		// Queue closers so reassigning an opener does not change the queue.

		if ctx.unresolved_link_tail >= 0 {
			ctx.marks[ctx.unresolved_link_tail].next = mark_index
		} else {
			ctx.unresolved_link_head = mark_index
		}
		ctx.unresolved_link_tail = mark_index
		mark.next = -1
	}
}

// Find an opener which has neither been disabled nor consumed by a closer.
// *Compress the parent chain to avoid repeatedly visiting discarded openers.

fn md_bracket_opener(ctx &MD_CTX, opener_index i32) i32 {
	index := opener_index
	for index >= 0 && (i32(ctx.marks[index].ch) == i8(`D`) || (i32(ctx.marks[index + 1].flags) & 32)) {
		index = ctx.marks[index + 1].next
	}
	for opener_index != index {
		parent := ctx.marks[opener_index + 1].next
		ctx.marks[opener_index + 1].next = index
		opener_index = parent
	}
	return index
}

// Forward declaration.

// Try to resolve a bracket pair as a wiki link '[[destination]]' or
// *'[[destination|label]]'.
// *Returns true if resolved, false if not a wiki link, -1 on error.

fn md_resolve_bracket_wikilink(ctx &MD_CTX, lines &MD_LINE, n_lines Size, opener_index i32, closer_index i32, opener &MD_MARK, closer &MD_MARK, next_opener &MD_MARK, next_closer &MD_MARK, last_link_beg &Offset, last_link_end &Offset, p_closer_index &i32) i32 {
	delim := unsafe { &MD_MARK(nil) }
	delim_index := i32(0)
	dest_beg := Offset(0)
	dest_end := Offset(0)

	off := Offset(0)
	if !(ctx.parser.flags & u32(8192)) {
		return 0
	}
	mut __c2v_condition_38 := false
	mut __c2v_condition_39 := false
	__c2v_condition_39 = i32(opener.ch) != i8(`[`)
	__c2v_condition_38 = __c2v_condition_39
	if !__c2v_condition_38 {
		mut __c2v_condition_40 := false
		__c2v_condition_40 = opener.c2v_anonymous_105093.offsets.end - opener.c2v_anonymous_105093.offsets.beg != Offset(1)
		__c2v_condition_38 = __c2v_condition_40
	}
	if !__c2v_condition_38 {
		mut __c2v_condition_41 := false
		__c2v_condition_41 = uint(next_opener) == uint((voidptr(0)))
		__c2v_condition_38 = __c2v_condition_41
	}
	if !__c2v_condition_38 {
		mut __c2v_condition_42 := false
		__c2v_condition_42 = i32(next_opener.ch) != i8(`[`)
		__c2v_condition_38 = __c2v_condition_42
	}
	if !__c2v_condition_38 {
		mut __c2v_condition_43 := false
		__c2v_condition_43 = next_opener.c2v_anonymous_105093.offsets.end - next_opener.c2v_anonymous_105093.offsets.beg != Offset(1)
		__c2v_condition_38 = __c2v_condition_43
	}
	if !__c2v_condition_38 {
		mut __c2v_condition_44 := false
		__c2v_condition_44 = uint(next_closer) == uint((voidptr(0)))
		__c2v_condition_38 = __c2v_condition_44
	}
	if !__c2v_condition_38 {
		mut __c2v_condition_45 := false
		__c2v_condition_45 = i32(next_closer.ch) != i8(`]`)
		__c2v_condition_38 = __c2v_condition_45
	}
	if !__c2v_condition_38 {
		mut __c2v_condition_46 := false
		__c2v_condition_46 = next_closer.c2v_anonymous_105093.offsets.end - next_closer.c2v_anonymous_105093.offsets.beg != Offset(1)
		__c2v_condition_38 = __c2v_condition_46
	}
	if __c2v_condition_38 {
		return 0
	}
	// Check that the next_opener and next_closer are nested properly.

	if next_opener.c2v_anonymous_105093.offsets.beg != opener.c2v_anonymous_105093.offsets.beg - Offset(1) || next_closer.c2v_anonymous_105093.offsets.beg != closer.c2v_anonymous_105093.offsets.beg + Offset(1) {
		return 0
	}
	// We don't allow destination to be longer than 100 characters.
	//     *Lets scan to see whether there is '|'. (If not then the whole
	//     *wiki-link has to be below the 100 characters.)

	delim_index = opener_index + 1
	for delim_index < closer_index {
		m := unsafe { ctx.marks + delim_index }
		if i32(m.ch) == i8(`|`) && m.c2v_anonymous_105093.offsets.end - m.c2v_anonymous_105093.offsets.beg == Offset(1) && !(i32(m.flags) & 16) {
			delim = m
			break
		}
		if i32(m.ch) != i8(`D`) {
			if m.c2v_anonymous_105093.offsets.beg - opener.c2v_anonymous_105093.offsets.end > Offset(100) {
				break
			}
			if i32(m.ch) != i8(`D`) && (i32(m.flags) & 4) {
				delim_index = m.next
			}
		}
		delim_index++
	}
	dest_beg = opener.c2v_anonymous_105093.offsets.end
	dest_end = if (uint(delim) != uint((voidptr(0)))) {
		delim.c2v_anonymous_105093.offsets.beg
	} else {
		closer.c2v_anonymous_105093.offsets.beg
	}
	if dest_end - dest_beg == Offset(0) || dest_end - dest_beg > Offset(100) {
		return 0
	}
	// There may not be any new line in the destination.

	for off = dest_beg; off < dest_end; off++ {
		if (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
			return 0
		}
	}
	md_pop_openers(ctx, opener_index)
	if uint(delim) != uint((voidptr(0))) {
		if delim.c2v_anonymous_105093.offsets.end < closer.c2v_anonymous_105093.offsets.beg {
			md_disable_marks(ctx, opener_index + 1, delim_index)
			delim.flags |= 16
			opener.c2v_anonymous_105093.offsets.end = delim.c2v_anonymous_105093.offsets.beg
		} else {
			// The pipe is just before the closer: [[foo|]]

			md_disable_marks(ctx, opener_index + 1, closer_index)
			closer.c2v_anonymous_105093.offsets.beg = delim.c2v_anonymous_105093.offsets.beg
		}
	}
	opener.c2v_anonymous_105093.offsets.beg = next_opener.c2v_anonymous_105093.offsets.beg
	closer.c2v_anonymous_105093.offsets.end = next_closer.c2v_anonymous_105093.offsets.end
	md_resolve_range(ctx, opener_index, closer_index)
	unsafe { *last_link_beg = opener.c2v_anonymous_105093.offsets.beg }
	unsafe { *last_link_end = closer.c2v_anonymous_105093.offsets.end }
	if uint(delim) != uint((voidptr(0))) {
		md_analyze_link_contents(ctx, lines, n_lines, delim_index + 1, closer_index)
	}
	unsafe { *p_closer_index = next_closer.next }
	return 1
}

// Resolve footnote references [^label] in the current block.

fn md_resolve_bracket_footnote(ctx &MD_CTX, opener &MD_MARK, closer &MD_MARK, last_link_beg &Offset, last_link_end &Offset, p_closer_index &i32) i32 {
	index_mark := &MD_MARK(0)
	def := &MD_FOOTNOTE_DEF(0)
	label_beg := Offset(0)
	label_end := Offset(0)

	if !(ctx.parser.flags & u32(1048576)) {
		return 0
	}
	if i32(opener.ch) != i8(`[`) || opener.c2v_anonymous_105093.offsets.end >= ctx.size || i32(ctx.text[opener.c2v_anonymous_105093.offsets.end]) != i8(`^`) {
		return 0
	}
	closer = unsafe { ctx.marks + opener.next }
	// Verify the label satisfies the label rules.

	label_beg = opener.c2v_anonymous_105093.offsets.end + Offset(1)
	if !md_is_footnote_label(ctx, label_beg, &label_end) || label_end != closer.c2v_anonymous_105093.offsets.beg {
		return 0
	}
	if label_beg >= label_end {
		return 0
	}
	// empty label

	def = md_lookup_footnote_def(ctx, (ctx.text + label_beg), label_end - label_beg)
	if uint(def) == uint((voidptr(0))) {
		return 0
	}
	// Expand the opener to eat the '^' only for a resolved footnote.

	opener.c2v_anonymous_105093.offsets.end = label_beg
	// Assign index on first reference.

	if def.index == u32(0) {
		def.index = c2v_prefix_add(unsafe { &ctx.next_footnote_index }, u32(1))
		if uint(ctx.footnote_order) != uint((voidptr(0))) {
			ctx.footnote_order[def.index - u32(1)] = def
		}
	}
	def.ref_count++
	// Store the public callback details in the dummy mark after the opener.

	index_mark = opener + 1
	for {
		md_assume((i32(index_mark.ch) == i8(`D`)))
		// while()
		break
	}
	index_mark.c2v_anonymous_105093.offsets.beg = def.index
	index_mark.c2v_anonymous_105093.offsets.end = def.ref_count
	// Mark as resolved.

	opener.flags |= 4 | 16 | 128
	closer.flags |= 8 | 16 | 128
	unsafe { *last_link_beg = opener.c2v_anonymous_105093.offsets.beg }
	unsafe { *last_link_end = closer.c2v_anonymous_105093.offsets.end }
	unsafe { *p_closer_index = closer.next }
	return 1
}

// Try to resolve a bracket pair as a CommonMark link or image.
// *Returns -1 on error, 0 otherwise.

fn md_resolve_bracket_link(ctx &MD_CTX, lines &MD_LINE, n_lines Size, opener_index i32, closer_index i32, opener &MD_MARK, closer &MD_MARK, next_opener &MD_MARK, next_closer &MD_MARK, p_next_index &i32, last_link_beg &Offset, last_link_end &Offset, last_img_beg &Offset, last_img_end &Offset) i32 {
	attr := MD_LINK_ATTR{}
	is_link := i32(0)
	if uint(next_opener) != uint((voidptr(0))) && next_opener.c2v_anonymous_105093.offsets.beg == closer.c2v_anonymous_105093.offsets.end {
		if next_closer.c2v_anonymous_105093.offsets.beg > closer.c2v_anonymous_105093.offsets.end + Offset(1) {
			// Might be full reference link.

			if !(i32(next_opener.flags) & 64) {
				is_link = md_is_link_reference(ctx, lines, n_lines, next_opener.c2v_anonymous_105093.offsets.beg, next_closer.c2v_anonymous_105093.offsets.end, &attr)
			}
		} else {
			// Might be shortcut reference link.

			if !(i32(opener.flags) & 64) {
				is_link = md_is_link_reference(ctx, lines, n_lines, opener.c2v_anonymous_105093.offsets.beg, closer.c2v_anonymous_105093.offsets.end, &attr)
			}
		}
		if is_link < 0 {
			return -1
		}
		if is_link {
			// Eat the 2nd "[...]".

			closer.c2v_anonymous_105093.offsets.end = next_closer.c2v_anonymous_105093.offsets.end
			// Do not analyze the label as a standalone link in the next
			//             *iteration.

			unsafe { *p_next_index = ctx.marks[*p_next_index].next }
			// The consumed label cannot participate in inline span
			//             *resolution.

			md_disable_marks(ctx, i32((i64((int(next_opener) - int(ctx.marks)) / int(sizeof(MD_MARK_tag))))), i32((i64((int(next_closer) - int(ctx.marks)) / int(sizeof(MD_MARK_tag))))) + 1)
		}
	} else {
		if closer.c2v_anonymous_105093.offsets.end < ctx.size && i32(ctx.text[closer.c2v_anonymous_105093.offsets.end]) == i8(`(`) {
			// Might be inline link.

			inline_link_end := Offset((u32(2147483647) * 2 + 1))
			following_mark_index := closer_index + 1
			is_link = md_is_inline_link_spec(ctx, lines, n_lines, closer.c2v_anonymous_105093.offsets.end, &inline_link_end, &attr)
			if is_link < 0 {
				return -1
			}
			// Check the closing ')' is not inside an already resolved range
			//             *(i.e. a range with a higher priority), e.g. a code span.

			if is_link {
				for following_mark_index < ctx.n_marks {
					mark := unsafe { ctx.marks + following_mark_index }
					if mark.c2v_anonymous_105093.offsets.beg >= inline_link_end {
						break
					}
					if (i32(mark.flags) & (4 | 16)) == (4 | 16) {
						if ctx.marks[mark.next].c2v_anonymous_105093.offsets.beg >= inline_link_end {
							// Cancel the link status.

							if attr.title_needs_free {
								C.free(voidptr(attr.title))
							}
							is_link = 0
							break
						}
						following_mark_index = mark.next + 1
					} else {
						following_mark_index++
					}
				}
			}
			if is_link {
				// Eat the "(...)"

				closer.c2v_anonymous_105093.offsets.end = inline_link_end
				md_disable_marks(ctx, closer_index + 1, following_mark_index)
			}
		}
		if !is_link {
			// Might be collapsed reference link.

			if !(i32(opener.flags) & 64) {
				is_link = md_is_link_reference(ctx, lines, n_lines, opener.c2v_anonymous_105093.offsets.beg, closer.c2v_anonymous_105093.offsets.end, &attr)
			}
			if is_link < 0 {
				return -1
			}
		}
	}
	if is_link {
		// Resolve the brackets as a link.

		opener.flags |= 4 | 16
		closer.flags |= 8 | 16
		// If it is a link, we store the destination and title in the two
		//         *dummy marks after the opener.

		for {
			md_assume((i32(ctx.marks[opener_index + 1].ch) == i8(`D`)))
			// while()
			break
		}
		ctx.marks[opener_index + 1].c2v_anonymous_105093.offsets.beg = attr.dest_beg
		ctx.marks[opener_index + 1].c2v_anonymous_105093.offsets.end = attr.dest_end
		for {
			md_assume((i32(ctx.marks[opener_index + 2].ch) == i8(`D`)))
			// while()
			break
		}
		md_mark_store_ptr(ctx, opener_index + 2, voidptr(attr.title))
		// The title might or might not have been allocated for us.

		if attr.title_needs_free {
			md_mark_stack_push(ctx, &ctx.ptr_stack, opener_index + 2)
		}
		ctx.marks[opener_index + 2].prev = i32(attr.title_size)
		if i32(opener.ch) == i8(`[`) {
			unsafe { *last_link_beg = opener.c2v_anonymous_105093.offsets.beg }
			unsafe { *last_link_end = closer.c2v_anonymous_105093.offsets.end }
		} else {
			unsafe { *last_img_beg = opener.c2v_anonymous_105093.offsets.beg }
			unsafe { *last_img_end = closer.c2v_anonymous_105093.offsets.end }
		}
		md_analyze_link_contents(ctx, lines, n_lines, opener_index + 1, closer_index)
		// If the link text is formed by nothing but permissive autolink,
		//         *suppress the autolink.
		//         *See https://github.com/mity/md4c/issues/152 for more info.

		if ctx.parser.flags & u32((8 | 4 | 1024)) {
			first_nested := &MD_MARK(0)
			first_nested = opener + 1
			for i32(first_nested.ch) == i8(`D`) && uint(first_nested) < uint(closer) {
				c2v_pointer_postfix(voidptr(&first_nested), first_nested, int(1))
			}
			// Note the autolink closer is not necessarily the last mark
			//             *before the closer bracket: Resolved entity or escape marks
			//             *may live inside the autolink.

			mut __c2v_condition_47 := false
			mut __c2v_condition_48 := false
			__c2v_condition_48 = (i32(first_nested.flags) & 16)
			if __c2v_condition_48 {
				__c2v_condition_48 = first_nested.c2v_anonymous_105093.offsets.beg == opener.c2v_anonymous_105093.offsets.end
			}
			if __c2v_condition_48 {
				__c2v_condition_48 = (i32(first_nested.ch) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'@:.'[0]) }, i32(first_nested.ch))) != uint((voidptr(0))))
			}
			if __c2v_condition_48 {
				__c2v_condition_48 = ctx.marks[first_nested.next].c2v_anonymous_105093.offsets.end == closer.c2v_anonymous_105093.offsets.beg
			}
			__c2v_condition_47 = __c2v_condition_48
			if __c2v_condition_47 {
				last_nested := unsafe { ctx.marks + first_nested.next }
				first_nested.ch = Char(`D`)
				first_nested.flags &= ~16
				last_nested.ch = Char(`D`)
				last_nested.flags &= ~16
			}
		}
	}
	return 0
}

// Resolve bracket pairs as links, wiki links, or (in a 2nd pass) footnotes.

fn md_resolve_brackets(ctx &MD_CTX, lines &MD_LINE, n_lines Size) i32 {
	closer_index := ctx.unresolved_link_head
	last_link_beg := Offset(0)
	last_link_end := Offset(0)
	last_img_beg := Offset(0)
	last_img_end := Offset(0)
	ret := i32(0)
	// Note we here analyze from inner to outer as the marks are ordered
	//     *by closer->beg.

	for closer_index >= 0 {
		closer := unsafe { ctx.marks + closer_index }
		opener_index := md_bracket_opener(ctx, closer.prev)
		opener := &MD_MARK(0)
		next_index := closer.next
		next_opener := &MD_MARK(0)
		next_closer := &MD_MARK(0)
		if i32(closer.ch) == i8(`D`) || opener_index < 0 {
			// We could have this disabled in previous iterations, and
			//             *processing would be just burning CPU cycles.

			closer_index = next_index
			continue
		}
		opener = unsafe { ctx.marks + opener_index }
		opener.next = closer_index
		closer.prev = opener_index
		ctx.marks[opener_index + 1].flags |= 32
		if next_index >= 0 {
			next_opener_index := i32(0)
			next_closer = unsafe { ctx.marks + next_index }
			next_opener_index = md_bracket_opener(ctx, next_closer.prev)
			next_opener = unsafe {
				if (next_opener_index >= 0 && i32(next_closer.ch) != i8(`D`)) {
					ctx.marks + next_opener_index
				} else {
					&MD_MARK(nil)
				}
			}
		} else {
			next_opener = unsafe { nil }
			next_closer = unsafe { nil }
		}
		// We can perhaps be an image?

		if i32(opener.flags) & 32 {
			opener.ch = Char(`!`)
			opener.c2v_anonymous_105093.offsets.beg--
		}
		// If nested ("[ [ ] ]"), we need to make sure that:
		//         *  - The outer does not end inside of (...) belonging to the inner.
		//         *  - The outer cannot be link if the inner is link (but this does not apply to images).

		mut __c2v_condition_49 := false
		mut __c2v_condition_50 := false
		__c2v_condition_50 = (opener.c2v_anonymous_105093.offsets.beg < last_link_beg && closer.c2v_anonymous_105093.offsets.end < last_link_end)
		__c2v_condition_49 = __c2v_condition_50
		if !__c2v_condition_49 {
			mut __c2v_condition_51 := false
			__c2v_condition_51 = (opener.c2v_anonymous_105093.offsets.beg < last_img_beg && closer.c2v_anonymous_105093.offsets.end < last_img_end)
			__c2v_condition_49 = __c2v_condition_51
		}
		if !__c2v_condition_49 {
			mut __c2v_condition_52 := false
			__c2v_condition_52 = (opener.c2v_anonymous_105093.offsets.beg < last_link_end && i32(opener.ch) != i8(`!`))
			__c2v_condition_49 = __c2v_condition_52
		}
		if __c2v_condition_49 {
			closer_index = next_index
			continue
		}
		ret = md_resolve_bracket_footnote(ctx, opener, closer, &last_link_beg, &last_link_end, &closer_index)
		if ret < 0 {
			return -1
		}
		if ret > 0 {
			continue
		}
		ret = md_resolve_bracket_wikilink(ctx, lines, n_lines, opener_index, closer_index, opener, closer, next_opener, next_closer, &last_link_beg, &last_link_end, &closer_index)
		if ret < 0 {
			return -1
		}
		if ret > 0 {
			continue
		}
		ret = md_resolve_bracket_link(ctx, lines, n_lines, opener_index, closer_index, opener, closer, next_opener, next_closer, &next_index, &last_link_beg, &last_link_end, &last_img_beg, &last_img_end)
		if ret < 0 {
			return -1
		}
		closer_index = next_index
	}
	return 0
}

// Analyze whether the mark '&' starts a HTML entity.
// *If so, update its flags as well as flags of corresponding closer ';'.

fn md_analyze_entity(ctx &MD_CTX, mark_index i32) {
	opener := unsafe { ctx.marks + mark_index }
	closer := &MD_MARK(0)
	off := Offset(0)
	// Cannot be entity if there is no closer as the next mark.
	//     *(Any other mark between would mean strange character which cannot be
	//     *part of the entity.
	//     *
	//     *So we can do all the work on '&' and do not call this later for the
	//     *closing mark ';'.
	//

	if mark_index + 1 >= ctx.n_marks {
		return
	}
	closer = unsafe { ctx.marks + (mark_index + 1) }
	if i32(closer.ch) != i8(`;`) {
		return
	}
	if md_is_entity(ctx, opener.c2v_anonymous_105093.offsets.beg, closer.c2v_anonymous_105093.offsets.end, &off) {
		for {
			md_assume((off == closer.c2v_anonymous_105093.offsets.end))
			// while()
			break
		}
		md_resolve_range(ctx, mark_index, mark_index + 1)
		opener.c2v_anonymous_105093.offsets.end = closer.c2v_anonymous_105093.offsets.end
	}
}

fn md_analyze_table_cell_boundary(ctx &MD_CTX, mark_index i32) {
	mark := unsafe { ctx.marks + mark_index }
	// FIXME: With MD_FLAG_SPOILERS, we reserve double "||" for spoiler marks
	//     *(potentially inside the table). But is it worth it the incompatibility
	//     *with GFM? Perhaps it would be better to disallow spoilers in a table?

	if (ctx.parser.flags & u32(65536)) && mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(2) {
		return
	}
	mark.flags |= 16
	mark.next = -1
	if ctx.table_cell_boundaries_head < 0 {
		ctx.table_cell_boundaries_head = mark_index
	} else {
		ctx.marks[ctx.table_cell_boundaries_tail].next = mark_index
	}
	ctx.table_cell_boundaries_tail = mark_index
	ctx.n_table_cell_boundaries += mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg
}

// Split a longer mark into two. The new mark takes the given count of
// *characters. May only be called if an adequate number of dummy 'D' marks
// *follows.
//

fn md_split_emph_mark(ctx &MD_CTX, mark_index i32, n Size) i32 {
	mark := unsafe { ctx.marks + mark_index }
	new_mark_index := i32(u32(mark_index) + (mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg - n))
	dummy := unsafe { ctx.marks + new_mark_index }
	for {
		md_assume((mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg > n))
		// while()
		break
	}
	for {
		md_assume((i32(dummy.ch) == i8(`D`)))
		// while()
		break
	}
	C.memcpy(voidptr(dummy), voidptr(mark), sizeof(MD_MARK))
	mark.c2v_anonymous_105093.offsets.end -= n
	dummy.c2v_anonymous_105093.offsets.beg = mark.c2v_anonymous_105093.offsets.end
	return new_mark_index
}

fn md_analyze_emph(ctx &MD_CTX, mark_index i32) {
	mark := unsafe { ctx.marks + mark_index }
	// If we can be a closer, try to resolve with the preceding opener.

	if i32(mark.flags) & 2 {
		opener := unsafe { &MD_MARK(nil) }
		opener_index := i32(0)
		opener_stacks := [6]&MD_MARKSTACK{}
		i := i32(0)
		n_opener_stacks := i32(0)

		flags := u32(mark.flags)
		n_opener_stacks = 0
		// Apply the rule of 3

		opener_stacks[n_opener_stacks++] = md_emph_stack(ctx, mark.ch, u32(64 | 32))
		if (flags & u32((64 | 128))) != u32((64 | 128)) {
			opener_stacks[n_opener_stacks++] = md_emph_stack(ctx, mark.ch, u32(128 | 32))
		}
		if (flags & u32((64 | 128))) != u32(128) {
			opener_stacks[n_opener_stacks++] = md_emph_stack(ctx, mark.ch, u32((64 | 128) | 32))
		}
		opener_stacks[n_opener_stacks++] = md_emph_stack(ctx, mark.ch, u32(64))
		if !(flags & u32(32)) || (flags & u32((64 | 128))) != u32((64 | 128)) {
			opener_stacks[n_opener_stacks++] = md_emph_stack(ctx, mark.ch, u32(128))
		}
		if !(flags & u32(32)) || (flags & u32((64 | 128))) != u32(128) {
			opener_stacks[n_opener_stacks++] = md_emph_stack(ctx, mark.ch, u32((64 | 128)))
		}
		// Opener is the most recent mark from the allowed stacks.

		for i = 0; i < n_opener_stacks; i++ {
			if opener_stacks[i].top >= 0 {
				m_index := opener_stacks[i].top
				m := unsafe { ctx.marks + m_index }
				if uint(opener) == uint((voidptr(0))) || m.c2v_anonymous_105093.offsets.end > opener.c2v_anonymous_105093.offsets.end {
					opener_index = m_index
					opener = m
				}
			}
		}
		// Resolve, if we have found matching opener.

		if uint(opener) != uint((voidptr(0))) {
			opener_size := opener.c2v_anonymous_105093.offsets.end - opener.c2v_anonymous_105093.offsets.beg
			closer_size := mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg
			stack := md_opener_stack(ctx, opener_index)
			if opener_size > closer_size {
				opener_index = md_split_emph_mark(ctx, opener_index, closer_size)
				md_mark_stack_push(ctx, stack, opener_index)
			} else if opener_size < closer_size {
				md_split_emph_mark(ctx, mark_index, closer_size - opener_size)
			}
			md_pop_openers(ctx, opener_index)
			md_resolve_range(ctx, opener_index, mark_index)
			return
		}
	}
	// If we could not resolve as closer, we may be yet be an opener.

	if i32(mark.flags) & 1 {
		md_mark_stack_push(ctx, md_emph_stack(ctx, mark.ch, u32(mark.flags)), mark_index)
	}
}

fn md_analyze_generic(ctx &MD_CTX, mark_index i32) {
	mark := unsafe { ctx.marks + mark_index }
	stack := md_opener_stack(ctx, mark_index)
	if (i32(mark.flags) & 2) && stack.top >= 0 {
		opener_index := stack.top
		md_pop_openers(ctx, opener_index)
		md_resolve_range(ctx, opener_index, mark_index)
		return
	}
	if i32(mark.flags) & 1 {
		md_mark_stack_push(ctx, stack, mark_index)
	}
}

fn md_analyze_dollar(ctx &MD_CTX, mark_index i32) {
	mark := unsafe { ctx.marks + mark_index }
	if (i32(mark.flags) & 2) && ctx.opener_stacks[15].top >= 0 {
		// If the potential closer has a non-matching number of $, discard

		opener := unsafe { ctx.marks + ctx.opener_stacks[15].top }
		opener_index := ctx.opener_stacks[15].top
		closer := mark
		closer_index := mark_index
		if opener.c2v_anonymous_105093.offsets.end - opener.c2v_anonymous_105093.offsets.beg == closer.c2v_anonymous_105093.offsets.end - closer.c2v_anonymous_105093.offsets.beg {
			// We are the matching closer

			md_pop_openers(ctx, opener_index)
			md_disable_marks(ctx, opener_index + 1, closer_index)
			md_resolve_range(ctx, opener_index, closer_index)
			// Discard all pending openers: Latex math span do not allow
			//             *nesting.

			ctx.opener_stacks[15].top = -1
			return
		}
	}
	if i32(mark.flags) & 1 {
		md_mark_stack_push(ctx, unsafe { &ctx.opener_stacks[0] + 15 }, mark_index)
	}
}

fn md_scan_left_for_resolved_mark(ctx &MD_CTX, mark_from &MD_MARK, off Offset, p_cursor &&MD_MARK) &MD_MARK {
	mark := &MD_MARK(0)
	for mark = mark_from; uint(mark) >= uint(ctx.marks); mark = unsafe { mark - 1 } {
		if i32(mark.ch) == i8(`D`) || mark.c2v_anonymous_105093.offsets.beg > off {
			continue
		}
		if mark.c2v_anonymous_105093.offsets.beg <= off && off < mark.c2v_anonymous_105093.offsets.end && (i32(mark.flags) & 16) {
			if uint(p_cursor) != uint((voidptr(0))) {
				unsafe { *p_cursor = mark }
			}
			return mark
		}
		if mark.c2v_anonymous_105093.offsets.end <= off {
			break
		}
	}
	if uint(p_cursor) != uint((voidptr(0))) {
		unsafe { *p_cursor = mark }
	}
	return unsafe { nil }
}

fn md_scan_right_for_resolved_mark(ctx &MD_CTX, mark_from &MD_MARK, off Offset, p_cursor &&MD_MARK) &MD_MARK {
	mark := &MD_MARK(0)
	for mark = mark_from; uint(mark) < uint(ctx.marks + ctx.n_marks); mark = unsafe { mark + 1 } {
		if i32(mark.ch) == i8(`D`) || mark.c2v_anonymous_105093.offsets.end <= off {
			continue
		}
		if mark.c2v_anonymous_105093.offsets.beg <= off && off < mark.c2v_anonymous_105093.offsets.end && (i32(mark.flags) & 16) {
			if uint(p_cursor) != uint((voidptr(0))) {
				unsafe { *p_cursor = mark }
			}
			return mark
		}
		if mark.c2v_anonymous_105093.offsets.beg > off {
			break
		}
	}
	if uint(p_cursor) != uint((voidptr(0))) {
		unsafe { *p_cursor = mark }
	}
	return unsafe { nil }
}

fn md_analyze_permissive_autolink_segment(ctx &MD_CTX, off Offset, end Offset, p_end &Offset, scan_backwards i32, component_delim Char, word_extra &Char, word_delims &Char, p_cursor &&MD_MARK) i32 {
	n_components := i32(0)
	n_open_brackets := i32(0)
	seen_word_delim := (1 != 0)
	seen_component_delim := (1 != 0)
	component_beg := off
	if uint(word_extra) == uint((voidptr(0))) {
		word_extra = c''
	}
	if uint(word_delims) == uint((voidptr(0))) {
		word_delims = c''
	}
	for off != end {
		if scan_backwards {
			off--
		}
		// Only accept extra and delimiter characters if they're not part of a
		//         *resolved mark.

		mut __c2v_condition_53 := false
		mut __c2v_condition_54 := false
		__c2v_condition_54 = !(((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`)))
		if __c2v_condition_54 {
			__c2v_condition_54 = !((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`)))
		}
		__c2v_condition_53 = __c2v_condition_54
		if __c2v_condition_53 {
			mut __c2v_condition_55 := false
			mut __c2v_condition_56 := false
			__c2v_condition_56 = (!scan_backwards && uint(md_scan_right_for_resolved_mark(ctx, (unsafe { *p_cursor }), off, p_cursor)) != uint((voidptr(0))))
			__c2v_condition_55 = __c2v_condition_56
			if !__c2v_condition_55 {
				mut __c2v_condition_57 := false
				__c2v_condition_57 = (scan_backwards && uint(md_scan_left_for_resolved_mark(ctx, (unsafe { *p_cursor }), off, p_cursor)) != uint((voidptr(0))))
				__c2v_condition_55 = __c2v_condition_57
			}
			if __c2v_condition_55 {
				if scan_backwards {
					off++
				}
				break
			}
		}
		// The autolink can be _inside_ brackets so we disallow unbalanced bracket pairs in the URL.
		//         *(Note the brackets are not allowed in e-mail username, so we happily skip this in that case.)

		if !scan_backwards {
			if i32(ctx.text[off]) == i8(`(`) {
				n_open_brackets++
			} else if i32(ctx.text[off]) == i8(`)`) {
				if n_open_brackets <= 0 {
					break
				}
				n_open_brackets--
			}
		}
		mut __c2v_condition_58 := false
		mut __c2v_condition_59 := false
		__c2v_condition_59 = (((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`)))
		__c2v_condition_58 = __c2v_condition_59
		if !__c2v_condition_58 {
			mut __c2v_condition_60 := false
			__c2v_condition_60 = (i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(word_extra, i32(ctx.text[off]))) != uint((voidptr(0))))
			__c2v_condition_58 = __c2v_condition_60
		}
		if __c2v_condition_58 {
			seen_word_delim = (0 != 0)
			seen_component_delim = (0 != 0)
		} else {
			if seen_word_delim {
				break
			}
			if (i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(word_delims, i32(ctx.text[off]))) != uint((voidptr(0)))) {
				seen_word_delim = (1 != 0)
			} else if i32(component_delim) != i8(`\0`) && i32(ctx.text[off]) == i32(component_delim) {
				if seen_component_delim {
					break
				}
				seen_component_delim = (1 != 0)
				component_beg = off
				n_components++
			} else {
				if scan_backwards {
					off++
				}
				break
			}
		}
		if !scan_backwards {
			off++
		}
	}
	// Rollback falsely consumed delimiter.

	if off != component_beg && (i32(seen_word_delim) || i32(seen_component_delim)) {
		off = (if scan_backwards { off + Offset(1) } else { off - Offset(1) })
	}
	if off != component_beg {
		n_components++
	}
	if n_open_brackets != 0 {
		return -1
	}
	unsafe { *p_end = off }
	return n_components
}

fn md_analyze_permissive_autolink(ctx &MD_CTX, mark_index i32) {
	opener := unsafe { ctx.marks + mark_index }
	closer := unsafe { ctx.marks + (mark_index + 1) }
	// The dummy.

	line_beg := closer.c2v_anonymous_105093.offsets.beg
	// md_collect_mark() sets this for us

	line_end := closer.c2v_anonymous_105093.offsets.end
	// ditto

	beg := opener.c2v_anonymous_105093.offsets.beg
	end := opener.c2v_anonymous_105093.offsets.end
	left_cursor := opener
	right_cursor := opener
	tail_trimmed := (0 != 0)
	for {
		md_assume((i32(closer.ch) == i8(`D`)))
		// while()
		break
	}
	// E-mail requires the user name (before '@', i.e. scanning backwards).

	if i32(opener.ch) == i8(`@`) {
		for {
			md_assume((i32(ctx.text[opener.c2v_anonymous_105093.offsets.beg]) == i8(`@`)))
			// while()
			break
		}
		if md_analyze_permissive_autolink_segment(ctx, beg, line_beg, &beg, 1, Char(`\0`), (voidptr(0)), c'.-_+', &&MD_MARK(&&MD_MARK(c2v_address_of(&left_cursor)))) < 1 {
			return
		}
		// Swallow optional "mailto:" or "xmpp:" before it.

		if beg >= Offset(7) && md_ascii_eq(c'mailto:', (ctx.text + (beg - Offset(7))), Size(7)) {
			beg -= Offset(7)
		} else if beg >= Offset(5) && md_ascii_eq(c'xmpp:', (ctx.text + (beg - Offset(5))), Size(5)) {
			beg -= Offset(5)
		} else {
			opener.flags |= 64
		}
	}
	// Verify there's line boundary, whitespace, allowed punctuation or
	//     *resolved opener mark just before the suspected autolink.

	mut __c2v_condition_61 := false
	mut __c2v_condition_62 := false
	__c2v_condition_62 = beg > line_beg
	if __c2v_condition_62 {
		__c2v_condition_62 = !md_is_unicode_whitespace__(md_decode_utf8_before__(ctx, beg))
	}
	if __c2v_condition_62 {
		__c2v_condition_62 = !(i32(ctx.text[(beg - Offset(1))]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'({['[0]) }, i32(ctx.text[(beg - Offset(1))]))) != uint((voidptr(0))))
	}
	__c2v_condition_61 = __c2v_condition_62
	if __c2v_condition_61 {
		mark := &MD_MARK(0)
		mark = md_scan_left_for_resolved_mark(ctx, left_cursor, beg - Offset(1), &&MD_MARK(&&MD_MARK(c2v_address_of(&left_cursor))))
		if uint(mark) == uint((voidptr(0))) || !(i32(mark.flags) & 4) {
			return
		}
	}
	// Scan for hostname segment. Hostname is mandatory. With an explicit scheme
	//     *a single component is enough (e.g. "http://localhost"); WWW and e-mail
	//     *autolinks require at least two components delimited with a dot.

	if md_analyze_permissive_autolink_segment(ctx, end, line_end, &end, 0, Char(`.`), (voidptr(0)), c'-_', &&MD_MARK(&&MD_MARK(c2v_address_of(&right_cursor)))) < (if i32(opener.ch) == i8(`:`) {
		1
	} else {
		2
	}) {
		return
	}
	if i32(opener.ch) != i8(`@`) {
		// Scan for optional port number.

		if end + Offset(1) < line_end && i32(ctx.text[end]) == i8(`:`) && (u32(`0`) <= u32(ctx.text[(end + Offset(1))]) && u32(ctx.text[(end + Offset(1))]) <= u32(`9`)) {
			end += Offset(2)
			for end < line_end && (u32(`0`) <= u32(ctx.text[end]) && u32(ctx.text[end]) <= u32(`9`)) {
				end++
			}
		}
	}
	// Abort the scan early if possible
	//     *(https://github.com/mity/md4c/issues/464)

	if end < ctx.permissive_autolink_tail_horizon {
		return
	}
	if i32(opener.ch) != i8(`@`) && end < line_end && (i32(ctx.text[end]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'/?#'[0]) }, i32(ctx.text[end]))) != uint((voidptr(0)))) {
		tail_beg := end
		off := end
		scan_end := Offset(0)
		n_open_parens := i32(0)
		n_close_parens := i32(0)
		n_open_brackets := i32(0)
		n_close_brackets := i32(0)
		n_open_braces := i32(0)
		n_close_braces := i32(0)
		cursor := &MD_MARK(0)
		// Scan a continuous URL tail, stopping at whitespace or '<'.
		//         *Keep the mark check so URLs cannot cross resolved Markdown syntax.

		for off < line_end {
			char_size := Size(0)
			codepoint := i32(md_decode_unicode(ctx.text, off, ctx.size, &char_size))
			if md_is_unicode_whitespace__(u32(codepoint)) || codepoint == `<` || codepoint < 32 || codepoint == 127 {
				break
			}
			if codepoint >= 128 {
				off += char_size
				continue
			}
			if !(((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`))) {
				mark := md_scan_right_for_resolved_mark(ctx, right_cursor, off, &&MD_MARK(&&MD_MARK(c2v_address_of(&right_cursor))))
				if uint(mark) != uint((voidptr(0))) {
					// An entity reference or a backslash escape is not a span
					//                     *but just a few characters of the URL, the same way as
					//                     *in a standard autolink. Any other resolved mark ends
					//                     *the URL.

					mut __c2v_condition_63 := false
					mut __c2v_condition_64 := false
					__c2v_condition_64 = i32(mark.ch) == i8(`&`)
					__c2v_condition_63 = __c2v_condition_64
					if !__c2v_condition_63 {
						mut __c2v_condition_65 := false
						__c2v_condition_65 = (i32(mark.ch) == i8(`\\`) && !(i32(ctx.text[(mark.c2v_anonymous_105093.offsets.beg + Offset(1))]) == i8(`\r`) || i32(ctx.text[(mark.c2v_anonymous_105093.offsets.beg + Offset(1))]) == i8(`\n`)))
						__c2v_condition_63 = __c2v_condition_65
					}
					if __c2v_condition_63 {
						off = mark.c2v_anonymous_105093.offsets.end
						continue
					}
					break
				}
			}
			match ctx.text[off] {
				`(` { // case comp body kind=UnaryOperator is_enum=true
					n_open_parens++
				}
				`)` { // case comp body kind=UnaryOperator is_enum=true
					n_close_parens++
				}
				`[` { // case comp body kind=UnaryOperator is_enum=true
					n_open_brackets++
				}
				`]` { // case comp body kind=UnaryOperator is_enum=true
					n_close_brackets++
				}
				`{` { // case comp body kind=UnaryOperator is_enum=true
					n_open_braces++
				}
				`}` { // case comp body kind=UnaryOperator is_enum=true
					n_close_braces++
				}
				else {}
			}

			off++
		}
		scan_end = off
		// Exclude terminal punctuation and excess closing brackets from the
		//         *URL as they more likely belong to the surrounding text. (Unmatched
		//         *opening brackets within the URL are valid.)
		//         *
		//         *A trailing entity reference is excluded as a whole and so is
		//         *a backslash escape of the terminal punctuation; we never split
		//         *such marks.

		cursor = right_cursor
		for off > tail_beg {
			mark := md_scan_left_for_resolved_mark(ctx, cursor, off - Offset(1), &&MD_MARK(&&MD_MARK(c2v_address_of(&cursor))))
			is_terminal_punct := ((i32(ctx.text[(off - Offset(1))]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'?!.,:;*_~\'"'[0]) }, i32(ctx.text[(off - Offset(1))]))) != uint((voidptr(0)))) != 0)
			if uint(mark) != uint((voidptr(0))) {
				if i32(mark.ch) == i8(`;`) {
					mark = unsafe { ctx.marks + mark.prev }
				}
				if i32(mark.ch) == i8(`&`) || i32(is_terminal_punct) {
					off = mark.c2v_anonymous_105093.offsets.beg
				} else {
					break
				}
			} else if i32(ctx.text[(off - Offset(1))]) == i8(`)`) && n_close_parens > n_open_parens {
				n_close_parens--
				off--
			} else if i32(ctx.text[(off - Offset(1))]) == i8(`]`) && n_close_brackets > n_open_brackets {
				n_close_brackets--
				off--
			} else if i32(ctx.text[(off - Offset(1))]) == i8(`}`) && n_close_braces > n_open_braces {
				n_close_braces--
				off--
			} else if is_terminal_punct {
				off--
			} else {
				break
			}
		}
		end = off
		tail_trimmed = ((end < scan_end) != 0)
	}
	mut __c2v_condition_66 := false
	mut __c2v_condition_67 := false
	__c2v_condition_67 = !tail_trimmed
	if __c2v_condition_67 {
		__c2v_condition_67 = end < line_end
	}
	if __c2v_condition_67 {
		__c2v_condition_67 = !md_is_unicode_whitespace__(md_decode_utf8__((ctx.text + end), ctx.size - end, (voidptr(0))))
	}
	if __c2v_condition_67 {
		__c2v_condition_67 = !(i32(ctx.text[end]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c')}].!?,;'[0]) }, i32(ctx.text[end]))) != uint((voidptr(0))))
	}
	if __c2v_condition_67 {
		__c2v_condition_67 = !(i32(opener.ch) != i8(`@`) && (i32(ctx.text[end]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c':*_~\'"<'[0]) }, i32(ctx.text[end]))) != uint((voidptr(0)))))
	}
	__c2v_condition_66 = __c2v_condition_67
	if __c2v_condition_66 {
		mark := &MD_MARK(0)
		mark = md_scan_right_for_resolved_mark(ctx, right_cursor, end, &&MD_MARK(&&MD_MARK(c2v_address_of(&right_cursor))))
		if uint(mark) == uint((voidptr(0))) || !(i32(mark.flags) & 8) {
			ctx.permissive_autolink_tail_horizon = end
			return
		}
	}
	opener.c2v_anonymous_105093.offsets.beg = beg
	opener.c2v_anonymous_105093.offsets.end = beg
	closer.c2v_anonymous_105093.offsets.beg = end
	closer.c2v_anonymous_105093.offsets.end = end
	closer.ch = opener.ch
	md_resolve_range(ctx, mark_index, mark_index + 1)
}

fn md_analyze_marks(ctx &MD_CTX, lines &MD_LINE, n_lines Size, mark_beg i32, mark_end i32, mark_chars &Char, noskip_mark_chars &Char) {
	i := mark_beg
	last_end := lines[0].beg

	for i < mark_end {
		mark := unsafe { ctx.marks + i }
		if i32(mark.flags) & 16 {
			if (i32(mark.flags) & 4) && (uint(noskip_mark_chars) == uint((voidptr(0))) || !(i32(mark.ch) != i8(`\0`) && uint(C.strchr(noskip_mark_chars, i32(mark.ch))) != uint((voidptr(0))))) {
				for {
					md_assume((i < mark.next))
					// while()
					break
				}
				i = mark.next + 1
			} else {
				i++
			}
			continue
		}
		if !(i32(mark.ch) != i8(`\0`) && uint(C.strchr(mark_chars, i32(mark.ch))) != uint((voidptr(0)))) {
			i++
			continue
		}
		if mark.c2v_anonymous_105093.offsets.beg < last_end {
			i++
			continue
		}
		match mark.ch {
			`[` { // case comp body kind=NullStmt is_enum=true

				unsafe {
					goto c2v_case_6_2
				}
			}
			`!` { // case comp body kind=NullStmt is_enum=true
				c2v_case_6_2:

				unsafe {
					goto c2v_case_6_4
				}
			}
			`]` { // case comp body kind=CallExpr is_enum=true
				c2v_case_6_4:
				md_analyze_bracket(ctx, i)
			}
			`&` { // case comp body kind=CallExpr is_enum=true
				md_analyze_entity(ctx, i)
			}
			`_` { // case comp body kind=NullStmt is_enum=true

				unsafe {
					goto c2v_case_6_10
				}
			}
			`*` { // case comp body kind=CallExpr is_enum=true
				c2v_case_6_10:
				md_analyze_emph(ctx, i)
			}
			`$` { // case comp body kind=CallExpr is_enum=true
				md_analyze_dollar(ctx, i)
			}
			`.` { // case comp body kind=NullStmt is_enum=true

				unsafe {
					goto c2v_case_6_16
				}
			}
			`:` { // case comp body kind=NullStmt is_enum=true
				c2v_case_6_16:

				unsafe {
					goto c2v_case_6_18
				}
			}
			`@` { // case comp body kind=CallExpr is_enum=true
				c2v_case_6_18:
				md_analyze_permissive_autolink(ctx, i)
			}
			`|` { // case comp body kind=IfStmt is_enum=true
				if mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(2) {
					md_analyze_generic(ctx, i)
				}
			}
			`~` { // case comp body kind=NullStmt is_enum=true

				unsafe {
					goto c2v_case_6_24
				}
			}
			`^` { // case comp body kind=NullStmt is_enum=true
				c2v_case_6_24:

				unsafe {
					goto c2v_case_6_26
				}
			}
			`=` { // case comp body kind=NullStmt is_enum=true
				c2v_case_6_26:

				unsafe {
					goto c2v_case_6_28
				}
			}
			`+` { // case comp body kind=CallExpr is_enum=true
				c2v_case_6_28:
				md_analyze_generic(ctx, i)
			}
			else {}
		}

		if i32(mark.flags) & 16 {
			if i32(mark.flags) & 4 {
				last_end = ctx.marks[mark.next].c2v_anonymous_105093.offsets.end
			} else {
				last_end = mark.c2v_anonymous_105093.offsets.end
			}
		}
		i++
	}
}

fn md_analyze_inlines(ctx &MD_CTX, lines &MD_LINE, n_lines Size, table_mode i32) i32 {
	i := i32(0)
	ret := i32(0)
	ctx.n_marks = 0
	for {
		ret = md_collect_marks(ctx, lines, n_lines, table_mode)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	md_analyze_marks(ctx, lines, n_lines, 0, ctx.n_marks, c'[]!', (voidptr(0)))
	for {
		ret = md_resolve_brackets(ctx, lines, n_lines)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	ctx.opener_stacks[14].top = -1
	ctx.unresolved_link_head = -1
	ctx.unresolved_link_tail = -1
	if table_mode {
		for {
			md_assume((n_lines == Size(1)))
			// while()
			break
		}
		ctx.n_table_cell_boundaries = 0
		for i = 0; i < ctx.n_marks; i++ {
			if !(i32(ctx.marks[i].flags) & 16) && i32(ctx.marks[i].ch) == i8(`|`) {
				md_analyze_table_cell_boundary(ctx, i)
			}
		}
		return ret
	}
	md_analyze_link_contents(ctx, lines, n_lines, 0, ctx.n_marks)
	abort:
	return ret
}

fn md_analyze_link_contents(ctx &MD_CTX, lines &MD_LINE, n_lines Size, mark_beg i32, mark_end i32) {
	i := i32(0)
	emph_mark_types := [16]Char{}
	n_emph_mark_types := Size(0)
	emph_mark_types[n_emph_mark_types++] = Char(`&`)
	emph_mark_types[n_emph_mark_types++] = Char(`*`)
	emph_mark_types[n_emph_mark_types++] = Char(`_`)
	if ctx.parser.flags & u32(4096) {
		emph_mark_types[n_emph_mark_types++] = Char(`$`)
	}
	if ctx.parser.flags & u32(2097152) {
		emph_mark_types[n_emph_mark_types++] = Char(`=`)
	}
	if ctx.parser.flags & u32(8388608) {
		emph_mark_types[n_emph_mark_types++] = Char(`+`)
	}
	if ctx.parser.flags & u32(65536) {
		emph_mark_types[n_emph_mark_types++] = Char(`|`)
	}
	if ctx.parser.flags & u32(131072) {
		emph_mark_types[n_emph_mark_types++] = Char(`^`)
	}
	if (ctx.parser.flags & u32(512)) || (ctx.parser.flags & u32(262144)) {
		emph_mark_types[n_emph_mark_types++] = Char(`~`)
	}
	emph_mark_types[n_emph_mark_types] = Char(`\0`)
	md_analyze_marks(ctx, lines, n_lines, mark_beg, mark_end, unsafe { &emph_mark_types[0] }, (voidptr(0)))
	if ctx.parser.flags & u32((8 | 4 | 1024)) {
		autolink_mark_types := [16]Char{}
		n_autolink_mark_types := Size(0)
		if ctx.parser.flags & u32(8) {
			autolink_mark_types[n_autolink_mark_types++] = Char(`@`)
		}
		if ctx.parser.flags & u32(4) {
			autolink_mark_types[n_autolink_mark_types++] = Char(`:`)
		}
		if ctx.parser.flags & u32(1024) {
			autolink_mark_types[n_autolink_mark_types++] = Char(`.`)
		}
		autolink_mark_types[n_autolink_mark_types] = Char(`\0`)
		md_analyze_marks(ctx, lines, n_lines, mark_beg, mark_end, unsafe { &autolink_mark_types[0] }, unsafe { &emph_mark_types[0] })
	}
	for i = 0; i < 20; i++ {
		ctx.opener_stacks[i].top = -1
	}
}

fn md_enter_leave_span_a(ctx &MD_CTX, enter i32, type_ SpanType, dest &Char, dest_size Size, is_autolink i32, title &Char, title_size Size) i32 {
	href_build := MD_ATTRIBUTE_BUILD{}

	title_build := MD_ATTRIBUTE_BUILD{}

	det := SpanLinkDetail{}
	ret := i32(0)
	C.memset(voidptr(&det), 0, sizeof(SpanLinkDetail))
	for {
		ret = md_build_attribute(ctx, dest, dest_size, u32((if is_autolink { 1 } else { 0 })), &det.href, &href_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_build_attribute(ctx, title, title_size, u32(0), &det.title, &title_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	det.is_autolink = is_autolink
	if enter {
		for {
			ret = ctx.parser.enter_span(type_, voidptr((&det)), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	} else {
		for {
			ret = ctx.parser.leave_span(type_, voidptr((&det)), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	abort:
	md_free_attribute(ctx, &href_build)
	md_free_attribute(ctx, &title_build)
	return ret
}

fn md_enter_leave_span_wikilink(ctx &MD_CTX, enter i32, target &Char, target_size Size) i32 {
	target_build := MD_ATTRIBUTE_BUILD{}

	det := SpanWikiLinkDetail{}
	ret := i32(0)
	C.memset(voidptr(&det), 0, sizeof(SpanWikiLinkDetail))
	for {
		ret = md_build_attribute(ctx, target, target_size, u32(0), &det.target, &target_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	if enter {
		for {
			ret = ctx.parser.enter_span(SpanType(SpanType.wikilink), voidptr((&det)), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	} else {
		for {
			ret = ctx.parser.leave_span(SpanType(SpanType.wikilink), voidptr((&det)), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	abort:
	md_free_attribute(ctx, &target_build)
	return ret
}

fn md_enter_leave_span_footnote_ref(ctx &MD_CTX, id u32, ref_id u32, label &Char, label_size Size) i32 {
	label_build := MD_ATTRIBUTE_BUILD{}

	det := SpanFootnoteRefDetail{}
	ret := i32(0)
	C.memset(voidptr(&det), 0, sizeof(SpanFootnoteRefDetail))
	det.id = id
	det.ref_id = ref_id
	for {
		ret = md_build_attribute(ctx, label, label_size, u32(0), &det.label, &label_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = ctx.parser.enter_span(SpanType(SpanType.footnote_ref), voidptr((&det)), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = ctx.parser.leave_span(SpanType(SpanType.footnote_ref), voidptr((&det)), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	md_free_attribute(ctx, &label_build)
	return ret
}

fn md_process_inlines(ctx &MD_CTX, lines &MD_LINE, n_lines Size) i32 {
	text_type := TextType{}
	line := lines
	mark := &MD_MARK(0)
	off := lines[0].beg
	end := lines[n_lines - Size(1)].end
	tmp := Offset(0)
	enforce_hardbreak := i32(0)
	ret := i32(0)
	mark = ctx.marks
	for !(i32(mark.flags) & 16) {
		c2v_pointer_postfix(voidptr(&mark), mark, int(1))
	}
	text_type = TextType.normal
	for {
		tmp = (if line.end < mark.c2v_anonymous_105093.offsets.beg {
			line.end
		} else {
			mark.c2v_anonymous_105093.offsets.beg
		})
		if tmp > off {
			for {
				if (tmp - off) > Offset(0) {
					ret = ctx.parser.text(text_type, (ctx.text + off), (tmp - off), voidptr(ctx.userdata))
					if ret != 0 {
						for {
							if ctx.parser.debug_log != (voidptr(0)) {
								ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
							}
							// while()
							break
						}
						unsafe {
							goto abort
						}
					}
				}
				// while()
				break
			}
			off = tmp
		}
		if off >= mark.c2v_anonymous_105093.offsets.beg {
			match mark.ch {
				`\\` { // case comp body kind=IfStmt is_enum=true
					if (i32(ctx.text[(mark.c2v_anonymous_105093.offsets.beg + Offset(1))]) == i8(`\r`) || i32(ctx.text[(mark.c2v_anonymous_105093.offsets.beg + Offset(1))]) == i8(`\n`)) {
						enforce_hardbreak = 1
					} else {
						for {
							if 1 > 0 {
								ret = ctx.parser.text(text_type, (ctx.text + (mark.c2v_anonymous_105093.offsets.beg + Offset(1))), Size(1), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
							}
							// while()
							break
						}
					}
				}
				` ` { // case comp body kind=DoStmt is_enum=true
					for {
						if 1 > 0 {
							ret = ctx.parser.text(text_type, unsafe { &c' '[0] }, Size(1), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
						}
						// while()
						break
					}
				}
				`\`` { // case comp body kind=IfStmt is_enum=true
					if i32(mark.flags) & 4 {
						for {
							ret = ctx.parser.enter_span(SpanType(SpanType.code), voidptr((voidptr(0))), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						text_type = TextType.code
					} else {
						for {
							ret = ctx.parser.leave_span(SpanType(SpanType.code), voidptr((voidptr(0))), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						text_type = TextType.normal
					}
				}
				`_` { // case comp body kind=IfStmt is_enum=true
					if ctx.parser.flags & u32(16384) {
						if i32(mark.flags) & 4 {
							for off < mark.c2v_anonymous_105093.offsets.end {
								for {
									ret = ctx.parser.enter_span(SpanType(SpanType.u), voidptr((voidptr(0))), voidptr(ctx.userdata))
									if ret != 0 {
										for {
											if ctx.parser.debug_log != (voidptr(0)) {
												ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
											}
											// while()
											break
										}
										unsafe {
											goto abort
										}
									}
									// while()
									break
								}
								off++
							}
						} else {
							for off < mark.c2v_anonymous_105093.offsets.end {
								for {
									ret = ctx.parser.leave_span(SpanType(SpanType.u), voidptr((voidptr(0))), voidptr(ctx.userdata))
									if ret != 0 {
										for {
											if ctx.parser.debug_log != (voidptr(0)) {
												ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
											}
											// while()
											break
										}
										unsafe {
											goto abort
										}
									}
									// while()
									break
								}
								off++
							}
						}
						unsafe {
							goto c2v_switch_end_7
						}
					}

					unsafe {
						goto c2v_case_7_9
					}
				}
				`*` { // case comp body kind=IfStmt is_enum=true
					c2v_case_7_9:
					if i32(mark.flags) & 4 {
						if (mark.c2v_anonymous_105093.offsets.end - off) % Offset(2) {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.em), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							off++
						}
						for off + Offset(1) < mark.c2v_anonymous_105093.offsets.end {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.strong), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							off += Offset(2)
						}
					} else {
						for off + Offset(1) < mark.c2v_anonymous_105093.offsets.end {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.strong), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							off += Offset(2)
						}
						if (mark.c2v_anonymous_105093.offsets.end - off) % Offset(2) {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.em), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
							off++
						}
					}
				}
				`~` { // case comp body kind=IfStmt is_enum=true
					if mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(1) && (ctx.parser.flags & u32(262144)) {
						if i32(mark.flags) & 4 {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.subscript), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						} else {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.subscript), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						}
					} else {
						if i32(mark.flags) & 4 {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.del), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						} else {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.del), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						}
					}
				}
				`^` { // case comp body kind=IfStmt is_enum=true
					if i32(mark.flags) & 4 {
						for {
							ret = ctx.parser.enter_span(SpanType(SpanType.superscript), voidptr((voidptr(0))), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
					} else {
						for {
							ret = ctx.parser.leave_span(SpanType(SpanType.superscript), voidptr((voidptr(0))), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
					}
				}
				`|` { // case comp body kind=IfStmt is_enum=true
					if mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(2) {
						if i32(mark.flags) & 4 {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.spoiler), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						} else {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.spoiler), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						}
					}
				}
				`=` { // case comp body kind=IfStmt is_enum=true
					if mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(2) {
						if i32(mark.flags) & 4 {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.mark), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						} else {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.mark), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						}
					}
				}
				`+` { // case comp body kind=IfStmt is_enum=true
					if mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg == Offset(2) {
						if i32(mark.flags) & 4 {
							for {
								ret = ctx.parser.enter_span(SpanType(SpanType.ins), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						} else {
							for {
								ret = ctx.parser.leave_span(SpanType(SpanType.ins), voidptr((voidptr(0))), voidptr(ctx.userdata))
								if ret != 0 {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									unsafe {
										goto abort
									}
								}
								// while()
								break
							}
						}
					}
				}
				`$` { // case comp body kind=IfStmt is_enum=true
					if i32(mark.flags) & 4 {
						for {
							ret = ctx.parser.enter_span((if (mark.c2v_anonymous_105093.offsets.end - off) % Offset(2) {
								SpanType.latexmath
							} else {
								SpanType.latexmath_display
							}), voidptr((voidptr(0))), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_span() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						text_type = TextType.latexmath
					} else {
						for {
							ret = ctx.parser.leave_span((if (mark.c2v_anonymous_105093.offsets.end - off) % Offset(2) {
								SpanType.latexmath
							} else {
								SpanType.latexmath_display
							}), voidptr((voidptr(0))), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_span() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						text_type = TextType.normal
					}
				}
				`[`, `!`, `]` {
					opener := (if i32(mark.ch) != i8(`]`) {
						mark
					} else {
						unsafe { ctx.marks + mark.prev }
					})
					closer := unsafe { ctx.marks + opener.next }
					dest_mark := &MD_MARK(0)
					title_mark := &MD_MARK(0)
					if i32(opener.flags) & 128 {
						index_mark := &MD_MARK(opener) + 1
						for {
							md_assume((i32(mark.ch) != i8(`]`)))
							// while()
							break
						}
						for {
							md_assume((i32(index_mark.ch) == i8(`D`)))
							// while()
							break
						}
						for {
							ret = md_enter_leave_span_footnote_ref(ctx, u32(index_mark.c2v_anonymous_105093.offsets.beg), u32(index_mark.c2v_anonymous_105093.offsets.end), (ctx.text + opener.c2v_anonymous_105093.offsets.end), closer.c2v_anonymous_105093.offsets.beg - opener.c2v_anonymous_105093.offsets.end)
							if ret != 0 {
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						mark.c2v_anonymous_105093.offsets.end = closer.c2v_anonymous_105093.offsets.end
						unsafe {
							goto c2v_switch_end_7
						}
					}
					mut __c2v_condition_68 := false
					mut __c2v_condition_69 := false
					__c2v_condition_69 = (i32(opener.ch) == i8(`[`) && i32(closer.ch) == i8(`]`))
					if __c2v_condition_69 {
						__c2v_condition_69 = opener.c2v_anonymous_105093.offsets.end - opener.c2v_anonymous_105093.offsets.beg >= Offset(2)
					}
					if __c2v_condition_69 {
						__c2v_condition_69 = closer.c2v_anonymous_105093.offsets.end - closer.c2v_anonymous_105093.offsets.beg >= Offset(2)
					}
					__c2v_condition_68 = __c2v_condition_69
					if __c2v_condition_68 {
						has_label := i32((opener.c2v_anonymous_105093.offsets.end - opener.c2v_anonymous_105093.offsets.beg > Offset(2)))
						target_sz := Size(0)
						if has_label {
							target_sz = opener.c2v_anonymous_105093.offsets.end - (opener.c2v_anonymous_105093.offsets.beg + Offset(2))
						} else {
							target_sz = closer.c2v_anonymous_105093.offsets.beg - opener.c2v_anonymous_105093.offsets.end
						}
						for {
							ret = md_enter_leave_span_wikilink(ctx, (i32(mark.ch) != i8(`]`)), unsafe {
								if has_label {
									(ctx.text + (opener.c2v_anonymous_105093.offsets.beg + Offset(2)))
								} else {
									(ctx.text + opener.c2v_anonymous_105093.offsets.end)
								}
							}, target_sz)
							if ret != 0 {
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
						unsafe {
							goto c2v_switch_end_7
						}
					}
					dest_mark = opener + 1
					for {
						md_assume((i32(dest_mark.ch) == i8(`D`)))
						// while()
						break
					}
					title_mark = opener + 2
					for {
						md_assume((i32(title_mark.ch) == i8(`D`)))
						// while()
						break
					}
					for {
						ret = md_enter_leave_span_a(ctx, (i32(mark.ch) != i8(`]`)), (if i32(opener.ch) == i8(`!`) {
							SpanType.img
						} else {
							SpanType.a
						}), (ctx.text + dest_mark.c2v_anonymous_105093.offsets.beg), dest_mark.c2v_anonymous_105093.offsets.end - dest_mark.c2v_anonymous_105093.offsets.beg, 0, md_mark_get_ptr(ctx, i32((i64((int(title_mark) - int(ctx.marks)) / int(sizeof(MD_MARK_tag)))))), Size(title_mark.prev))
						if ret != 0 {
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
					// link/image closer may span multiple lines.

					if i32(mark.ch) == i8(`]`) {
						for mark.c2v_anonymous_105093.offsets.end > line.end {
							c2v_pointer_postfix(voidptr(&line), line, int(1))
						}
					}
				}
				`<`, `>` {
					// Autolink or raw HTML.

					if !(i32(mark.flags) & 32) {
						// Raw HTML.

						if i32(mark.flags) & 4 {
							text_type = TextType.html
						} else {
							text_type = TextType.normal
						}
						unsafe {
							goto c2v_switch_end_7
						}
					}
					// Pass through, if auto-link.

					unsafe {
						goto c2v_case_7_27
					}
				}
				`@`, `:`, `.` {
					c2v_case_7_27:
					// Permissive WWW autolink.

					opener_2 := (if (i32(mark.flags) & 4) {
						mark
					} else {
						unsafe { ctx.marks + mark.prev }
					})
					closer_2 := unsafe { ctx.marks + opener_2.next }
					dest := (ctx.text + opener_2.c2v_anonymous_105093.offsets.end)
					dest_size := closer_2.c2v_anonymous_105093.offsets.beg - opener_2.c2v_anonymous_105093.offsets.end
					// For permissive auto-links we do not know closer mark
					//                     *position at the time of md_collect_marks(), therefore
					//                     *it can be out-of-order in ctx->marks[].
					//                     *
					//                     *With this flag, we make sure that we output the closer
					//                     *only if we processed the opener.

					if i32(mark.flags) & 4 {
						closer_2.flags |= 32
					}
					if i32(opener_2.ch) == i8(`.`) || ((i32(opener_2.ch) == i8(`@`) || i32(opener_2.ch) == i8(`<`)) && (i32(opener_2.flags) & 64)) {
						dest_size += Size(7)
						for {
							if (dest_size * sizeof(Char)) > ctx.alloc_buffer {
								new_buffer := &Char(0)
								new_size := Size(((dest_size * sizeof(Char)) + (dest_size * sizeof(Char)) / 2 + 128) & ~127)
								new_buffer = C.realloc(voidptr(ctx.buffer), new_size)
								if uint(new_buffer) == uint((voidptr(0))) {
									for {
										if ctx.parser.debug_log != (voidptr(0)) {
											ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
										}
										// while()
										break
									}
									ret = -1
									unsafe {
										goto abort
									}
								}
								ctx.buffer = new_buffer
								ctx.alloc_buffer = new_size
							}
							// while()
							break
						}
						C.memcpy(voidptr(ctx.buffer), voidptr((if i32(opener_2.ch) == i8(`.`) {
							c'http://'
						} else {
							c'mailto:'
						})), 7 * sizeof(Char))
						C.memcpy(voidptr(ctx.buffer + 7), voidptr(dest), (dest_size - Size(7)) * sizeof(Char))
						dest = ctx.buffer
					}
					if i32(closer_2.flags) & 32 {
						for {
							ret = md_enter_leave_span_a(ctx, (i32(mark.flags) & 4), SpanType(SpanType.a), dest, dest_size, 1, (voidptr(0)), Size(0))
							if ret != 0 {
								unsafe {
									goto abort
								}
							}
							// while()
							break
						}
					}
				}
				`&` { // case comp body kind=DoStmt is_enum=true
					// Entity.

					for {
						if (mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg) > Offset(0) {
							ret = ctx.parser.text(TextType(TextType.entity), (ctx.text + mark.c2v_anonymous_105093.offsets.beg), (mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
						}
						// while()
						break
					}
				}
				`\0` { // case comp body kind=DoStmt is_enum=true
					for {
						if 1 > 0 {
							ret = ctx.parser.text(TextType(TextType.nullchar), unsafe { &c''[0] }, Size(1), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
						}
						// while()
						break
					}
				}
				127 { // case comp body kind=GotoStmt is_enum=true
					unsafe {
						goto abort
					}
				}
				else {}
			}
			c2v_switch_end_7:

			off = mark.c2v_anonymous_105093.offsets.end
			// Move to next resolved mark.

			c2v_pointer_postfix(voidptr(&mark), mark, int(1))
			for !(i32(mark.flags) & 16) || mark.c2v_anonymous_105093.offsets.beg < off {
				c2v_pointer_postfix(voidptr(&mark), mark, int(1))
			}
		}
		// If reached end of line, move to next one.

		if off >= line.end {
			// If it is the last line, we are done.

			if off >= end {
				break
			}
			if i32(text_type) == TextType.code || i32(text_type) == TextType.latexmath {
				for {
					md_assume(((i32(mark.ch) == i8(`\``) || i32(mark.ch) == i8(`$`)) && (i32(mark.flags) & 8)))
					// while()
					break
				}
				// Inside a code span, trailing line whitespace has to be
				//                 *outputted.

				tmp = off
				for off < ctx.size && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
					off++
				}
				if off > tmp {
					for {
						if (off - tmp) > Offset(0) {
							ret = ctx.parser.text(text_type, (ctx.text + tmp), (off - tmp), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
						}
						// while()
						break
					}
				}
				// and new lines are transformed into single spaces. Emit the
				//                 *space when off rests on an interior newline still preceding
				//                 *the closer. Testing off == line->end here instead drops the
				//                 *space when the line ends in whitespace, because the loop
				//                 *above advances off past line->end over the trailing blanks
				//                 *(CommonMark code-span examples 335, 337, 640).

				if off < mark.c2v_anonymous_105093.offsets.beg && (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
					for {
						if 1 > 0 {
							ret = ctx.parser.text(text_type, unsafe { &c' '[0] }, Size(1), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
						}
						// while()
						break
					}
				}
			} else if i32(text_type) == TextType.html {
				// Inside raw HTML, we output the new line verbatim, including
				//                 *any trailing spaces.

				tmp = off
				for tmp < end && (i32(ctx.text[tmp]) == i8(` `) || i32(ctx.text[tmp]) == i8(`\t`)) {
					tmp++
				}
				if tmp > off {
					for {
						if (tmp - off) > Offset(0) {
							ret = ctx.parser.text(TextType(TextType.html), (ctx.text + off), (tmp - off), voidptr(ctx.userdata))
							if ret != 0 {
								for {
									if ctx.parser.debug_log != (voidptr(0)) {
										ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
									}
									// while()
									break
								}
								unsafe {
									goto abort
								}
							}
						}
						// while()
						break
					}
				}
				for {
					if 1 > 0 {
						ret = ctx.parser.text(TextType(TextType.html), unsafe { &c'\n'[0] }, Size(1), voidptr(ctx.userdata))
						if ret != 0 {
							for {
								if ctx.parser.debug_log != (voidptr(0)) {
									ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
								}
								// while()
								break
							}
							unsafe {
								goto abort
							}
						}
					}
					// while()
					break
				}
			} else {
				// Output soft or hard line break.

				break_type := TextType.softbr
				if i32(text_type) == TextType.normal {
					if enforce_hardbreak || (ctx.parser.flags & u32(32768)) {
						break_type = TextType.br
					} else {
						for off < ctx.size && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
							off++
						}
						mut __c2v_condition_70 := false
						mut __c2v_condition_71 := false
						__c2v_condition_71 = off >= line.end + Offset(2)
						if __c2v_condition_71 {
							__c2v_condition_71 = i32(ctx.text[(off - Offset(2))]) == i8(` `)
						}
						if __c2v_condition_71 {
							__c2v_condition_71 = i32(ctx.text[(off - Offset(1))]) == i8(` `)
						}
						if __c2v_condition_71 {
							__c2v_condition_71 = (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`))
						}
						__c2v_condition_70 = __c2v_condition_71
						if __c2v_condition_70 {
							break_type = TextType.br
						}
					}
				}
				for {
					if 1 > 0 {
						ret = ctx.parser.text(break_type, unsafe { &c'\n'[0] }, Size(1), voidptr(ctx.userdata))
						if ret != 0 {
							for {
								if ctx.parser.debug_log != (voidptr(0)) {
									ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
								}
								// while()
								break
							}
							unsafe {
								goto abort
							}
						}
					}
					// while()
					break
				}
			}
			// Move to the next line.

			c2v_pointer_postfix(voidptr(&line), line, int(1))
			off = (if off > line.beg { off } else { line.beg })
			enforce_hardbreak = 0
		}
	}
	abort:
	return ret
}

//*************
// ** Processing Tables  **
// *************

fn md_analyze_table_alignment(ctx &MD_CTX, beg Offset, end Offset, align &Align, n_align i32) {
	off := beg
	for n_align > 0 {
		index := i32(0)
		// index into align_map[]

		for off < end && i32(ctx.text[off]) != i8(`-`) {
			off++
		}
		if off > beg && i32(ctx.text[(off - Offset(1))]) == i8(`:`) {
			index |= 1
		}
		for off < end && i32(ctx.text[off]) == i8(`-`) {
			off++
		}
		if off < end && i32(ctx.text[off]) == i8(`:`) {
			index |= 2
		}
		unsafe { *align = md_analyze_table_alignment_align_map[index] }
		c2v_pointer_postfix(voidptr(&align), align, int(1))
		n_align--
	}
}

// Forward declaration.

fn md_process_table_cell(ctx &MD_CTX, cell_type BlockType, align Align, beg Offset, end Offset) i32 {
	line := MD_LINE{}
	det := BlockCellDetail{}
	ret := i32(0)
	for beg < end && ((i32(ctx.text[beg]) == i8(` `) || i32(ctx.text[beg]) == i8(`\t`)) || (i32(ctx.text[beg]) == i8(`\v`) || i32(ctx.text[beg]) == i8(`\f`))) {
		beg++
	}
	for end > beg && ((i32(ctx.text[(end - Offset(1))]) == i8(` `) || i32(ctx.text[(end - Offset(1))]) == i8(`\t`)) || (i32(ctx.text[(end - Offset(1))]) == i8(`\v`) || i32(ctx.text[(end - Offset(1))]) == i8(`\f`))) {
		end--
	}
	det.align = align
	line.beg = beg
	line.end = end
	for {
		ret = ctx.parser.enter_block(cell_type, voidptr((&det)), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_process_normal_block_contents(ctx, &line, Size(1))
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = ctx.parser.leave_block(cell_type, voidptr((&det)), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	return ret
}

fn md_process_table_row(ctx &MD_CTX, cell_type BlockType, beg Offset, end Offset, align &Align, col_count i32) i32 {
	line := MD_LINE{}
	cell_begs := unsafe { &Offset(nil) }
	i := i32(0)
	j := i32(0)
	k := i32(0)
	n := i32(0)

	ret := i32(0)
	mark := unsafe { &MD_MARK(nil) }
	line.beg = beg
	line.end = end
	// Break the line into table cells by identifying pipe characters who
	//     *form the cell boundary.

	for {
		ret = md_analyze_inlines(ctx, &line, Size(1), 1)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	// We have to remember the cell boundaries in local buffer because
	//     *ctx->marks[] shall be reused during cell contents processing.

	n = ctx.n_table_cell_boundaries + 2
	cell_begs = &Offset(C.malloc(n * sizeof(Offset)))
	if uint(cell_begs) == uint((voidptr(0))) {
		for {
			if ctx.parser.debug_log != (voidptr(0)) {
				ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
			}
			// while()
			break
		}
		ret = -1
		unsafe {
			goto abort
		}
	}
	j = 0
	// First cell of the row may or may not be started with '|'.

	if ctx.table_cell_boundaries_head < 0 || ctx.marks[ctx.table_cell_boundaries_head].c2v_anonymous_105093.offsets.beg > beg {
		cell_begs[j++] = beg
	}
	for i = ctx.table_cell_boundaries_head; i >= 0; i = ctx.marks[i].next {
		mark = unsafe { ctx.marks + i }
		for k = 0; k < i32((mark.c2v_anonymous_105093.offsets.end - mark.c2v_anonymous_105093.offsets.beg)); k++ {
			cell_begs[j++] = mark.c2v_anonymous_105093.offsets.beg + Offset(k) + Offset(1)
		}
	}
	if uint(mark) == uint((voidptr(0))) || mark.c2v_anonymous_105093.offsets.end < end {
		cell_begs[j++] = end + Offset(1)
	}
	// Process cells.

	for {
		ret = ctx.parser.enter_block(BlockType(BlockType.tr), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for i = 0; i < j - 1 && i < col_count; i++ {
		for {
			ret = md_process_table_cell(ctx, cell_type, align[i], cell_begs[i], cell_begs[i + 1] - Offset(1))
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// Make sure we report enough table cells even if the current table contains
	//     *too few of them.

	for i < col_count {
		for {
			ret = md_process_table_cell(ctx, cell_type, align[i++], Offset(0), Offset(0))
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	for {
		ret = ctx.parser.leave_block(BlockType(BlockType.tr), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	C.free(voidptr(cell_begs))
	ctx.table_cell_boundaries_head = -1
	ctx.table_cell_boundaries_tail = -1
	return ret
}

fn md_process_table_block_contents(ctx &MD_CTX, col_count i32, lines &MD_LINE, n_lines Size) i32 {
	align := &Align(0)
	line_index := Size(0)
	ret := i32(0)
	// At least two lines have to be present: The column headers and the line
	//     *with the underlines.

	for {
		md_assume((n_lines >= Size(2)))
		// while()
		break
	}
	align = C.malloc(col_count * sizeof(Align))
	if uint(align) == uint((voidptr(0))) {
		for {
			if ctx.parser.debug_log != (voidptr(0)) {
				ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
			}
			// while()
			break
		}
		ret = -1
		unsafe {
			goto abort
		}
	}
	md_analyze_table_alignment(ctx, lines[1].beg, lines[1].end, align, col_count)
	for {
		ret = ctx.parser.enter_block(BlockType(BlockType.thead), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_process_table_row(ctx, BlockType(BlockType.th), lines[0].beg, lines[0].end, align, col_count)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = ctx.parser.leave_block(BlockType(BlockType.thead), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	if n_lines > Size(2) {
		for {
			ret = ctx.parser.enter_block(BlockType(BlockType.tbody), voidptr((voidptr(0))), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		for line_index = Size(2); line_index < n_lines; line_index++ {
			for {
				ret = md_process_table_row(ctx, BlockType(BlockType.td), lines[line_index].beg, lines[line_index].end, align, col_count)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
		}
		for {
			ret = ctx.parser.leave_block(BlockType(BlockType.tbody), voidptr((voidptr(0))), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	abort:
	C.free(voidptr(align))
	return ret
}

//*************
// ** Processing Block  **
// *************/
//
//#define MD_BLOCK_CONTAINER_OPENER   0x01
//#define MD_BLOCK_CONTAINER_CLOSER   0x02
//#define MD_BLOCK_CONTAINER          (MD_BLOCK_CONTAINER_OPENER | MD_BLOCK_CONTAINER_CLOSER)
//#define MD_BLOCK_LOOSE_LIST         0x04
//#define MD_BLOCK_SETEXT_HEADER      0x08
//
// struct MD_BLOCK_tag {
//    BlockType type  :  8;
//    unsigned flags     :  8;
//
//    /*MD_BLOCK_H:      Header level (1 - 6)
//     *MD_BLOCK_CODE:   Non-zero if fenced, zero if indented.
//     *MD_BLOCK_LI:     Task mark character (0 if not task list item, 'x', 'X' or ' ').
//     *MD_BLOCK_TABLE:  Column count (as determined by the table underline).
//     *MD_BLOCK_ADMONITION: Admonition type.
//

struct MD_BLOCK_tag {
	type_ BlockType
	flags u32
	data  u32
	// Leaf blocks:     Count of lines (MD_LINE or MD_VERBATIMLINE) on the block.
	//     *MD_BLOCK_LI:     Task mark offset in the input doc.
	//     *MD_BLOCK_OL:     Start item number.
	//
	n_lines Size
}

struct MD_CONTAINER_tag {
	ch                Char
	is_loose          u32
	is_task           u32
	is_admonition     u32
	admonition_type   u32
	start             u32
	mark_indent       u32
	contents_indent   u32
	block_byte_off    Offset
	li_block_byte_end i32
	// Byte after the current MD_BLOCK_LI opener.
	li_has_content u32
	task_mark_off  Offset
}

fn md_process_normal_block_contents(ctx &MD_CTX, lines &MD_LINE, n_lines Size) i32 {
	i := i32(0)
	ret := i32(0)
	for {
		ret = md_analyze_inlines(ctx, lines, n_lines, 0)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_process_inlines(ctx, lines, n_lines)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	// Free any temporary memory blocks stored within some dummy marks.

	for i = ctx.ptr_stack.top; i >= 0; i = ctx.marks[i].next {
		C.free(voidptr(md_mark_get_ptr(ctx, i)))
	}
	ctx.ptr_stack.top = -1
	return ret
}

fn md_process_verbatim_block_contents(ctx &MD_CTX, text_type TextType, lines &MD_VERBATIMLINE, n_lines Size) i32 {
	static indent_chunk_size := 16
	line_index := Size(0)
	ret := i32(0)
	for line_index = Size(0); line_index < n_lines; line_index++ {
		line := unsafe { lines + line_index }
		indent := i32(line.indent)
		for {
			md_assume((indent >= 0))
			// while()
			break
		}
		// Output code indentation.

		for indent > i32(indent_chunk_size) {
			for {
				if indent_chunk_size > Size(0) {
					ret = ctx.parser.text(text_type, &md_process_verbatim_block_contents_indent_chunk_str[0], indent_chunk_size, voidptr(ctx.userdata))
					if ret != 0 {
						for {
							if ctx.parser.debug_log != (voidptr(0)) {
								ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
							}
							// while()
							break
						}
						unsafe {
							goto abort
						}
					}
				}
				// while()
				break
			}
			indent -= indent_chunk_size
		}
		if indent > 0 {
			for {
				if indent > 0 {
					ret = ctx.parser.text(text_type, &md_process_verbatim_block_contents_indent_chunk_str[0], Size(indent), voidptr(ctx.userdata))
					if ret != 0 {
						for {
							if ctx.parser.debug_log != (voidptr(0)) {
								ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
							}
							// while()
							break
						}
						unsafe {
							goto abort
						}
					}
				}
				// while()
				break
			}
		}
		// Output the code line itself.

		for {
			if (line.end - line.beg) > Offset(0) {
				ret = with_null_replacement(ctx, text_type, (ctx.text + line.beg), line.end - line.beg)
				if ret != 0 {
					for {
						if ctx.parser.debug_log != (voidptr(0)) {
							ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
						}
						// while()
						break
					}
					unsafe {
						goto abort
					}
				}
			}
			// while()
			break
		}
		// Enforce end-of-line.

		for {
			if 1 > 0 {
				ret = ctx.parser.text(text_type, unsafe { &c'\n'[0] }, Size(1), voidptr(ctx.userdata))
				if ret != 0 {
					for {
						if ctx.parser.debug_log != (voidptr(0)) {
							ctx.parser.debug_log(unsafe { &i8(&c'Aborted from text() callback.'[0]) }, voidptr(ctx.userdata))
						}
						// while()
						break
					}
					unsafe {
						goto abort
					}
				}
			}
			// while()
			break
		}
	}
	abort:
	return ret
}

fn md_is_verbatim_line_blank(ctx &MD_CTX, line &MD_VERBATIMLINE) i32 {
	off := line.beg
	for off < line.end && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
		off++
	}
	return i32((off == line.end))
}

fn md_process_code_block_contents(ctx &MD_CTX, is_fenced i32, lines &MD_VERBATIMLINE, n_lines Size) i32 {
	if is_fenced {
		// Skip the first line in case of fenced code: It is the fence.
		//         *(Only the starting fence is present due to logic in md_analyze_line().)

		c2v_pointer_postfix(voidptr(&lines), lines, int(1))
		n_lines--
	} else {
		// Ignore blank lines at start/end of indented code block.

		for n_lines > Size(0) && md_is_verbatim_line_blank(ctx, unsafe { lines + 0 }) {
			c2v_pointer_postfix(voidptr(&lines), lines, int(1))
			n_lines--
		}
		for n_lines > Size(0) && md_is_verbatim_line_blank(ctx, unsafe { lines + (n_lines - Size(1)) }) {
			n_lines--
		}
	}
	if n_lines == Size(0) {
		return 0
	}
	return md_process_verbatim_block_contents(ctx, TextType(TextType.code), lines, n_lines)
}

fn md_setup_fenced_code_detail(ctx &MD_CTX, block &MD_BLOCK, det &BlockCodeDetail, info_build &MD_ATTRIBUTE_BUILD, lang_build &MD_ATTRIBUTE_BUILD) i32 {
	fence_line := &MD_VERBATIMLINE(voidptr((block + 1)))
	beg := fence_line.beg
	end := fence_line.end
	lang_end := Offset(0)
	fence_ch := ctx.text[fence_line.beg]
	ret := i32(0)
	// Skip the fence itself.

	for beg < ctx.size && i32(ctx.text[beg]) == i32(fence_ch) {
		beg++
	}
	// Trim initial spaces.

	for beg < ctx.size && i32(ctx.text[beg]) == i8(` `) {
		beg++
	}
	// Trim trailing spaces.

	for end > beg && i32(ctx.text[(end - Offset(1))]) == i8(` `) {
		end--
	}
	// Build info string attribute.

	for {
		ret = md_build_attribute(ctx, (ctx.text + beg), end - beg, u32(0), &det.info, info_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	// Build info string attribute.

	lang_end = beg
	for lang_end < end && !((i32(ctx.text[lang_end]) == i8(` `) || i32(ctx.text[lang_end]) == i8(`\t`)) || (i32(ctx.text[lang_end]) == i8(`\v`) || i32(ctx.text[lang_end]) == i8(`\f`))) {
		lang_end++
	}
	for {
		ret = md_build_attribute(ctx, (ctx.text + beg), lang_end - beg, u32(0), &det.lang, lang_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	det.fence_char = fence_ch
	abort:
	return ret
}

fn md_process_leaf_block(ctx &MD_CTX, block &MD_BLOCK) i32 {
	det := AnonStruct_5547_207092{}

	info_build := MD_ATTRIBUTE_BUILD{}

	lang_build := MD_ATTRIBUTE_BUILD{}

	is_in_tight_list := i32(0)
	clean_fence_code_detail := i32(0)
	ret := i32(0)
	// For large tables check the table density: If it's too low, lets suppress
	//     *its interpretation as a table, as a safety measure against quadratic
	//     *output size explosion. See https://github.com/mity/md4c/issues/345

	if i32(block.type_) == BlockType.table {
		n_cols := block.data
		n_rows := block.n_lines
		if n_cols > u32(32) && n_rows > u32(4096) / n_cols {
			lines := &MD_LINE(voidptr((block + 1)))
			table_input_size := n_rows
			i := u32(0)
			for i = u32(0); i < n_rows; i++ {
				table_input_size += lines[i].end - lines[i].beg
			}
			if table_input_size / n_cols < n_rows / u32(4) {
				// Number of characters encoding the table in the input is
				//                 *lower then 25% of all cells to be generated?

				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Suppressing too sparse table (see https://github.com/mity/md4c/issues/345)'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				block.type_ = BlockType.p
			}
		}
	}
	C.memset(voidptr(&det), 0, sizeof(det))
	if ctx.n_containers == 0 {
		is_in_tight_list = 0
	} else {
		is_in_tight_list = !ctx.containers[ctx.n_containers - 1].is_loose
	}
	match block.type_ {
		.h { // case comp body kind=BinaryOperator is_enum=true
			det.header.level = block.data
		}
		.code { // case comp body kind=IfStmt is_enum=true
			// For fenced code block, we may need to set the info string.

			if i32(block.data) != 0 {
				C.memset(voidptr(&det.code), 0, sizeof(BlockCodeDetail))
				clean_fence_code_detail = 1
				for {
					ret = md_setup_fenced_code_detail(ctx, block, &det.code, &info_build, &lang_build)
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
			}
		}
		.table { // case comp body kind=BinaryOperator is_enum=true
			det.table.col_count = block.data
			det.table.head_row_count = u32(1)
			det.table.body_row_count = block.n_lines - Size(2)
		}
		.blank { // case comp body kind=BinaryOperator is_enum=true
			det.blank.line_count = block.data
		}
		else {
			// Noop.
		}
	}

	if !is_in_tight_list || i32(block.type_) != BlockType.p {
		for {
			ret = ctx.parser.enter_block(block.type_, voidptr((voidptr(c2v_address_of(&det)))), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// Process the block contents accordingly to is type.

	match block.type_ {
		.hr, .blank {
			// noop (no contents)
		}
		.code { // case comp body kind=DoStmt is_enum=true
			for {
				ret = md_process_code_block_contents(ctx, (i32(block.data) != 0), &MD_VERBATIMLINE(voidptr((block + 1))), block.n_lines)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
		}
		.html { // case comp body kind=DoStmt is_enum=true
			for {
				ret = md_process_verbatim_block_contents(ctx, TextType(TextType.html), &MD_VERBATIMLINE(voidptr((block + 1))), block.n_lines)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
		}
		.table { // case comp body kind=DoStmt is_enum=true
			for {
				ret = md_process_table_block_contents(ctx, i32(block.data), &MD_LINE(voidptr((block + 1))), block.n_lines)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
		}
		else {
			for {
				ret = md_process_normal_block_contents(ctx, &MD_LINE(voidptr((block + 1))), block.n_lines)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
		}
	}

	if !is_in_tight_list || i32(block.type_) != BlockType.p {
		for {
			ret = ctx.parser.leave_block(block.type_, voidptr((voidptr(c2v_address_of(&det)))), voidptr(ctx.userdata))
			if ret != 0 {
				for {
					if ctx.parser.debug_log != (voidptr(0)) {
						ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
					}
					// while()
					break
				}
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	abort:
	if clean_fence_code_detail {
		md_free_attribute(ctx, &info_build)
		md_free_attribute(ctx, &lang_build)
	}
	return ret
}

@[weak]
__global mD_ADMONITION_TAGS = [c'note', c'tip', c'important', c'warning', c'caution']!

fn md_process_all_blocks(ctx &MD_CTX) i32 {
	adm_substr_types := [TextType.normal]

	adm_substr_offsets := [2]Offset{}
	byte_off := i32(0)
	ret := i32(0)
	// ctx->containers now is not needed for detection of lists and list items
	//     *so we reuse it for tracking what lists are loose or tight. We rely
	//     *on the fact the vector is large enough to hold the deepest nesting
	//     *level of lists.

	ctx.n_containers = 0
	for byte_off < ctx.n_block_bytes {
		block := &MD_BLOCK(voidptr((&i8(ctx.block_bytes) + byte_off)))
		det := AnonStruct_5680_211728{}

		match block.type_ {
			.ul { // case comp body kind=BinaryOperator is_enum=true
				det.ul.is_tight = if (i32(block.flags) & 4) { 0 } else { 1 }
				det.ul.mark = Char(block.data)
			}
			.ol { // case comp body kind=BinaryOperator is_enum=true
				det.ol.start = block.n_lines
				det.ol.is_tight = if (i32(block.flags) & 4) { 0 } else { 1 }
				det.ol.mark_delimiter = Char(block.data)
			}
			.li { // case comp body kind=BinaryOperator is_enum=true
				det.li.is_task = (i32(block.data) != 0)
				det.li.task_mark = Char(block.data)
				det.li.task_mark_offset = Offset(block.n_lines)
			}
			.admonition { // case comp body kind=BinaryOperator is_enum=true
				adm_substr_offsets[0] = Offset(0)
				adm_substr_offsets[1] = u32(C.strlen(mD_ADMONITION_TAGS[block.data]))
				det.adm.type_.text = mD_ADMONITION_TAGS[block.data]
				det.adm.type_.size = adm_substr_offsets[1]
				det.adm.type_.substr_types = unsafe { &adm_substr_types[0] }
				det.adm.type_.substr_offsets = unsafe { &adm_substr_offsets[0] }
			}
			else {
				// noop
			}
		}

		if i32(block.flags) & (1 | 2) {
			if i32(block.flags) & 2 {
				for {
					ret = ctx.parser.leave_block(block.type_, voidptr((&det)), voidptr(ctx.userdata))
					if ret != 0 {
						for {
							if ctx.parser.debug_log != (voidptr(0)) {
								ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
							}
							// while()
							break
						}
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				mut __c2v_condition_72 := false
				mut __c2v_condition_73 := false
				__c2v_condition_73 = i32(block.type_) == BlockType.ul
				__c2v_condition_72 = __c2v_condition_73
				if !__c2v_condition_72 {
					mut __c2v_condition_74 := false
					__c2v_condition_74 = i32(block.type_) == BlockType.ol
					__c2v_condition_72 = __c2v_condition_74
				}
				if !__c2v_condition_72 {
					mut __c2v_condition_75 := false
					__c2v_condition_75 = i32(block.type_) == BlockType.quote
					__c2v_condition_72 = __c2v_condition_75
				}
				if !__c2v_condition_72 {
					mut __c2v_condition_76 := false
					__c2v_condition_76 = i32(block.type_) == BlockType.admonition
					__c2v_condition_72 = __c2v_condition_76
				}
				if __c2v_condition_72 {
					ctx.n_containers--
				}
			}
			if i32(block.flags) & 1 {
				for {
					ret = ctx.parser.enter_block(block.type_, voidptr((&det)), voidptr(ctx.userdata))
					if ret != 0 {
						for {
							if ctx.parser.debug_log != (voidptr(0)) {
								ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
							}
							// while()
							break
						}
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				if i32(block.type_) == BlockType.ul || i32(block.type_) == BlockType.ol {
					ctx.containers[ctx.n_containers].is_loose = u32(if (i32(block.flags) & 4) {
						1
					} else {
						0
					})
					ctx.n_containers++
				} else if i32(block.type_) == BlockType.quote || i32(block.type_) == BlockType.admonition {
					// This causes that any text in a block quote, even if
					//                     *nested inside a tight list item, is wrapped with
					//                     *<p>...</p>.

					ctx.containers[ctx.n_containers].is_loose = u32(1)
					ctx.n_containers++
				}
			}
		} else {
			for {
				ret = md_process_leaf_block(ctx, block)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
			if i32(block.type_) == BlockType.code || i32(block.type_) == BlockType.html {
				byte_off += block.n_lines * sizeof(MD_VERBATIMLINE)
			} else {
				byte_off += block.n_lines * sizeof(MD_LINE)
			}
		}
		byte_off += sizeof(MD_BLOCK)
	}
	ctx.n_block_bytes = 0
	abort:
	return ret
}

//******************
// ** Grouping Lines into Blocks  **
// ******************/
//
// static void*
// md_push_block_bytes(MD_CTX*ctx, int n_bytes)
//{
//    void*ptr;
//
//    if(ctx->n_block_bytes + n_bytes > ctx->alloc_block_bytes) {
//        void*new_block_bytes;
//
//        ctx->alloc_block_bytes = (ctx->alloc_block_bytes > 0
//                ? ctx->alloc_block_bytes + ctx->alloc_block_bytes / 2
//                : 512);
//        new_block_bytes = realloc(ctx->block_bytes, ctx->alloc_block_bytes);
//        if(new_block_bytes == NULL) {
//            MD_LOG("realloc() failed.");
//            return NULL;
//        }
//
//        /*Fix the ->current_block after the reallocation.

fn md_push_block_bytes(ctx &MD_CTX, n_bytes i32) voidptr {
	ptr := voidptr(0)
	if ctx.n_block_bytes + n_bytes > ctx.alloc_block_bytes {
		new_block_bytes := voidptr(0)
		ctx.alloc_block_bytes = (if ctx.alloc_block_bytes > 0 {
			ctx.alloc_block_bytes + ctx.alloc_block_bytes / 2
		} else {
			512
		})
		new_block_bytes = C.realloc(voidptr(ctx.block_bytes), ctx.alloc_block_bytes)
		if uint(new_block_bytes) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			return unsafe { nil }
		}
		if uint(ctx.current_block) != uint((voidptr(0))) {
			off_current_block := Offset((i64((int(&i8(voidptr(ctx.current_block))) - int(&i8(ctx.block_bytes))) / int(sizeof(i8)))))
			ctx.current_block = &MD_BLOCK(voidptr((&i8(new_block_bytes) + off_current_block)))
		}
		ctx.block_bytes = new_block_bytes
	}
	ptr = &i8(ctx.block_bytes) + ctx.n_block_bytes
	ctx.n_block_bytes += n_bytes
	return ptr
}

fn md_start_new_block(ctx &MD_CTX, line &MD_LINE_ANALYSIS) i32 {
	block := &MD_BLOCK(0)
	for {
		md_assume((uint(ctx.current_block) == uint((voidptr(0)))))
		// while()
		break
	}
	block = &MD_BLOCK(md_push_block_bytes(ctx, i32(sizeof(MD_BLOCK))))
	if uint(block) == uint((voidptr(0))) {
		return -1
	}
	match line.type_ {
		.md_line_hr { // case comp body kind=BinaryOperator is_enum=true
			block.type_ = BlockType.hr
		}
		.md_line_atxheader, .md_line_setextheader {
			block.type_ = BlockType.h
		}
		.md_line_fencedcode, .md_line_indentedcode {
			block.type_ = BlockType.code
		}
		.md_line_text { // case comp body kind=BinaryOperator is_enum=true
			block.type_ = BlockType.p
		}
		.md_line_html { // case comp body kind=BinaryOperator is_enum=true
			block.type_ = BlockType.html
		}
		else {
			for {
				md_assume((0 != 0))
				// while()
				break
			}
		}
	}

	block.flags = u32(0)
	block.data = line.data
	block.n_lines = Size(0)
	ctx.current_block = block
	return 0
}

// Forward declarations

// Eat from start of current (textual) block any reference definitions and/or
// *footnote definitions, and remember them.
// *
// *(Such definitions can only be at start of it as they cannot break a
// *paragraph.)
//

fn md_consume_link_reference_definitions(ctx &MD_CTX) i32 {
	lines := &MD_LINE(voidptr((ctx.current_block + 1)))
	n_lines := ctx.current_block.n_lines
	n := Size(0)
	inject_hr := (0 != 0)
	ignored := Offset(0)
	for n < n_lines {
		n_consumed := i32(0)
		// When footnotes are enabled, try footnote definition first for lines
		//         *starting with [^, so they are not accidentally consumed as link ref
		//         *definitions (which would also match [^label]: url).

		if (ctx.parser.flags & u32(1048576)) && lines[n].beg + Offset(1) < ctx.size && i32(ctx.text[lines[n].beg]) == i8(`[`) && i32(ctx.text[(lines[n].beg + Offset(1))]) == i8(`^`) {
			n_consumed = md_is_footnote_definition(ctx, lines + n, n_lines - n)
			if n_consumed < 0 {
				return -1
			}
		}
		if n_consumed == 0 {
			n_consumed = md_is_link_reference_definition(ctx, lines + n, n_lines - n)
			if n_consumed < 0 {
				return -1
			}
		}
		if n_consumed == 0 {
			break
		}
		n += Size(n_consumed)
	}
	// If no link ref. def. was detected, leave the block intact.

	if n == Size(0) {
		return 0
	}
	// We may need to turn the first line after the link ref. def(s) into HR.
	//     *(https://github.com/mity/md4c/issues/414)

	if n < n_lines && md_is_hr_line(ctx, lines[n].beg, &ignored, &ignored) {
		inject_hr = (1 != 0)
		n++
		// Remove one more line below.
	}
	if n == n_lines {
		// Undo the whole block.

		ctx.n_block_bytes -= n_lines * sizeof(MD_LINE)
		ctx.n_block_bytes -= sizeof(MD_BLOCK)
		ctx.current_block = unsafe { nil }
	} else {
		// Remove some initial lines from the block.

		C.memmove(voidptr(lines), voidptr(lines + n), (n_lines - n) * sizeof(MD_LINE))
		ctx.current_block.n_lines -= n
		ctx.n_block_bytes -= n * sizeof(MD_LINE)
	}
	if inject_hr {
		hr_block := &MD_BLOCK(0)
		hr_block = md_push_block_bytes(ctx, i32(sizeof(MD_BLOCK)))
		if uint(hr_block) == uint((voidptr(0))) {
			return -1
		}
		if uint(ctx.current_block) != uint((voidptr(0))) {
			C.memmove(voidptr(ctx.current_block + 1), voidptr(ctx.current_block), (sizeof(MD_BLOCK) + ctx.current_block.n_lines * sizeof(MD_LINE)))
			hr_block = ctx.current_block
			c2v_pointer_postfix(voidptr(&ctx.current_block), ctx.current_block, int(1))
		}
		C.memset(voidptr(hr_block), 0, sizeof(MD_BLOCK))
		hr_block.type_ = BlockType.hr
	}
	return 0
}

fn md_end_current_block(ctx &MD_CTX) i32 {
	ret := i32(0)
	if uint(ctx.current_block) == uint((voidptr(0))) {
		return ret
	}
	// Check whether there is a reference definition. (We do this here instead
	//     *of in md_analyze_line() because reference definition can take multiple
	//     *lines.)

	if i32(ctx.current_block.type_) == BlockType.p || (i32(ctx.current_block.type_) == BlockType.h && (i32(ctx.current_block.flags) & 8)) {
		lines := &MD_LINE(voidptr((ctx.current_block + 1)))
		if lines[0].beg < ctx.size && i32(ctx.text[lines[0].beg]) == i8(`[`) {
			for {
				ret = md_consume_link_reference_definitions(ctx)
				if ret != 0 {
					unsafe {
						goto abort
					}
				}
				// while()
				break
			}
			if uint(ctx.current_block) == uint((voidptr(0))) {
				return ret
			}
		}
	}
	if i32(ctx.current_block.type_) == BlockType.h && (i32(ctx.current_block.flags) & 8) {
		n_lines := ctx.current_block.n_lines
		if n_lines > Size(1) {
			// Get rid of the underline.

			ctx.current_block.n_lines--
			ctx.n_block_bytes -= sizeof(MD_LINE)
		} else {
			// Only the underline has left after eating the ref. defs.
			//             *Keep the line as beginning of a new ordinary paragraph.

			ctx.current_block.type_ = BlockType.p
			return 0
		}
	}
	// Mark we are not building any block anymore.

	ctx.current_block = unsafe { nil }
	abort:
	return ret
}

fn md_add_line_into_current_block(ctx &MD_CTX, analysis &MD_LINE_ANALYSIS) i32 {
	for {
		md_assume((uint(ctx.current_block) != uint((voidptr(0)))))
		// while()
		break
	}
	if i32(ctx.current_block.type_) == BlockType.code || i32(ctx.current_block.type_) == BlockType.html {
		line := &MD_VERBATIMLINE(0)
		line = &MD_VERBATIMLINE(md_push_block_bytes(ctx, i32(sizeof(MD_VERBATIMLINE))))
		if uint(line) == uint((voidptr(0))) {
			return -1
		}
		line.indent = analysis.indent
		line.beg = analysis.beg
		line.end = analysis.end
	} else {
		line := &MD_LINE(0)
		line = &MD_LINE(md_push_block_bytes(ctx, i32(sizeof(MD_LINE))))
		if uint(line) == uint((voidptr(0))) {
			return -1
		}
		line.beg = analysis.beg
		line.end = analysis.end
	}
	ctx.current_block.n_lines++
	return 0
}

// Part of the MD_FLAG_PRESERVEBLANKLINES implementation.

fn md_flush_blank_lines(ctx &MD_CTX) i32 {
	block := &MD_BLOCK(0)
	if ctx.n_blank_lines == u32(0) {
		return 0
	}
	block = &MD_BLOCK(md_push_block_bytes(ctx, i32(sizeof(MD_BLOCK))))
	if uint(block) == uint((voidptr(0))) {
		return -1
	}
	block.type_ = BlockType.blank
	block.flags = u32(0)
	block.data = ctx.n_blank_lines
	block.n_lines = Size(0)
	ctx.n_blank_lines = u32(0)
	return 0
}

fn md_push_container_bytes(ctx &MD_CTX, type_ BlockType, start u32, data u32, flags u32) i32 {
	block := &MD_BLOCK(0)
	ret := i32(0)
	for {
		ret = md_flush_blank_lines(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_end_current_block(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	block = &MD_BLOCK(md_push_block_bytes(ctx, i32(sizeof(MD_BLOCK))))
	if uint(block) == uint((voidptr(0))) {
		return -1
	}
	block.type_ = type_
	block.flags = flags
	block.data = data
	block.n_lines = start
	abort:
	return ret
}

//***********
// ** Line Analysis  **
// ***********

fn md_is_hr_line(ctx &MD_CTX, beg Offset, p_end &Offset, p_killer &Offset) i32 {
	off := beg + Offset(1)
	n := i32(1)
	if !(i32(ctx.text[beg]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'-_*'[0]) }, i32(ctx.text[beg]))) != uint((voidptr(0)))) {
		return 0
	}
	for off < ctx.size && (i32(ctx.text[off]) == i32(ctx.text[beg]) || i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
		if i32(ctx.text[off]) == i32(ctx.text[beg]) {
			n++
		}
		off++
	}
	if n < 3 {
		unsafe { *p_killer = off }
		return 0
	}
	// Nothing else can be present on the line.

	if off < ctx.size && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		unsafe { *p_killer = off }
		return 0
	}
	unsafe { *p_end = off }
	return 1
}

fn md_is_atxheader_line(ctx &MD_CTX, beg Offset, p_beg &Offset, p_end &Offset, p_level &u32) i32 {
	n := i32(0)
	off := beg + Offset(1)
	for off < ctx.size && i32(ctx.text[off]) == i8(`#`) && off - beg < Offset(7) {
		off++
	}
	n = i32(off - beg)
	if n > 6 {
		return 0
	}
	unsafe { *p_level = u32(n) }
	if !(ctx.parser.flags & u32(2)) && off < ctx.size && !(i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		return 0
	}
	for off < ctx.size && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
		off++
	}
	unsafe { *p_beg = off }
	unsafe { *p_end = off }
	return 1
}

fn md_is_setext_underline(ctx &MD_CTX, beg Offset, p_end &Offset, p_level &u32) i32 {
	off := beg + Offset(1)
	for off < ctx.size && i32(ctx.text[off]) == i32(ctx.text[beg]) {
		off++
	}
	// Optionally, space(s) or tabs can follow.

	for off < ctx.size && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
		off++
	}
	// But nothing more is allowed on the line.

	if off < ctx.size && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		return 0
	}
	unsafe { *p_level = u32((if i32(ctx.text[beg]) == i8(`=`) { 1 } else { 2 })) }
	unsafe { *p_end = off }
	return 1
}

fn md_is_table_underline(ctx &MD_CTX, beg Offset, p_end &Offset, p_col_count &u32) i32 {
	off := beg
	found_pipe := i32(0)
	col_count := u32(0)
	if off < ctx.size && i32(ctx.text[off]) == i8(`|`) {
		found_pipe = 1
		off++
		for off < ctx.size && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
			off++
		}
	}
	for {
		delimited := i32(0)
		// Cell underline ("-----", ":----", "----:" or ":----:")

		if off < ctx.size && i32(ctx.text[off]) == i8(`:`) {
			off++
		}
		if off >= ctx.size || i32(ctx.text[off]) != i8(`-`) {
			return 0
		}
		for off < ctx.size && i32(ctx.text[off]) == i8(`-`) {
			off++
		}
		if off < ctx.size && i32(ctx.text[off]) == i8(`:`) {
			off++
		}
		col_count++
		// Pipe delimiter (optional at the end of line).

		for off < ctx.size && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
			off++
		}
		if off < ctx.size && i32(ctx.text[off]) == i8(`|`) {
			delimited = 1
			found_pipe = 1
			off++
			for off < ctx.size && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
				off++
			}
		}
		// Success, if we reach end of line.

		if off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
			break
		}
		if !delimited {
			return 0
		}
	}
	if !found_pipe {
		return 0
	}
	unsafe { *p_end = off }
	unsafe { *p_col_count = col_count }
	return 1
}

fn md_is_opening_code_fence(ctx &MD_CTX, beg Offset, p_end &Offset) i32 {
	off := beg
	for off < ctx.size && i32(ctx.text[off]) == i32(ctx.text[beg]) {
		off++
	}
	// Fence must have at least three characters.

	if off - beg < Offset(3) {
		return 0
	}
	ctx.code_fence_length = off - beg
	// Optionally, space(s) can follow.

	for off < ctx.size && i32(ctx.text[off]) == i8(` `) {
		off++
	}
	// Optionally, an info string can follow.

	for off < ctx.size && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		// Backtick-based fence must not contain '`' in the info string.

		if i32(ctx.text[beg]) == i8(`\``) && i32(ctx.text[off]) == i8(`\``) {
			return 0
		}
		off++
	}
	unsafe { *p_end = off }
	return 1
}

fn md_is_closing_code_fence(ctx &MD_CTX, ch Char, beg Offset, p_end &Offset) i32 {
	off := beg
	ret := i32(0)
	// Closing fence must have at least the same length and use same char as
	//     *opening one.

	for off < ctx.size && i32(ctx.text[off]) == i32(ch) {
		off++
	}
	if off - beg < ctx.code_fence_length {
		unsafe {
			goto out
		}
	}
	// Optionally, space(s) can follow

	for off < ctx.size && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
		off++
	}
	// But nothing more is allowed on the line.

	if off < ctx.size && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		unsafe {
			goto out
		}
	}
	ret = 1
	out:
	// Note we set *_end even on failure: If we are not closing fence, caller
	//     *would eat the line anyway without any parsing.

	unsafe { *p_end = off }
	return ret
}

// Helper data for md_is_html_block_start_condition() and
// *md_is_html_block_end_condition()

type TAG = TAG_tag

struct TAG_tag {
	name &Char
	len  u32
}

@[export: 't1']
const t1 = [TAG{
	name: c'pre'
	len:  u32((sizeof([4]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'script'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'style'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'textarea'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global a6 = [TAG{
	name: c'address'
	len:  u32((sizeof([8]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'article'
	len:  u32((sizeof([8]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'aside'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global b6 = [TAG{
	name: c'base'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'basefont'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'blockquote'
	len:  u32((sizeof([11]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'body'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global c6 = [TAG{
	name: c'caption'
	len:  u32((sizeof([8]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'center'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'col'
	len:  u32((sizeof([4]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'colgroup'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global d6 = [TAG{
	name: c'dd'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'details'
	len:  u32((sizeof([8]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'dialog'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'dir'
	len:  u32((sizeof([4]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'div'
	len:  u32((sizeof([4]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'dl'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'dt'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global f6 = [TAG{
	name: c'fieldset'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'figcaption'
	len:  u32((sizeof([11]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'figure'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'footer'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'form'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'frame'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'frameset'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global h6 = [TAG{
	name: c'h1'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'h2'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'h3'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'h4'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'h5'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'h6'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'head'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'header'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'hr'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'html'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global i6 = [TAG{
	name: c'iframe'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global l6 = [TAG{
	name: c'legend'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'li'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'link'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global m6 = [TAG{
	name: c'main'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'menu'
	len:  u32((sizeof([5]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'menuitem'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global n6 = [TAG{
	name: c'nav'
	len:  u32((sizeof([4]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'noframes'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global o6 = [TAG{
	name: c'ol'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'optgroup'
	len:  u32((sizeof([9]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'option'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global p6 = [TAG{
	name: c'p'
	len:  u32((sizeof([2]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'param'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global s6 = [TAG{
	name: c'search'
	len:  u32((sizeof([7]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'section'
	len:  u32((sizeof([8]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'summary'
	len:  u32((sizeof([8]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global t6 = [TAG{
	name: c'table'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'tbody'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'td'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'tfoot'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'th'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'thead'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'title'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'tr'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: c'track'
	len:  u32((sizeof([6]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global u6 = [TAG{
	name: c'ul'
	len:  u32((sizeof([3]i8) - 1) / sizeof(Char))
}, TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

@[weak]
__global xx = [TAG{
	name: (voidptr(0))
	len:  u32(0)
}]!

// Returns type of the raw HTML block, or false if it is not HTML block.
// *(Refer to CommonMark specification for details about the types.)
//

fn md_is_html_block_start_condition(ctx &MD_CTX, beg Offset) i32 {
	// Type 6 is started by a long list of allowed tags. We use two-level
	//     *tree to speed-up the search.

	off := beg + Offset(1)
	i := i32(0)
	// Check for type 1: <script, <pre, or <style

	for i = 0; uint(t1[i].name) != uint((voidptr(0))); i++ {
		if off + Offset(t1[i].len) <= ctx.size {
			if md_ascii_case_eq((ctx.text + off), t1[i].name, t1[i].len) {
				tmp := off + Offset(t1[i].len)
				if tmp >= ctx.size || (i32(ctx.text[tmp]) == i8(` `) || i32(ctx.text[tmp]) == i8(`\t`)) || (i32(ctx.text[tmp]) == i8(`\r`) || i32(ctx.text[tmp]) == i8(`\n`)) || i32(ctx.text[tmp]) == i8(`>`) {
					return 1
				}
				// A self-closing type 1 name is excluded from type 7 as well.

				if tmp + Offset(1) < ctx.size && i32(ctx.text[tmp]) == i8(`/`) && i32(ctx.text[(tmp + Offset(1))]) == i8(`>`) {
					return 0
				}
			}
		}
	}
	// Check for type 2: <!--

	if off + Offset(3) < ctx.size && i32(ctx.text[off]) == i8(`!`) && i32(ctx.text[(off + Offset(1))]) == i8(`-`) && i32(ctx.text[(off + Offset(2))]) == i8(`-`) {
		return 2
	}
	// Check for type 3: <?

	if off < ctx.size && i32(ctx.text[off]) == i8(`?`) {
		return 3
	}
	// Check for type 4 or 5: <!

	if off < ctx.size && i32(ctx.text[off]) == i8(`!`) {
		// Check for type 4: <! followed by an ASCII letter.

		mut __c2v_condition_77 := false
		mut __c2v_condition_78 := false
		__c2v_condition_78 = off + Offset(1) < ctx.size
		if __c2v_condition_78 {
			__c2v_condition_78 = ((u32(`A`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`z`)))
		}
		__c2v_condition_77 = __c2v_condition_78
		if __c2v_condition_77 {
			return 4
		}
		// Check for type 5: <![CDATA[

		if off + Offset(8) < ctx.size {
			if md_ascii_eq((ctx.text + off), c'![CDATA[', Size(8)) {
				return 5
			}
		}
	}
	// Check for type 6: Many possible starting tags listed above.

	mut __c2v_condition_79 := false
	mut __c2v_condition_80 := false
	__c2v_condition_80 = off + Offset(1) < ctx.size
	if __c2v_condition_80 {
		__c2v_condition_80 = (((u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`z`))) || (i32(ctx.text[off]) == i8(`/`) && ((u32(`A`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`Z`)) || (u32(`a`) <= u32(ctx.text[(off + Offset(1))]) && u32(ctx.text[(off + Offset(1))]) <= u32(`z`)))))
	}
	__c2v_condition_79 = __c2v_condition_80
	if __c2v_condition_79 {
		slot := i32(0)
		tags := &TAG(0)
		if i32(ctx.text[off]) == i8(`/`) {
			off++
		}
		slot = (if (u32(`A`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`Z`)) {
			i32(ctx.text[off]) - i32(`A`)
		} else {
			i32(ctx.text[off]) - i32(`a`)
		})
		tags = md_is_html_block_start_condition_map6[slot]
		for i = 0; uint(tags[i].name) != uint((voidptr(0))); i++ {
			if off + Offset(tags[i].len) <= ctx.size {
				if md_ascii_case_eq((ctx.text + off), tags[i].name, tags[i].len) {
					tmp := off + Offset(tags[i].len)
					if tmp >= ctx.size {
						return 6
					}
					if (i32(ctx.text[tmp]) == i8(` `) || i32(ctx.text[tmp]) == i8(`\t`)) || (i32(ctx.text[tmp]) == i8(`\r`) || i32(ctx.text[tmp]) == i8(`\n`)) || i32(ctx.text[tmp]) == i8(`>`) {
						return 6
					}
					if tmp + Offset(1) < ctx.size && i32(ctx.text[tmp]) == i8(`/`) && i32(ctx.text[(tmp + Offset(1))]) == i8(`>`) {
						return 6
					}
					continue
				}
			}
		}
	}
	// Check for type 7: any COMPLETE other opening or closing tag.

	if off + Offset(1) < ctx.size {
		end := Offset(0)
		if md_is_html_tag(ctx, (voidptr(0)), Size(0), beg, ctx.size, &end) {
			// Only optional whitespace and new line may follow.

			for end < ctx.size && ((i32(ctx.text[end]) == i8(` `) || i32(ctx.text[end]) == i8(`\t`)) || (i32(ctx.text[end]) == i8(`\v`) || i32(ctx.text[end]) == i8(`\f`))) {
				end++
			}
			if end >= ctx.size || (i32(ctx.text[end]) == i8(`\r`) || i32(ctx.text[end]) == i8(`\n`)) {
				return 7
			}
		}
	}
	return 0
}

// Case sensitive check whether there is a substring 'what' between 'beg'
// *and end of line.

fn md_line_contains(ctx &MD_CTX, beg Offset, what &Char, what_len Size, p_end &Offset) i32 {
	i := Offset(0)
	for i = beg; i + what_len < ctx.size; i++ {
		if (i32(ctx.text[i]) == i8(`\r`) || i32(ctx.text[i]) == i8(`\n`)) {
			break
		}
		if C.memcmp(voidptr((ctx.text + i)), voidptr(what), what_len * sizeof(Char)) == 0 {
			unsafe { *p_end = i + what_len }
			return 1
		}
	}
	unsafe { *p_end = i }
	return 0
}

// Returns type of HTML block end condition or false if not an end condition.
// *
// *Note it fills p_end even when it is not end condition as the caller
// *does not need to analyze contents of a raw HTML block.
//

fn md_is_html_block_end_condition(ctx &MD_CTX, beg Offset, p_end &Offset) i32 {
	match ctx.html_block_type {
		1 {
			// case comp stmt
			off := beg
			i := i32(0)
			for off + Offset(1) < ctx.size && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
				if i32(ctx.text[off]) == i8(`<`) && i32(ctx.text[(off + Offset(1))]) == i8(`/`) {
					for i = 0; uint(t1[i].name) != uint((voidptr(0))); i++ {
						if off + Offset(2) + Offset(t1[i].len) < ctx.size {
							if md_ascii_case_eq((ctx.text + (off + Offset(2))), t1[i].name, t1[i].len) && i32(ctx.text[(off + Offset(2) + Offset(t1[i].len))]) == i8(`>`) {
								unsafe { *p_end = off + Offset(2) + Offset(t1[i].len) + Offset(1) }
								return 1
							}
						}
					}
				}
				off++
			}
			unsafe { *p_end = off }
			return 0
		}
		2 { // case comp body kind=ReturnStmt is_enum=false
			return if md_line_contains(ctx, beg, c'-->', Size(3), p_end) { 2 } else { 0 }
		}
		3 { // case comp body kind=ReturnStmt is_enum=false
			return if md_line_contains(ctx, beg, c'?>', Size(2), p_end) { 3 } else { 0 }
		}
		4 { // case comp body kind=ReturnStmt is_enum=false
			return if md_line_contains(ctx, beg, c'>', Size(1), p_end) { 4 } else { 0 }
		}
		5 { // case comp body kind=ReturnStmt is_enum=false
			return if md_line_contains(ctx, beg, c']]>', Size(3), p_end) { 5 } else { 0 }
		}
		6 { // case comp body kind=NullStmt is_enum=false

			unsafe {
				goto c2v_case_12_7
			}
		}
		7 { // case comp body kind=IfStmt is_enum=false
			c2v_case_12_7:
			if beg >= ctx.size || (i32(ctx.text[beg]) == i8(`\r`) || i32(ctx.text[beg]) == i8(`\n`)) {
				// Blank line ends types 6 and 7.

				unsafe { *p_end = beg }
				return ctx.html_block_type
			}
			return 0
		}
		else {
			for {
				md_assume((0 != 0))
				// while()
				break
			}
		}
	}

	return 0
}

fn md_is_container_compatible(pivot &MD_CONTAINER, container &MD_CONTAINER) i32 {
	// Block quote has no "items" like lists.

	if i32(container.ch) == i8(`>`) {
		return 0
	}
	if i32(container.ch) != i32(pivot.ch) {
		return 0
	}
	if container.mark_indent > pivot.contents_indent {
		return 0
	}
	return 1
}

fn md_push_container(ctx &MD_CTX, container &MD_CONTAINER) i32 {
	if ctx.n_containers >= ctx.alloc_containers {
		new_containers := &MD_CONTAINER(0)
		ctx.alloc_containers = (if ctx.alloc_containers > 0 {
			ctx.alloc_containers + ctx.alloc_containers / 2
		} else {
			16
		})
		new_containers = C.realloc(voidptr(ctx.containers), ctx.alloc_containers * sizeof(MD_CONTAINER))
		if uint(new_containers) == uint((voidptr(0))) {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'realloc() failed.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			return -1
		}
		ctx.containers = new_containers
	}
	C.memcpy(voidptr(unsafe { ctx.containers + ctx.n_containers++ }), voidptr(container), sizeof(MD_CONTAINER))
	return 0
}

fn md_enter_child_containers(ctx &MD_CTX, n_children i32) i32 {
	i := i32(0)
	ret := i32(0)
	for i = ctx.n_containers - n_children; i < ctx.n_containers; i++ {
		c := unsafe { ctx.containers + i }
		is_ordered_list := i32(0)
		match c.ch {
			`)`, `.` {
				is_ordered_list = 1

				unsafe {
					goto c2v_case_13_3
				}
			}
			`-`, `+`, `*` {
				c2v_case_13_3:
				// Remember offset in ctx->block_bytes so we can revisit the
				//                 *block if we detect it is a loose list.

				for {
					ret = md_end_current_block(ctx)
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				c.block_byte_off = Offset(ctx.n_block_bytes)
				for {
					ret = md_push_container_bytes(ctx, (if is_ordered_list {
						BlockType.ol
					} else {
						BlockType.ul
					}), c.start, u32(c.ch), u32(1))
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				for {
					ret = md_push_container_bytes(ctx, BlockType(BlockType.li), c.task_mark_off, u32((if i32(c.is_task) {
						i32(ctx.text[c.task_mark_off])
					} else {
						0
					})), u32(1))
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				c.li_block_byte_end = ctx.n_block_bytes
			}
			`>` { // case comp body kind=DoStmt is_enum=true
				for {
					ret = md_push_container_bytes(ctx, (if i32(c.is_admonition) {
						BlockType.admonition
					} else {
						BlockType.quote
					}), u32(0), c.admonition_type, u32(1))
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
			}
			else {
				for {
					md_assume((0 != 0))
					// while()
					break
				}
			}
		}
	}
	abort:
	return ret
}

fn md_leave_child_containers(ctx &MD_CTX, n_keep i32) i32 {
	ret := i32(0)
	for ctx.n_containers > n_keep {
		c := unsafe { ctx.containers + (ctx.n_containers - 1) }
		is_ordered_list := i32(0)
		match c.ch {
			`)`, `.` {
				is_ordered_list = 1

				unsafe {
					goto c2v_case_14_3
				}
			}
			`-`, `+`, `*` {
				c2v_case_14_3: for {
					ret = md_push_container_bytes(ctx, BlockType(BlockType.li), c.task_mark_off, u32((if i32(c.is_task) {
						i32(ctx.text[c.task_mark_off])
					} else {
						0
					})), u32(2))
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				for {
					ret = md_push_container_bytes(ctx, (if is_ordered_list {
						BlockType.ol
					} else {
						BlockType.ul
					}), u32(0), u32(c.ch), u32(2))
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
			}
			`>` { // case comp body kind=DoStmt is_enum=true
				for {
					ret = md_push_container_bytes(ctx, (if i32(c.is_admonition) {
						BlockType.admonition
					} else {
						BlockType.quote
					}), u32(0), c.admonition_type, u32(2))
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
			}
			else {
				for {
					md_assume((0 != 0))
					// while()
					break
				}
			}
		}

		ctx.n_containers--
	}
	abort:
	return ret
}

fn md_is_container_mark(ctx &MD_CTX, indent u32, beg Offset, p_end &Offset, p_container &MD_CONTAINER) i32 {
	off := beg
	max_end := Offset(0)
	if off >= ctx.size || indent >= ctx.code_indent_offset {
		return 0
	}
	// Check for block quote mark.

	if i32(ctx.text[off]) == i8(`>`) {
		off++
		p_container.ch = Char(`>`)
		p_container.is_loose = u32(0)
		p_container.is_task = u32(0)
		p_container.mark_indent = indent
		p_container.contents_indent = indent + u32(1)
		unsafe { *p_end = off }
		return 1
	}
	// Check for list item bullet mark.

	mut __c2v_condition_81 := false
	mut __c2v_condition_82 := false
	__c2v_condition_82 = (i32(ctx.text[off]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'-+*'[0]) }, i32(ctx.text[off]))) != uint((voidptr(0))))
	if __c2v_condition_82 {
		__c2v_condition_82 = (off + Offset(1) >= ctx.size || (i32(ctx.text[(off + Offset(1))]) == i8(` `) || i32(ctx.text[(off + Offset(1))]) == i8(`\t`)) || (i32(ctx.text[(off + Offset(1))]) == i8(`\r`) || i32(ctx.text[(off + Offset(1))]) == i8(`\n`)))
	}
	__c2v_condition_81 = __c2v_condition_82
	if __c2v_condition_81 {
		p_container.ch = ctx.text[off]
		p_container.is_loose = u32(0)
		p_container.is_task = u32(0)
		p_container.mark_indent = indent
		p_container.contents_indent = indent + u32(1)
		unsafe { *p_end = off + Offset(1) }
		return 1
	}
	// Check for ordered list item marks.

	max_end = off + Offset(9)
	if max_end > ctx.size {
		max_end = ctx.size
	}
	p_container.start = u32(0)
	for off < max_end && (u32(`0`) <= u32(ctx.text[off]) && u32(ctx.text[off]) <= u32(`9`)) {
		p_container.start = p_container.start * u32(10) + u32(ctx.text[off]) - u32(`0`)
		off++
	}
	mut __c2v_condition_83 := false
	mut __c2v_condition_84 := false
	__c2v_condition_84 = off > beg
	if __c2v_condition_84 {
		__c2v_condition_84 = off < ctx.size
	}
	if __c2v_condition_84 {
		__c2v_condition_84 = (i32(ctx.text[off]) == i8(`.`) || i32(ctx.text[off]) == i8(`)`))
	}
	if __c2v_condition_84 {
		__c2v_condition_84 = (off + Offset(1) >= ctx.size || (i32(ctx.text[(off + Offset(1))]) == i8(` `) || i32(ctx.text[(off + Offset(1))]) == i8(`\t`)) || (i32(ctx.text[(off + Offset(1))]) == i8(`\r`) || i32(ctx.text[(off + Offset(1))]) == i8(`\n`)))
	}
	__c2v_condition_83 = __c2v_condition_84
	if __c2v_condition_83 {
		p_container.ch = ctx.text[off]
		p_container.is_loose = u32(0)
		p_container.is_task = u32(0)
		p_container.mark_indent = indent
		p_container.contents_indent = indent + off - beg + u32(1)
		unsafe { *p_end = off + Offset(1) }
		return 1
	}
	return 0
}

fn md_line_indentation(ctx &MD_CTX, total_indent u32, beg Offset, p_end &Offset) u32 {
	off := beg
	indent := total_indent
	for off < ctx.size && (i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) {
		if i32(ctx.text[off]) == i8(`\t`) {
			indent = (indent + u32(4)) & u32(~3)
		} else {
			indent++
		}
		off++
	}
	unsafe { *p_end = off }
	return indent - total_indent
}

@[weak]
__global md_dummy_blank_line = MD_LINE_ANALYSIS{
	type_:             MD_LINETYPE.md_line_blank
	data:              u32(0)
	enforce_new_block: 0
	beg:               Offset(0)
	end:               Offset(0)
	indent:            u32(0)
}

// Analyze type of the line and find some its properties. This serves as a
// *main input for determining type and boundaries of a block.

fn md_analyze_line(ctx &MD_CTX, beg Offset, p_end &Offset, pivot_line &MD_LINE_ANALYSIS, line &MD_LINE_ANALYSIS) i32 {
	total_indent := u32(0)
	n_parents := i32(0)
	n_brothers := i32(0)
	n_children := i32(0)
	container := MD_CONTAINER{}

	prev_line_has_list_loosening_effect := ctx.last_line_has_list_loosening_effect
	off := beg
	hr_killer := Offset(0)
	n_implicit_parents_beg := i32(0)
	n_implicit_parents_end := i32(0)
	ret := i32(0)
	line.indent = md_line_indentation(ctx, total_indent, off, &off)
	total_indent += line.indent
	line.beg = off
	line.enforce_new_block = 0
	// Given the indentation and block quote marks '>', determine how many of
	//     *the current containers are our parents.

	for n_parents < ctx.n_containers {
		c := unsafe { ctx.containers + n_parents }
		if i32(c.ch) == i8(`>`) && line.indent < ctx.code_indent_offset && off < ctx.size && i32(ctx.text[off]) == i8(`>`) {
			// Block quote mark.

			off++
			total_indent++
			line.indent = md_line_indentation(ctx, total_indent, off, &off)
			total_indent += line.indent
			// The optional 1st space after '>' is part of the block quote mark.

			if line.indent > u32(0) {
				line.indent--
			}
			line.beg = off
		} else if i32(c.ch) != i8(`>`) && line.indent >= c.contents_indent {
			// List.

			line.indent -= c.contents_indent
		} else {
			break
		}
		n_parents++
	}
	if off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		// Blank line does not need any real indentation to be nested inside
		//         *a list.

		if n_brothers + n_children == 0 {
			n_implicit_parents_beg = n_parents
			for n_parents < ctx.n_containers && i32(ctx.containers[n_parents].ch) != i8(`>`) {
				if ctx.last_n_implicit_parents_beg <= n_parents && n_parents <= ctx.last_n_implicit_parents_end && ctx.last_n_implicit_parents_end - ctx.last_n_implicit_parents_beg > 0 {
					// All containers in [beg, end) are lists, so any blank line
					//                     *starting within that range ends at the same place.

					n_parents = ctx.last_n_implicit_parents_end
					break
				}
				n_parents++
			}
			n_implicit_parents_end = n_parents
		}
	}
	for {
		// Check whether we are fenced code continuation.

		if i32(pivot_line.type_) == MD_LINETYPE.md_line_fencedcode {
			line.beg = off
			// We are another MD_LINE_FENCEDCODE unless we are closing fence
			//             *which we transform into MD_LINE_BLANK.

			if line.indent < ctx.code_indent_offset {
				if md_is_closing_code_fence(ctx, ctx.text[pivot_line.beg], off, &off) {
					line.type_ = MD_LINETYPE.md_line_blank
					ctx.last_line_has_list_loosening_effect = 0
					break
				}
			}
			// Change indentation accordingly to the initial code fence.

			if n_parents == ctx.n_containers {
				if line.indent > pivot_line.indent {
					line.indent -= pivot_line.indent
				} else {
					line.indent = u32(0)
				}
				line.type_ = MD_LINETYPE.md_line_fencedcode
				break
			}
		}
		// Check whether we are HTML block continuation.

		if i32(pivot_line.type_) == MD_LINETYPE.md_line_html && ctx.html_block_type > 0 {
			if n_parents < ctx.n_containers {
				// HTML block is implicitly ended if the enclosing container
				//                 *block ends.

				ctx.html_block_type = 0
			} else {
				html_block_type := i32(0)
				html_block_type = md_is_html_block_end_condition(ctx, off, &off)
				if html_block_type > 0 {
					for {
						md_assume((html_block_type == ctx.html_block_type))
						// while()
						break
					}
					// Make sure this is the last line of the block.

					ctx.html_block_type = 0
					// Some end conditions serve as blank lines at the same time.

					if html_block_type == 6 || html_block_type == 7 {
						line.type_ = MD_LINETYPE.md_line_blank
						line.indent = u32(0)
						break
					}
				}
				line.type_ = MD_LINETYPE.md_line_html
				n_parents = ctx.n_containers
				break
			}
		}
		// Check for blank line.

		if off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
			if i32(pivot_line.type_) == MD_LINETYPE.md_line_indentedcode && n_parents == ctx.n_containers {
				line.type_ = MD_LINETYPE.md_line_indentedcode
				if line.indent > ctx.code_indent_offset {
					line.indent -= ctx.code_indent_offset
				} else {
					line.indent = u32(0)
				}
				ctx.last_line_has_list_loosening_effect = 0
			} else {
				line.type_ = MD_LINETYPE.md_line_blank
				ctx.consecutive_blank_lines++
				ctx.last_line_has_list_loosening_effect = (n_parents > 0 && n_brothers + n_children == 0 && i32(ctx.containers[n_parents - 1].ch) != i8(`>`))
			}
			break
		} else {
			// CommonMark requires a list item cannot begin with two (or more)
			//             *blank lines so we may need to forcefully end the list.
			//             *(See https://github.com/mity/md4c/issues/6)

			if ctx.consecutive_blank_lines >= 2 {
				mut __c2v_condition_85 := false
				mut __c2v_condition_86 := false
				__c2v_condition_86 = n_parents > 0
				if __c2v_condition_86 {
					__c2v_condition_86 = n_parents == ctx.n_containers
				}
				if __c2v_condition_86 {
					__c2v_condition_86 = i32(ctx.containers[n_parents - 1].ch) != i8(`>`)
				}
				if __c2v_condition_86 {
					__c2v_condition_86 = n_brothers + n_children == 0
				}
				if __c2v_condition_86 {
					__c2v_condition_86 = uint(ctx.current_block) == uint((voidptr(0)))
				}
				if __c2v_condition_86 {
					__c2v_condition_86 = ctx.n_block_bytes == ctx.containers[n_parents - 1].li_block_byte_end
				}
				if __c2v_condition_86 {
					__c2v_condition_86 = !ctx.containers[n_parents - 1].li_has_content
				}
				__c2v_condition_85 = __c2v_condition_86
				if __c2v_condition_85 {
					line.indent += ctx.containers[n_parents - 1].contents_indent
					n_parents--
				}
			}
			ctx.consecutive_blank_lines = 0
			ctx.last_line_has_list_loosening_effect = 0
		}
		// Check whether we are Setext underline.

		mut __c2v_condition_87 := false
		mut __c2v_condition_88 := false
		__c2v_condition_88 = line.indent < ctx.code_indent_offset
		if __c2v_condition_88 {
			__c2v_condition_88 = i32(pivot_line.type_) == MD_LINETYPE.md_line_text
		}
		if __c2v_condition_88 {
			__c2v_condition_88 = off < ctx.size
		}
		if __c2v_condition_88 {
			__c2v_condition_88 = (i32(ctx.text[off]) == i8(`=`) || i32(ctx.text[off]) == i8(`-`))
		}
		if __c2v_condition_88 {
			__c2v_condition_88 = (n_parents == ctx.n_containers)
		}
		__c2v_condition_87 = __c2v_condition_88
		if __c2v_condition_87 {
			level := u32(0)
			if md_is_setext_underline(ctx, off, &off, &level) {
				line.type_ = MD_LINETYPE.md_line_setextunderline
				line.data = level
				break
			}
		}
		// Check for thematic break line.

		if line.indent < ctx.code_indent_offset && off < ctx.size && off >= hr_killer {
			if md_is_hr_line(ctx, off, &off, &hr_killer) {
				line.type_ = MD_LINETYPE.md_line_hr
				break
			}
		}
		// Check for "brother" container. I.e. whether we are another list item
		//         *in already started list.

		if n_parents < ctx.n_containers && n_brothers + n_children == 0 {
			tmp := Offset(0)
			if md_is_container_mark(ctx, line.indent, off, &tmp, &container) && md_is_container_compatible(unsafe { ctx.containers + n_parents }, &container) {
				pivot_line = &md_dummy_blank_line
				off = tmp
				total_indent += container.contents_indent - container.mark_indent
				line.indent = md_line_indentation(ctx, total_indent, off, &off)
				total_indent += line.indent
				line.beg = off
				// Some of the following whitespace actually still belongs to the mark.

				if off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
					container.contents_indent++
				} else if line.indent <= ctx.code_indent_offset {
					container.contents_indent += line.indent
					line.indent = u32(0)
				} else {
					container.contents_indent += u32(1)
					line.indent--
				}
				ctx.containers[n_parents].mark_indent = container.mark_indent
				ctx.containers[n_parents].contents_indent = container.contents_indent
				n_brothers++
				continue
			}
		}
		// Check for indented code.
		//         *Note indented code block cannot interrupt a paragraph.

		if line.indent >= ctx.code_indent_offset && (i32(pivot_line.type_) != MD_LINETYPE.md_line_text) {
			line.type_ = MD_LINETYPE.md_line_indentedcode
			line.indent -= ctx.code_indent_offset
			line.data = u32(0)
			break
		}
		// Check for start of a new container block.

		if line.indent < ctx.code_indent_offset && md_is_container_mark(ctx, line.indent, off, &off, &container) {
			mut __c2v_condition_89 := false
			mut __c2v_condition_90 := false
			__c2v_condition_90 = i32(pivot_line.type_) == MD_LINETYPE.md_line_text
			if __c2v_condition_90 {
				__c2v_condition_90 = n_parents == ctx.n_containers
			}
			if __c2v_condition_90 {
				__c2v_condition_90 = (off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)))
			}
			if __c2v_condition_90 {
				__c2v_condition_90 = i32(container.ch) != i8(`>`)
			}
			__c2v_condition_89 = __c2v_condition_90
			if __c2v_condition_89 {
				// Noop. List mark followed by a blank line cannot interrupt a paragraph.
			} else if i32(pivot_line.type_) == MD_LINETYPE.md_line_text && n_parents == ctx.n_containers && (i32(container.ch) == i8(`.`) || i32(container.ch) == i8(`)`)) && container.start != u32(1) {
				// Noop. Ordered list cannot interrupt a paragraph unless the start index is 1.
			} else {
				total_indent += container.contents_indent - container.mark_indent
				line.indent = md_line_indentation(ctx, total_indent, off, &off)
				total_indent += line.indent
				line.beg = off
				line.data = u32(u8(container.ch))
				// Some of the following whitespace actually still belongs to the mark.

				if off >= ctx.size || (i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
					container.contents_indent++
				} else if line.indent <= ctx.code_indent_offset {
					container.contents_indent += line.indent
					line.indent = u32(0)
				} else {
					container.contents_indent += u32(1)
					line.indent--
				}
				if n_brothers + n_children == 0 {
					pivot_line = &md_dummy_blank_line
				}
				if n_children == 0 {
					for {
						ret = md_leave_child_containers(ctx, n_parents + n_brothers)
						if ret != 0 {
							unsafe {
								goto abort
							}
						}
						// while()
						break
					}
				}
				n_children++
				for {
					ret = md_push_container(ctx, &container)
					if ret != 0 {
						unsafe {
							goto abort
						}
					}
					// while()
					break
				}
				continue
			}
		}
		// Check whether we are table continuation.

		if i32(pivot_line.type_) == MD_LINETYPE.md_line_table && n_parents == ctx.n_containers {
			line.type_ = MD_LINETYPE.md_line_table
			break
		}
		// Check for ATX header.

		if line.indent < ctx.code_indent_offset && off < ctx.size && i32(ctx.text[off]) == i8(`#`) {
			level := u32(0)
			if md_is_atxheader_line(ctx, off, &line.beg, &off, &level) {
				line.type_ = MD_LINETYPE.md_line_atxheader
				line.data = level
				break
			}
		}
		// Check whether we are starting code fence.

		if line.indent < ctx.code_indent_offset && off < ctx.size && (i32(ctx.text[off]) == i8(`\``) || i32(ctx.text[off]) == i8(`~`)) {
			if md_is_opening_code_fence(ctx, off, &off) {
				line.type_ = MD_LINETYPE.md_line_fencedcode
				line.data = u32(1)
				line.enforce_new_block = 1
				break
			}
		}
		// Check for start of raw HTML block.

		if off < ctx.size && i32(ctx.text[off]) == i8(`<`) && !(ctx.parser.flags & u32(32)) {
			ctx.html_block_type = md_is_html_block_start_condition(ctx, off)
			// HTML block type 7 cannot interrupt paragraph.

			if ctx.html_block_type == 7 && i32(pivot_line.type_) == MD_LINETYPE.md_line_text {
				ctx.html_block_type = 0
			}
			if ctx.html_block_type > 0 {
				// The line itself also may immediately close the block.

				if md_is_html_block_end_condition(ctx, off, &off) == ctx.html_block_type {
					// Make sure this is the last line of the block.

					ctx.html_block_type = 0
				}
				line.enforce_new_block = 1
				line.type_ = MD_LINETYPE.md_line_html
				break
			}
		}
		// Check for table underline.

		mut __c2v_condition_91 := false
		mut __c2v_condition_92 := false
		__c2v_condition_92 = (ctx.parser.flags & u32(256))
		if __c2v_condition_92 {
			__c2v_condition_92 = i32(pivot_line.type_) == MD_LINETYPE.md_line_text
		}
		if __c2v_condition_92 {
			__c2v_condition_92 = off < ctx.size
		}
		if __c2v_condition_92 {
			__c2v_condition_92 = (i32(ctx.text[off]) == i8(`|`) || i32(ctx.text[off]) == i8(`-`) || i32(ctx.text[off]) == i8(`:`))
		}
		if __c2v_condition_92 {
			__c2v_condition_92 = n_parents == ctx.n_containers
		}
		__c2v_condition_91 = __c2v_condition_92
		if __c2v_condition_91 {
			col_count := u32(0)
			if uint(ctx.current_block) != uint((voidptr(0))) && ctx.current_block.n_lines == Size(1) && md_is_table_underline(ctx, off, &off, &col_count) {
				line.data = col_count
				line.type_ = MD_LINETYPE.md_line_tableunderline
				break
			}
		}
		// By default, we are normal text line.

		line.type_ = MD_LINETYPE.md_line_text
		if i32(pivot_line.type_) == MD_LINETYPE.md_line_text && n_brothers + n_children == 0 {
			// Lazy continuation.

			n_parents = ctx.n_containers
		}
		// Check for task mark.

		mut __c2v_condition_93 := false
		mut __c2v_condition_94 := false
		__c2v_condition_94 = (ctx.parser.flags & u32(2048))
		if __c2v_condition_94 {
			__c2v_condition_94 = n_brothers + n_children > 0
		}
		if __c2v_condition_94 {
			__c2v_condition_94 = (i32(ctx.containers[ctx.n_containers - 1].ch) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'-+*.)'[0]) }, i32(ctx.containers[ctx.n_containers - 1].ch))) != uint((voidptr(0))))
		}
		__c2v_condition_93 = __c2v_condition_94
		if __c2v_condition_93 {
			tmp := off
			for tmp < ctx.size && tmp < off + Offset(3) && (i32(ctx.text[tmp]) == i8(` `) || i32(ctx.text[tmp]) == i8(`\t`)) {
				tmp++
			}
			mut __c2v_condition_95 := false
			mut __c2v_condition_96 := false
			__c2v_condition_96 = tmp + Offset(2) < ctx.size
			if __c2v_condition_96 {
				__c2v_condition_96 = i32(ctx.text[tmp]) == i8(`[`)
			}
			if __c2v_condition_96 {
				__c2v_condition_96 = (i32(ctx.text[(tmp + Offset(1))]) != i8(`\0`) && uint(C.strchr(unsafe { &i8(&c'xX '[0]) }, i32(ctx.text[(tmp + Offset(1))]))) != uint((voidptr(0))))
			}
			if __c2v_condition_96 {
				__c2v_condition_96 = i32(ctx.text[(tmp + Offset(2))]) == i8(`]`)
			}
			if __c2v_condition_96 {
				__c2v_condition_96 = (tmp + Offset(3) == ctx.size || (i32(ctx.text[(tmp + Offset(3))]) == i8(` `) || i32(ctx.text[(tmp + Offset(3))]) == i8(`\t`)) || (i32(ctx.text[(tmp + Offset(3))]) == i8(`\r`) || i32(ctx.text[(tmp + Offset(3))]) == i8(`\n`)))
			}
			__c2v_condition_95 = __c2v_condition_96
			if __c2v_condition_95 {
				task_container := (if n_children > 0 {
					unsafe { ctx.containers + (ctx.n_containers - 1) }
				} else {
					&container
				})
				task_container.is_task = u32(1)
				task_container.task_mark_off = tmp + Offset(1)
				off = tmp + Offset(3)
				for off < ctx.size && ((i32(ctx.text[off]) == i8(` `) || i32(ctx.text[off]) == i8(`\t`)) || (i32(ctx.text[off]) == i8(`\v`) || i32(ctx.text[off]) == i8(`\f`))) {
					off++
				}
				line.beg = off
			}
		}
		break
	}
	// Keep verbatim indentation in the source, except for the part consumed
	//     *by a container or code block. Only a partially consumed tab needs to be
	//     *emitted as spaces. The opening fence keeps its indentation for use by
	//     *the following lines.

	mut __c2v_condition_97 := false
	mut __c2v_condition_98 := false
	__c2v_condition_98 = line.indent > u32(0)
	if __c2v_condition_98 {
		__c2v_condition_98 = (i32(line.type_) == MD_LINETYPE.md_line_indentedcode || i32(line.type_) == MD_LINETYPE.md_line_html || (i32(line.type_) == MD_LINETYPE.md_line_fencedcode && !line.enforce_new_block))
	}
	__c2v_condition_97 = __c2v_condition_98
	if __c2v_condition_97 {
		consumed_indent := total_indent - line.indent
		indent := u32(0)
		tmp := beg
		for tmp < line.beg && indent < consumed_indent {
			if i32(ctx.text[tmp]) == i8(`\t`) {
				indent = (indent + u32(4)) & u32(~3)
			} else {
				indent++
			}
			tmp++
		}
		line.beg = tmp
		line.indent = indent - consumed_indent
	}
	// Scan for an end of the line.
	//     *NOTE: This is by far the hottest loop in our code. Hence we try to
	//     *optimize this, assuming memchr() is highly optimized and uses SIMD
	//     *if it's available on the platform.
	//

	for off < ctx.size && !(i32(ctx.text[off]) == i8(`\r`) || i32(ctx.text[off]) == i8(`\n`)) {
		// Don't look too much ahead to keep the text in CPU cache as we scan
		//         *over it twice here.

		static max_lookahead := Size(2048)
		if ctx.cr_horizon <= off && ctx.cr_horizon < ctx.size {
			scan_from := (if off > ctx.cr_horizon { off } else { ctx.cr_horizon })
			scan_len := (if max_lookahead < (ctx.size - scan_from) {
				max_lookahead
			} else {
				(ctx.size - scan_from)
			})
			ptr := &Char(C.memchr(voidptr(ctx.text + scan_from), `\r`, scan_len))
			ctx.cr_horizon = Offset((if uint(ptr) != uint((voidptr(0))) {
				i64((int(ptr) - int(ctx.text)) / int(sizeof(i8)))
			} else {
				scan_from + scan_len
			}))
		}
		if ctx.lf_horizon <= off && ctx.lf_horizon < ctx.size {
			scan_from := (if off > ctx.lf_horizon { off } else { ctx.lf_horizon })
			scan_len := (if max_lookahead < (ctx.size - scan_from) {
				max_lookahead
			} else {
				(ctx.size - scan_from)
			})
			ptr := &Char(C.memchr(voidptr(ctx.text + scan_from), `\n`, scan_len))
			ctx.lf_horizon = Offset((if uint(ptr) != uint((voidptr(0))) {
				i64((int(ptr) - int(ctx.text)) / int(sizeof(i8)))
			} else {
				scan_from + scan_len
			}))
		}
		off = (if ctx.cr_horizon < ctx.lf_horizon { ctx.cr_horizon } else { ctx.lf_horizon })
	}
	// Set end of the line.

	line.end = off
	// But for ATX header, we should exclude the optional trailing mark.

	if i32(line.type_) == MD_LINETYPE.md_line_atxheader {
		tmp := line.end
		for tmp > line.beg && (i32(ctx.text[(tmp - Offset(1))]) == i8(` `) || i32(ctx.text[(tmp - Offset(1))]) == i8(`\t`)) {
			tmp--
		}
		for tmp > line.beg && i32(ctx.text[(tmp - Offset(1))]) == i8(`#`) {
			tmp--
		}
		if tmp == line.beg || (i32(ctx.text[(tmp - Offset(1))]) == i8(` `) || i32(ctx.text[(tmp - Offset(1))]) == i8(`\t`)) || (ctx.parser.flags & u32(2)) {
			line.end = tmp
		}
	}
	// Trim trailing spaces.

	if i32(line.type_) != MD_LINETYPE.md_line_indentedcode && i32(line.type_) != MD_LINETYPE.md_line_fencedcode && i32(line.type_) != MD_LINETYPE.md_line_html {
		for line.end > line.beg && (i32(ctx.text[(line.end - Offset(1))]) == i8(` `) || i32(ctx.text[(line.end - Offset(1))]) == i8(`\t`)) {
			line.end--
		}
	}
	// Eat also the new line.

	if off < ctx.size && i32(ctx.text[off]) == i8(`\r`) {
		off++
	}
	if off < ctx.size && i32(ctx.text[off]) == i8(`\n`) {
		off++
	}
	unsafe { *p_end = off }
	// If we belong to a list after seeing a blank line, the list is loose.

	if prev_line_has_list_loosening_effect && i32(line.type_) != MD_LINETYPE.md_line_blank && n_parents + n_brothers > 0 {
		c := unsafe { ctx.containers + (n_parents + n_brothers - 1) }
		if i32(c.ch) != i8(`>`) {
			block := &MD_BLOCK(voidptr(((&i8(ctx.block_bytes)) + c.block_byte_off)))
			block.flags |= 4
		}
	}
	// Leave any containers we are not part of anymore.

	if n_children == 0 && n_parents + n_brothers < ctx.n_containers {
		for {
			ret = md_leave_child_containers(ctx, n_parents + n_brothers)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// Enter any container we found a mark for.

	if n_brothers > 0 {
		for {
			md_assume((n_brothers == 1))
			// while()
			break
		}
		for {
			ret = md_push_container_bytes(ctx, BlockType(BlockType.li), ctx.containers[n_parents].task_mark_off, u32((if i32(ctx.containers[n_parents].is_task) {
				i32(ctx.text[ctx.containers[n_parents].task_mark_off])
			} else {
				0
			})), u32(2))
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		for {
			ret = md_push_container_bytes(ctx, BlockType(BlockType.li), container.task_mark_off, u32((if i32(container.is_task) {
				i32(ctx.text[container.task_mark_off])
			} else {
				0
			})), u32(1))
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		ctx.containers[n_parents].li_block_byte_end = ctx.n_block_bytes
		ctx.containers[n_parents].li_has_content = u32(0)
		ctx.containers[n_parents].is_task = container.is_task
		ctx.containers[n_parents].task_mark_off = container.task_mark_off
	}
	if n_children > 0 {
		// Check for admonition tag.

		mut __c2v_condition_99 := false
		mut __c2v_condition_100 := false
		__c2v_condition_100 = (ctx.parser.flags & u32(524288))
		if __c2v_condition_100 {
			__c2v_condition_100 = n_children > 0
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = i32(ctx.containers[ctx.n_containers - 1].ch) == i8(`>`)
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = i32(line.type_) == MD_LINETYPE.md_line_text
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = Offset(3) < line.end - line.beg
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = line.end - line.beg < Offset(16)
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = i32(ctx.text[line.beg]) == i8(`[`)
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = i32(ctx.text[(line.beg + Offset(1))]) == i8(`!`)
		}
		if __c2v_condition_100 {
			__c2v_condition_100 = i32(ctx.text[(line.end - Offset(1))]) == i8(`]`)
		}
		__c2v_condition_99 = __c2v_condition_100
		if __c2v_condition_99 {
			i := u32(0)
			for i = u32(0); i < 5; i++ {
				if line.end - line.beg == C.strlen(mD_ADMONITION_TAGS[i]) + 3 && md_ascii_case_eq((ctx.text + (line.beg + Offset(2))), mD_ADMONITION_TAGS[i], line.end - line.beg - Offset(3)) {
					ctx.containers[ctx.n_containers - 1].is_admonition = u32(1)
					ctx.containers[ctx.n_containers - 1].admonition_type = i
					line.type_ = MD_LINETYPE.md_line_blank
					break
				}
			}
		}
		// Enter all the child container blocks.

		for {
			ret = md_enter_child_containers(ctx, n_children)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// Reference definitions can remove their blocks without emptying the item.

	if i32(line.type_) != MD_LINETYPE.md_line_blank && line.beg < line.end && ctx.n_containers > 0 && i32(ctx.containers[ctx.n_containers - 1].ch) != i8(`>`) {
		ctx.containers[ctx.n_containers - 1].li_has_content = u32(1)
	}
	ctx.last_n_implicit_parents_beg = n_implicit_parents_beg
	ctx.last_n_implicit_parents_end = n_implicit_parents_end
	abort:
	return ret
}

fn md_process_line(ctx &MD_CTX, p_pivot_line &&MD_LINE_ANALYSIS, line &MD_LINE_ANALYSIS) i32 {
	pivot_line := (unsafe { *p_pivot_line })
	ret := i32(0)
	// Blank line ends current leaf block.

	if i32(line.type_) == MD_LINETYPE.md_line_blank {
		for {
			ret = md_end_current_block(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		// Count only genuinely empty lines: some non-blank lines (e.g. a closing
		//         *code fence) are internally retyped as MD_LINE_BLANK but still hold
		//         *their text (beg < end), and must not be counted.

		if (ctx.parser.flags & u32(4194304)) && line.beg >= line.end {
			ctx.n_blank_lines++
		}
		unsafe { *p_pivot_line = &md_dummy_blank_line }
		return 0
	}
	// The blank lines preceding this block (if any) form a block separation
	//     *which we report before the block itself.

	for {
		ret = md_flush_blank_lines(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	if line.enforce_new_block {
		for {
			ret = md_end_current_block(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// Some line types form block on their own.

	if i32(line.type_) == MD_LINETYPE.md_line_hr || i32(line.type_) == MD_LINETYPE.md_line_atxheader {
		for {
			ret = md_end_current_block(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		// Add our single-line block.

		for {
			ret = md_start_new_block(ctx, line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		for {
			ret = md_add_line_into_current_block(ctx, line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		for {
			ret = md_end_current_block(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		unsafe { *p_pivot_line = &md_dummy_blank_line }
		return 0
	}
	// MD_LINE_SETEXTUNDERLINE changes meaning of the current block and ends it.

	if i32(line.type_) == MD_LINETYPE.md_line_setextunderline {
		for {
			md_assume((uint(ctx.current_block) != uint((voidptr(0)))))
			// while()
			break
		}
		ctx.current_block.type_ = BlockType.h
		ctx.current_block.data = line.data
		ctx.current_block.flags |= 8
		for {
			ret = md_add_line_into_current_block(ctx, line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		for {
			ret = md_end_current_block(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		if uint(ctx.current_block) == uint((voidptr(0))) {
			unsafe { *p_pivot_line = &md_dummy_blank_line }
		} else {
			// This happens if we have consumed all the body as link ref. defs.
			//             *and downgraded the underline into start of a new paragraph block.

			line.type_ = MD_LINETYPE.md_line_text
			unsafe { *p_pivot_line = line }
		}
		return 0
	}
	// MD_LINE_TABLEUNDERLINE changes meaning of the current block.

	if i32(line.type_) == MD_LINETYPE.md_line_tableunderline {
		for {
			md_assume((uint(ctx.current_block) != uint((voidptr(0)))))
			// while()
			break
		}
		for {
			md_assume((ctx.current_block.n_lines == Size(1)))
			// while()
			break
		}
		ctx.current_block.type_ = BlockType.table
		ctx.current_block.data = line.data
		for {
			md_assume((uint(pivot_line) != uint(&md_dummy_blank_line)))
			// while()
			break
		}
		(&MD_LINE_ANALYSIS(pivot_line)).type_ = MD_LINETYPE.md_line_table
		for {
			ret = md_add_line_into_current_block(ctx, line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		return 0
	}
	// The current block also ends if the line has different type.

	if i32(line.type_) != i32(pivot_line.type_) {
		for {
			ret = md_end_current_block(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// The current line may start a new block.

	if uint(ctx.current_block) == uint((voidptr(0))) {
		for {
			ret = md_start_new_block(ctx, line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		unsafe { *p_pivot_line = line }
	}
	// In all other cases the line is just a continuation of the current block.

	for {
		ret = md_add_line_into_current_block(ctx, line)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	return ret
}

fn md_process_footnote_def(ctx &MD_CTX, def &MD_FOOTNOTE_DEF) i32 {
	det := BlockFootnoteDefDetail{}
	label_build := MD_ATTRIBUTE_BUILD{}

	ret := i32(0)
	C.memset(voidptr(&det), 0, sizeof(BlockFootnoteDefDetail))
	det.id = def.index
	det.ref_count = def.ref_count
	for {
		ret = md_build_attribute(ctx, def.entry.label, def.entry.label_size, u32(0), &det.label, &label_build)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = ctx.parser.enter_block(BlockType(BlockType.footnote_def), voidptr((&det)), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_process_normal_block_contents(ctx, def.content_lines, def.n_content_lines)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = ctx.parser.leave_block(BlockType(BlockType.footnote_def), voidptr((&det)), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	md_free_attribute(ctx, &label_build)
	return ret
}

// Render footnote definitions that were actually referenced, in reference order.
// *Called from md_process_doc() after md_process_all_blocks().

fn md_process_footnote_defs(ctx &MD_CTX) i32 {
	i := u32(0)
	ret := i32(0)
	if ctx.footnote_hashtable.n_defs == u32(0) || ctx.next_footnote_index == u32(0) {
		return 0
	}
	// Keep definitions in place because the label hash table points into them.
	//     *A definition may first be referenced while rendering another one.

	ctx.footnote_order = C.malloc(ctx.footnote_hashtable.n_defs * sizeof(&MD_FOOTNOTE_DEF))
	if uint(ctx.footnote_order) == uint((voidptr(0))) {
		for {
			if ctx.parser.debug_log != (voidptr(0)) {
				ctx.parser.debug_log(unsafe { &i8(&c'malloc() failed.'[0]) }, voidptr(ctx.userdata))
			}
			// while()
			break
		}
		return -1
	}
	for i = u32(0); i < ctx.footnote_hashtable.n_defs; i++ {
		def := unsafe { ctx.footnote_hashtable.c2v_anonymous_5198.footnote_defs + i }
		if def.index != u32(0) {
			ctx.footnote_order[def.index - u32(1)] = def
		}
	}
	for {
		ret = ctx.parser.enter_block(BlockType(BlockType.footnote_def_section), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for i = u32(0); i < ctx.next_footnote_index; i++ {
		for {
			ret = md_process_footnote_def(ctx, ctx.footnote_order[i])
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	for {
		ret = ctx.parser.leave_block(BlockType(BlockType.footnote_def_section), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	C.free(voidptr(ctx.footnote_order))
	ctx.footnote_order = unsafe { nil }
	return ret
}

fn md_process_doc(ctx &MD_CTX) i32 {
	pivot_line := &md_dummy_blank_line
	line_buf := [2]MD_LINE_ANALYSIS{}
	line := unsafe { &line_buf[0] + 0 }
	off := Offset(0)
	ret := i32(0)
	for {
		ret = ctx.parser.enter_block(BlockType(BlockType.doc), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from enter_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for off < ctx.size {
		if uint(line) == uint(pivot_line) {
			line = (if uint(line) == uint(unsafe { &line_buf[0] + 0 }) {
				unsafe { &line_buf[0] + 1 }
			} else {
				unsafe { &line_buf[0] + 0 }
			})
		}
		for {
			ret = md_analyze_line(ctx, off, &off, pivot_line, line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
		for {
			ret = md_process_line(ctx, &&MD_LINE_ANALYSIS(&&MD_LINE_ANALYSIS(c2v_address_of(&pivot_line))), line)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	for {
		ret = md_end_current_block(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_build_ref_def_hashtable(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	if ctx.parser.flags & u32(1048576) {
		for {
			ret = md_build_footnote_def_hashtable(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	// Process all blocks.

	for {
		ret = md_leave_child_containers(ctx, 0)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	// Report any blank lines trailing the document.

	for {
		ret = md_flush_blank_lines(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	for {
		ret = md_process_all_blocks(ctx)
		if ret != 0 {
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	// Emit footnote definitions that were referenced, in reference order.

	if ctx.parser.flags & u32(1048576) {
		for {
			ret = md_process_footnote_defs(ctx)
			if ret != 0 {
				unsafe {
					goto abort
				}
			}
			// while()
			break
		}
	}
	for {
		ret = ctx.parser.leave_block(BlockType(BlockType.doc), voidptr((voidptr(0))), voidptr(ctx.userdata))
		if ret != 0 {
			for {
				if ctx.parser.debug_log != (voidptr(0)) {
					ctx.parser.debug_log(unsafe { &i8(&c'Aborted from leave_block() callback.'[0]) }, voidptr(ctx.userdata))
				}
				// while()
				break
			}
			unsafe {
				goto abort
			}
		}
		// while()
		break
	}
	abort:
	// Output some memory consumption statistics.

	return ret
}

//**********
// ** Public API  **
// **********/
//
// int
// parse_raw(const Char*text, Size size, const Parser*parser, void*userdata)
//{
//    MD_CTX ctx;
//    int i;
//    int ret;
//
//    if(parser->abi_version != 0) {
//        if(parser->debug_log != NULL)
//            parser->debug_log("Unsupported abi_version.", userdata);
//        return -1;
//    }
//
//    /*Setup context structure.

// parse_raw parses a UTF-8 buffer. The buffer must remain valid until parsing
// returns. Configure all rendering callbacks in parser; pointers passed to
// callbacks must not be retained without copying. Prefer parse for V strings.
pub fn parse_raw(text &Char, size Size, parser &Parser, userdata voidptr) i32 {
	ctx := MD_CTX{}
	i := i32(0)
	ret := i32(0)
	if parser.abi_version != u32(0) {
		if parser.debug_log != (voidptr(0)) {
			parser.debug_log(c'Unsupported abi_version.', voidptr(userdata))
		}
		return -1
	}
	C.memset(voidptr(&ctx), 0, sizeof(MD_CTX))
	ctx.text = text
	ctx.size = size
	C.memcpy(voidptr(&ctx.parser), voidptr(parser), sizeof(Parser))
	ctx.userdata = userdata
	ctx.code_indent_offset = if (ctx.parser.flags & u32(16)) {
		Offset((-1))
	} else {
		Offset(4)
	}
	md_build_mark_char_map(&ctx)
	ctx.ref_def_hashtable.def_size = u32(sizeof(MD_REF_DEF))
	ctx.max_ref_def_output = Size(16) * (if size < (Size((1024 * 1024 / 16))) {
		size
	} else {
		(Size((1024 * 1024 / 16)))
	})
	ctx.footnote_hashtable.def_size = u32(sizeof(MD_FOOTNOTE_DEF))
	// Reset all mark stacks and lists.

	for i = 0; i < 20; i++ {
		ctx.opener_stacks[i].top = -1
	}
	ctx.ptr_stack.top = -1
	ctx.unresolved_link_head = -1
	ctx.unresolved_link_tail = -1
	ctx.table_cell_boundaries_head = -1
	ctx.table_cell_boundaries_tail = -1
	// All the work.

	ret = md_process_doc(&ctx)
	// Clean-up.

	md_free_ref_defs(&ctx)
	md_free_footnote_defs(&ctx)
	C.free(voidptr(ctx.buffer))
	C.free(voidptr(ctx.marks))
	C.free(voidptr(ctx.block_bytes))
	C.free(voidptr(ctx.containers))
	return ret
}

// Initialize immutable lookup tables once, before any parser callbacks can run.
fn init() {
	if true {
		c2v_static_init := [u32(32), u32(160), u32(5760), u32((8192 | 1073741824)),
			(u32(8202) | u32(2147483648)), u32(8239), u32(8287), u32(12288)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_is_unicode_whitespace___whitespace_map[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32((33 | 1073741824)), (u32(47) | u32(2147483648)),
			u32((58 | 1073741824)), (u32(64) | u32(2147483648)), u32((91 | 1073741824)),
			(u32(96) | u32(2147483648)), u32((123 | 1073741824)), (u32(126) | u32(2147483648)),
			u32((161 | 1073741824)), (u32(169) | u32(2147483648)), u32((171 | 1073741824)),
			(u32(172) | u32(2147483648)), u32((174 | 1073741824)), (u32(177) | u32(2147483648)),
			u32(180), u32((182 | 1073741824)), (u32(184) | u32(2147483648)), u32(187), u32(191),
			u32(215), u32(247), u32((706 | 1073741824)), (u32(709) | u32(2147483648)),
			u32((722 | 1073741824)), (u32(735) | u32(2147483648)), u32((741 | 1073741824)),
			(u32(747) | u32(2147483648)), u32(749), u32((751 | 1073741824)),
			(u32(767) | u32(2147483648)), u32(885), u32(894), u32((900 | 1073741824)),
			(u32(901) | u32(2147483648)), u32(903), u32(1014), u32(1154), u32((1370 | 1073741824)),
			(u32(1375) | u32(2147483648)), u32((1417 | 1073741824)), (u32(1418) | u32(2147483648)),
			u32((1421 | 1073741824)), (u32(1423) | u32(2147483648)), u32(1470), u32(1472), u32(1475),
			u32(1478), u32((1523 | 1073741824)), (u32(1524) | u32(2147483648)),
			u32((1542 | 1073741824)), (u32(1551) | u32(2147483648)), u32(1563),
			u32((1565 | 1073741824)), (u32(1567) | u32(2147483648)), u32((1642 | 1073741824)),
			(u32(1645) | u32(2147483648)), u32(1748), u32(1758), u32(1769), u32((1789 | 1073741824)),
			(u32(1790) | u32(2147483648)), u32((1792 | 1073741824)), (u32(1805) | u32(2147483648)),
			u32((2038 | 1073741824)), (u32(2041) | u32(2147483648)), u32((2046 | 1073741824)),
			(u32(2047) | u32(2147483648)), u32((2096 | 1073741824)), (u32(2110) | u32(2147483648)),
			u32(2142), u32(2184), u32((2404 | 1073741824)), (u32(2405) | u32(2147483648)), u32(2416),
			u32((2546 | 1073741824)), (u32(2547) | u32(2147483648)), u32((2554 | 1073741824)),
			(u32(2555) | u32(2147483648)), u32(2557), u32(2678), u32((2800 | 1073741824)),
			(u32(2801) | u32(2147483648)), u32(2928), u32((3059 | 1073741824)),
			(u32(3066) | u32(2147483648)), u32(3191), u32(3199), u32(3204), u32(3407), u32(3449),
			u32(3572), u32(3647), u32(3663), u32((3674 | 1073741824)), (u32(3675) | u32(2147483648)),
			u32((3841 | 1073741824)), (u32(3863) | u32(2147483648)), u32((3866 | 1073741824)),
			(u32(3871) | u32(2147483648)), u32(3892), u32(3894), u32(3896), u32((3898 | 1073741824)),
			(u32(3901) | u32(2147483648)), u32(3973), u32((4030 | 1073741824)),
			(u32(4037) | u32(2147483648)), u32((4039 | 1073741824)), (u32(4044) | u32(2147483648)),
			u32((4046 | 1073741824)), (u32(4058) | u32(2147483648)), u32((4170 | 1073741824)),
			(u32(4175) | u32(2147483648)), u32((4254 | 1073741824)), (u32(4255) | u32(2147483648)),
			u32(4347), u32((4960 | 1073741824)), (u32(4968) | u32(2147483648)),
			u32((5008 | 1073741824)), (u32(5017) | u32(2147483648)), u32(5120),
			u32((5741 | 1073741824)), (u32(5742) | u32(2147483648)), u32((5787 | 1073741824)),
			(u32(5788) | u32(2147483648)), u32((5867 | 1073741824)), (u32(5869) | u32(2147483648)),
			u32((5941 | 1073741824)), (u32(5942) | u32(2147483648)), u32((6100 | 1073741824)),
			(u32(6102) | u32(2147483648)), u32((6104 | 1073741824)), (u32(6107) | u32(2147483648)),
			u32((6144 | 1073741824)), (u32(6154) | u32(2147483648)), u32(6464),
			u32((6468 | 1073741824)), (u32(6469) | u32(2147483648)), u32((6622 | 1073741824)),
			(u32(6655) | u32(2147483648)), u32((6686 | 1073741824)), (u32(6687) | u32(2147483648)),
			u32((6816 | 1073741824)), (u32(6822) | u32(2147483648)), u32((6824 | 1073741824)),
			(u32(6829) | u32(2147483648)), u32((6990 | 1073741824)), (u32(6991) | u32(2147483648)),
			u32((7002 | 1073741824)), (u32(7018) | u32(2147483648)), u32((7028 | 1073741824)),
			(u32(7039) | u32(2147483648)), u32((7164 | 1073741824)), (u32(7167) | u32(2147483648)),
			u32((7227 | 1073741824)), (u32(7231) | u32(2147483648)), u32((7294 | 1073741824)),
			(u32(7295) | u32(2147483648)), u32((7360 | 1073741824)), (u32(7367) | u32(2147483648)),
			u32(7379), u32(8125), u32((8127 | 1073741824)), (u32(8129) | u32(2147483648)),
			u32((8141 | 1073741824)), (u32(8143) | u32(2147483648)), u32((8157 | 1073741824)),
			(u32(8159) | u32(2147483648)), u32((8173 | 1073741824)), (u32(8175) | u32(2147483648)),
			u32((8189 | 1073741824)), (u32(8190) | u32(2147483648)), u32((8208 | 1073741824)),
			(u32(8231) | u32(2147483648)), u32((8240 | 1073741824)), (u32(8286) | u32(2147483648)),
			u32((8314 | 1073741824)), (u32(8318) | u32(2147483648)), u32((8330 | 1073741824)),
			(u32(8334) | u32(2147483648)), u32((8352 | 1073741824)), (u32(8388) | u32(2147483648)),
			u32((8448 | 1073741824)), (u32(8449) | u32(2147483648)), u32((8451 | 1073741824)),
			(u32(8454) | u32(2147483648)), u32((8456 | 1073741824)), (u32(8457) | u32(2147483648)),
			u32(8468), u32((8470 | 1073741824)), (u32(8472) | u32(2147483648)),
			u32((8478 | 1073741824)), (u32(8483) | u32(2147483648)), u32(8485), u32(8487), u32(8489),
			u32(8494), u32((8506 | 1073741824)), (u32(8507) | u32(2147483648)),
			u32((8512 | 1073741824)), (u32(8516) | u32(2147483648)), u32((8522 | 1073741824)),
			(u32(8525) | u32(2147483648)), u32(8527), u32((8586 | 1073741824)),
			(u32(8587) | u32(2147483648)), u32((8592 | 1073741824)), (u32(9257) | u32(2147483648)),
			u32((9280 | 1073741824)), (u32(9290) | u32(2147483648)), u32((9372 | 1073741824)),
			(u32(9449) | u32(2147483648)), u32((9472 | 1073741824)), (u32(10101) | u32(2147483648)),
			u32((10132 | 1073741824)), (u32(11123) | u32(2147483648)), u32((11126 | 1073741824)),
			(u32(11263) | u32(2147483648)), u32((11493 | 1073741824)), (u32(11498) | u32(2147483648)),
			u32((11513 | 1073741824)), (u32(11516) | u32(2147483648)), u32((11518 | 1073741824)),
			(u32(11519) | u32(2147483648)), u32(11632), u32((11776 | 1073741824)),
			(u32(11822) | u32(2147483648)), u32((11824 | 1073741824)), (u32(11869) | u32(2147483648)),
			u32((11872 | 1073741824)), (u32(11875) | u32(2147483648)), u32((11904 | 1073741824)),
			(u32(11929) | u32(2147483648)), u32((11931 | 1073741824)), (u32(12019) | u32(2147483648)),
			u32((12032 | 1073741824)), (u32(12245) | u32(2147483648)), u32((12272 | 1073741824)),
			(u32(12287) | u32(2147483648)), u32((12289 | 1073741824)), (u32(12292) | u32(2147483648)),
			u32((12296 | 1073741824)), (u32(12320) | u32(2147483648)), u32(12336),
			u32((12342 | 1073741824)), (u32(12343) | u32(2147483648)), u32((12349 | 1073741824)),
			(u32(12351) | u32(2147483648)), u32((12443 | 1073741824)), (u32(12444) | u32(2147483648)),
			u32(12448), u32(12539), u32((12688 | 1073741824)), (u32(12689) | u32(2147483648)),
			u32((12694 | 1073741824)), (u32(12703) | u32(2147483648)), u32((12736 | 1073741824)),
			(u32(12773) | u32(2147483648)), u32(12783), u32((12800 | 1073741824)),
			(u32(12830) | u32(2147483648)), u32((12842 | 1073741824)), (u32(12871) | u32(2147483648)),
			u32(12880), u32((12896 | 1073741824)), (u32(12927) | u32(2147483648)),
			u32((12938 | 1073741824)), (u32(12976) | u32(2147483648)), u32((12992 | 1073741824)),
			(u32(13311) | u32(2147483648)), u32((19904 | 1073741824)), (u32(19967) | u32(2147483648)),
			u32((42128 | 1073741824)), (u32(42182) | u32(2147483648)), u32((42238 | 1073741824)),
			(u32(42239) | u32(2147483648)), u32((42509 | 1073741824)), (u32(42511) | u32(2147483648)),
			u32(42611), u32(42622), u32((42738 | 1073741824)), (u32(42743) | u32(2147483648)),
			u32((42752 | 1073741824)), (u32(42774) | u32(2147483648)), u32((42784 | 1073741824)),
			(u32(42785) | u32(2147483648)), u32((42889 | 1073741824)), (u32(42890) | u32(2147483648)),
			u32((43048 | 1073741824)), (u32(43051) | u32(2147483648)), u32((43062 | 1073741824)),
			(u32(43065) | u32(2147483648)), u32((43124 | 1073741824)), (u32(43127) | u32(2147483648)),
			u32((43214 | 1073741824)), (u32(43215) | u32(2147483648)), u32((43256 | 1073741824)),
			(u32(43258) | u32(2147483648)), u32(43260), u32((43310 | 1073741824)),
			(u32(43311) | u32(2147483648)), u32(43359), u32((43457 | 1073741824)),
			(u32(43469) | u32(2147483648)), u32((43486 | 1073741824)), (u32(43487) | u32(2147483648)),
			u32((43612 | 1073741824)), (u32(43615) | u32(2147483648)), u32((43639 | 1073741824)),
			(u32(43641) | u32(2147483648)), u32((43742 | 1073741824)), (u32(43743) | u32(2147483648)),
			u32((43760 | 1073741824)), (u32(43761) | u32(2147483648)), u32(43867),
			u32((43882 | 1073741824)), (u32(43883) | u32(2147483648)), u32(44011), u32(64297),
			u32((64434 | 1073741824)), (u32(64466) | u32(2147483648)), u32((64830 | 1073741824)),
			(u32(64847) | u32(2147483648)), u32((64912 | 1073741824)), (u32(64913) | u32(2147483648)),
			u32((64968 | 1073741824)), (u32(64975) | u32(2147483648)), u32((65020 | 1073741824)),
			(u32(65023) | u32(2147483648)), u32((65040 | 1073741824)), (u32(65049) | u32(2147483648)),
			u32((65072 | 1073741824)), (u32(65106) | u32(2147483648)), u32((65108 | 1073741824)),
			(u32(65126) | u32(2147483648)), u32((65128 | 1073741824)), (u32(65131) | u32(2147483648)),
			u32((65281 | 1073741824)), (u32(65295) | u32(2147483648)), u32((65306 | 1073741824)),
			(u32(65312) | u32(2147483648)), u32((65339 | 1073741824)), (u32(65344) | u32(2147483648)),
			u32((65371 | 1073741824)), (u32(65381) | u32(2147483648)), u32((65504 | 1073741824)),
			(u32(65510) | u32(2147483648)), u32((65512 | 1073741824)), (u32(65518) | u32(2147483648)),
			u32((65532 | 1073741824)), (u32(65533) | u32(2147483648)), u32((65792 | 1073741824)),
			(u32(65794) | u32(2147483648)), u32((65847 | 1073741824)), (u32(65855) | u32(2147483648)),
			u32((65913 | 1073741824)), (u32(65929) | u32(2147483648)), u32((65932 | 1073741824)),
			(u32(65934) | u32(2147483648)), u32((65936 | 1073741824)), (u32(65948) | u32(2147483648)),
			u32(65952), u32((66000 | 1073741824)), (u32(66044) | u32(2147483648)), u32(66463),
			u32(66512), u32(66927), u32(67671), u32((67703 | 1073741824)),
			(u32(67704) | u32(2147483648)), u32(67871), u32(67903), u32((68176 | 1073741824)),
			(u32(68184) | u32(2147483648)), u32(68223), u32(68296), u32((68336 | 1073741824)),
			(u32(68342) | u32(2147483648)), u32((68409 | 1073741824)), (u32(68415) | u32(2147483648)),
			u32((68505 | 1073741824)), (u32(68508) | u32(2147483648)), u32(68974),
			u32((69006 | 1073741824)), (u32(69007) | u32(2147483648)), u32(69293),
			u32((69321 | 1073741824)), (u32(69322) | u32(2147483648)), u32((69328 | 1073741824)),
			(u32(69336) | u32(2147483648)), u32((69461 | 1073741824)), (u32(69465) | u32(2147483648)),
			u32((69510 | 1073741824)), (u32(69513) | u32(2147483648)), u32((69703 | 1073741824)),
			(u32(69709) | u32(2147483648)), u32((69819 | 1073741824)), (u32(69820) | u32(2147483648)),
			u32((69822 | 1073741824)), (u32(69825) | u32(2147483648)), u32((69952 | 1073741824)),
			(u32(69955) | u32(2147483648)), u32((70004 | 1073741824)), (u32(70005) | u32(2147483648)),
			u32((70085 | 1073741824)), (u32(70088) | u32(2147483648)), u32(70093), u32(70107),
			u32((70109 | 1073741824)), (u32(70111) | u32(2147483648)), u32((70200 | 1073741824)),
			(u32(70205) | u32(2147483648)), u32(70313), u32((70612 | 1073741824)),
			(u32(70613) | u32(2147483648)), u32((70615 | 1073741824)), (u32(70616) | u32(2147483648)),
			u32((70731 | 1073741824)), (u32(70735) | u32(2147483648)), u32((70746 | 1073741824)),
			(u32(70747) | u32(2147483648)), u32(70749), u32(70854), u32((71105 | 1073741824)),
			(u32(71127) | u32(2147483648)), u32((71233 | 1073741824)), (u32(71235) | u32(2147483648)),
			u32((71264 | 1073741824)), (u32(71276) | u32(2147483648)), u32(71353),
			u32((71484 | 1073741824)), (u32(71487) | u32(2147483648)), u32(71739),
			u32((72004 | 1073741824)), (u32(72006) | u32(2147483648)), u32(72162),
			u32((72255 | 1073741824)), (u32(72262) | u32(2147483648)), u32((72346 | 1073741824)),
			(u32(72348) | u32(2147483648)), u32((72350 | 1073741824)), (u32(72354) | u32(2147483648)),
			u32((72448 | 1073741824)), (u32(72457) | u32(2147483648)), u32(72673),
			u32((72769 | 1073741824)), (u32(72773) | u32(2147483648)), u32((72816 | 1073741824)),
			(u32(72817) | u32(2147483648)), u32((73463 | 1073741824)), (u32(73464) | u32(2147483648)),
			u32((73539 | 1073741824)), (u32(73551) | u32(2147483648)), u32((73685 | 1073741824)),
			(u32(73713) | u32(2147483648)), u32(73727), u32((74864 | 1073741824)),
			(u32(74868) | u32(2147483648)), u32((77809 | 1073741824)), (u32(77810) | u32(2147483648)),
			u32((92782 | 1073741824)), (u32(92783) | u32(2147483648)), u32(92917),
			u32((92983 | 1073741824)), (u32(92991) | u32(2147483648)), u32((92996 | 1073741824)),
			(u32(92997) | u32(2147483648)), u32((93549 | 1073741824)), (u32(93551) | u32(2147483648)),
			u32((93847 | 1073741824)), (u32(93850) | u32(2147483648)), u32(94178), u32(113820),
			u32(113823), u32((117760 | 1073741824)), (u32(117999) | u32(2147483648)),
			u32((118010 | 1073741824)), (u32(118012) | u32(2147483648)), u32((118016 | 1073741824)),
			(u32(118451) | u32(2147483648)), u32((118458 | 1073741824)),
			(u32(118480) | u32(2147483648)), u32((118482 | 1073741824)),
			(u32(118484) | u32(2147483648)), u32((118493 | 1073741824)),
			(u32(118525) | u32(2147483648)), u32((118608 | 1073741824)),
			(u32(118723) | u32(2147483648)), u32((118784 | 1073741824)),
			(u32(119029) | u32(2147483648)), u32((119040 | 1073741824)),
			(u32(119078) | u32(2147483648)), u32((119081 | 1073741824)),
			(u32(119140) | u32(2147483648)), u32((119146 | 1073741824)),
			(u32(119148) | u32(2147483648)), u32((119171 | 1073741824)),
			(u32(119172) | u32(2147483648)), u32((119180 | 1073741824)),
			(u32(119209) | u32(2147483648)), u32((119214 | 1073741824)),
			(u32(119361) | u32(2147483648)), u32(119365), u32((119379 | 1073741824)),
			(u32(119386) | u32(2147483648)), u32((119389 | 1073741824)),
			(u32(119390) | u32(2147483648)), u32((119392 | 1073741824)),
			(u32(119423) | u32(2147483648)), u32((119552 | 1073741824)),
			(u32(119638) | u32(2147483648)), u32(120513), u32(120539), u32(120571), u32(120597),
			u32(120629), u32(120655), u32(120687), u32(120713), u32(120745), u32(120771),
			u32((120832 | 1073741824)), (u32(121343) | u32(2147483648)), u32((121399 | 1073741824)),
			(u32(121402) | u32(2147483648)), u32((121453 | 1073741824)),
			(u32(121460) | u32(2147483648)), u32((121462 | 1073741824)),
			(u32(121475) | u32(2147483648)), u32((121477 | 1073741824)),
			(u32(121483) | u32(2147483648)), u32((121600 | 1073741824)),
			(u32(121628) | u32(2147483648)), u32(123215), u32(123647), u32(124415),
			u32((125278 | 1073741824)), (u32(125279) | u32(2147483648)), u32(126124), u32(126128),
			u32(126254), u32((126704 | 1073741824)), (u32(126705) | u32(2147483648)),
			u32((126976 | 1073741824)), (u32(127019) | u32(2147483648)), u32((127024 | 1073741824)),
			(u32(127123) | u32(2147483648)), u32((127136 | 1073741824)),
			(u32(127150) | u32(2147483648)), u32((127153 | 1073741824)),
			(u32(127167) | u32(2147483648)), u32((127169 | 1073741824)),
			(u32(127183) | u32(2147483648)), u32((127185 | 1073741824)),
			(u32(127221) | u32(2147483648)), u32((127245 | 1073741824)),
			(u32(127406) | u32(2147483648)), u32((127462 | 1073741824)),
			(u32(127490) | u32(2147483648)), u32((127504 | 1073741824)),
			(u32(127547) | u32(2147483648)), u32((127552 | 1073741824)),
			(u32(127560) | u32(2147483648)), u32((127568 | 1073741824)),
			(u32(127569) | u32(2147483648)), u32((127584 | 1073741824)),
			(u32(127589) | u32(2147483648)), u32((127744 | 1073741824)),
			(u32(128729) | u32(2147483648)), u32((128732 | 1073741824)),
			(u32(128748) | u32(2147483648)), u32((128752 | 1073741824)),
			(u32(128764) | u32(2147483648)), u32((128768 | 1073741824)),
			(u32(128987) | u32(2147483648)), u32((128992 | 1073741824)),
			(u32(129003) | u32(2147483648)), u32((129008 | 1073741824)),
			(u32(129035) | u32(2147483648)), u32((129040 | 1073741824)),
			(u32(129095) | u32(2147483648)), u32((129104 | 1073741824)),
			(u32(129113) | u32(2147483648)), u32((129120 | 1073741824)),
			(u32(129159) | u32(2147483648)), u32((129168 | 1073741824)),
			(u32(129197) | u32(2147483648)), u32((129200 | 1073741824)),
			(u32(129211) | u32(2147483648)), u32((129216 | 1073741824)),
			(u32(129217) | u32(2147483648)), u32((129232 | 1073741824)),
			(u32(129240) | u32(2147483648)), u32((129280 | 1073741824)),
			(u32(129623) | u32(2147483648)), u32((129632 | 1073741824)),
			(u32(129645) | u32(2147483648)), u32((129648 | 1073741824)),
			(u32(129660) | u32(2147483648)), u32((129664 | 1073741824)),
			(u32(129734) | u32(2147483648)), u32(129736), u32((129740 | 1073741824)),
			(u32(129757) | u32(2147483648)), u32((129759 | 1073741824)),
			(u32(129771) | u32(2147483648)), u32((129775 | 1073741824)),
			(u32(129786) | u32(2147483648)), u32((129792 | 1073741824)),
			(u32(129938) | u32(2147483648)), u32((129940 | 1073741824)),
			(u32(130031) | u32(2147483648)), u32(130042)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_is_unicode_punct___punct_map[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32((65 | 1073741824)), (u32(90) | u32(2147483648)), u32(181),
			u32((192 | 1073741824)), (u32(214) | u32(2147483648)), u32((216 | 1073741824)),
			(u32(222) | u32(2147483648)), u32((256 | 1073741824)), (u32(302) | u32(2147483648)),
			u32((306 | 1073741824)), (u32(310) | u32(2147483648)), u32((313 | 1073741824)),
			(u32(327) | u32(2147483648)), u32((330 | 1073741824)), (u32(374) | u32(2147483648)),
			u32(376), u32((377 | 1073741824)), (u32(381) | u32(2147483648)), u32(383), u32(385),
			u32(386), u32(388), u32(390), u32(391), u32(393), u32(394), u32(395), u32(398), u32(399),
			u32(400), u32(401), u32(403), u32(404), u32(406), u32(407), u32(408), u32(412), u32(413),
			u32(415), u32((416 | 1073741824)), (u32(420) | u32(2147483648)), u32(422), u32(423),
			u32(425), u32(428), u32(430), u32(431), u32(433), u32(434), u32(435), u32(437), u32(439),
			u32(440), u32(444), u32(452), u32(453), u32(455), u32(456), u32(458),
			u32((459 | 1073741824)), (u32(475) | u32(2147483648)), u32((478 | 1073741824)),
			(u32(494) | u32(2147483648)), u32(497), u32(498), u32(500), u32(502), u32(503),
			u32((504 | 1073741824)), (u32(542) | u32(2147483648)), u32(544), u32((546 | 1073741824)),
			(u32(562) | u32(2147483648)), u32(570), u32(571), u32(573), u32(574), u32(577), u32(579),
			u32(580), u32(581), u32((582 | 1073741824)), (u32(590) | u32(2147483648)), u32(837),
			u32(880), u32(882), u32(886), u32(895), u32(902), u32((904 | 1073741824)),
			(u32(906) | u32(2147483648)), u32(908), u32(910), u32(911), u32((913 | 1073741824)),
			(u32(929) | u32(2147483648)), u32((931 | 1073741824)), (u32(939) | u32(2147483648)),
			u32(962), u32(975), u32(976), u32(977), u32(981), u32(982), u32((984 | 1073741824)),
			(u32(1006) | u32(2147483648)), u32(1008), u32(1009), u32(1012), u32(1013), u32(1015),
			u32(1017), u32(1018), u32((1021 | 1073741824)), (u32(1023) | u32(2147483648)),
			u32((1024 | 1073741824)), (u32(1039) | u32(2147483648)), u32((1040 | 1073741824)),
			(u32(1071) | u32(2147483648)), u32((1120 | 1073741824)), (u32(1152) | u32(2147483648)),
			u32((1162 | 1073741824)), (u32(1214) | u32(2147483648)), u32(1216),
			u32((1217 | 1073741824)), (u32(1229) | u32(2147483648)), u32((1232 | 1073741824)),
			(u32(1326) | u32(2147483648)), u32((1329 | 1073741824)), (u32(1366) | u32(2147483648)),
			u32((4256 | 1073741824)), (u32(4293) | u32(2147483648)), u32(4295), u32(4301),
			u32((5112 | 1073741824)), (u32(5117) | u32(2147483648)), u32(7296), u32(7297), u32(7298),
			u32(7299), u32(7300), u32(7301), u32(7302), u32(7303), u32(7304), u32(7305),
			u32((7312 | 1073741824)), (u32(7354) | u32(2147483648)), u32((7357 | 1073741824)),
			(u32(7359) | u32(2147483648)), u32((7680 | 1073741824)), (u32(7828) | u32(2147483648)),
			u32(7835), u32((7840 | 1073741824)), (u32(7934) | u32(2147483648)),
			u32((7944 | 1073741824)), (u32(7951) | u32(2147483648)), u32((7960 | 1073741824)),
			(u32(7965) | u32(2147483648)), u32((7976 | 1073741824)), (u32(7983) | u32(2147483648)),
			u32((7992 | 1073741824)), (u32(7999) | u32(2147483648)), u32((8008 | 1073741824)),
			(u32(8013) | u32(2147483648)), u32(8025), u32(8027), u32(8029), u32(8031),
			u32((8040 | 1073741824)), (u32(8047) | u32(2147483648)), u32(8120), u32(8121), u32(8122),
			u32(8123), u32(8126), u32((8136 | 1073741824)), (u32(8139) | u32(2147483648)), u32(8152),
			u32(8153), u32(8154), u32(8155), u32(8168), u32(8169), u32(8170), u32(8171), u32(8172),
			u32(8184), u32(8185), u32(8186), u32(8187), u32(8486), u32(8490), u32(8491), u32(8498),
			u32((8544 | 1073741824)), (u32(8559) | u32(2147483648)), u32(8579),
			u32((9398 | 1073741824)), (u32(9423) | u32(2147483648)), u32((11264 | 1073741824)),
			(u32(11311) | u32(2147483648)), u32(11360), u32(11362), u32(11363), u32(11364),
			u32((11367 | 1073741824)), (u32(11371) | u32(2147483648)), u32(11373), u32(11374),
			u32(11375), u32(11376), u32(11378), u32(11381), u32(11390), u32(11391),
			u32((11392 | 1073741824)), (u32(11490) | u32(2147483648)), u32(11499), u32(11501),
			u32(11506), u32((42560 | 1073741824)), (u32(42604) | u32(2147483648)),
			u32((42624 | 1073741824)), (u32(42650) | u32(2147483648)), u32((42786 | 1073741824)),
			(u32(42798) | u32(2147483648)), u32((42802 | 1073741824)), (u32(42862) | u32(2147483648)),
			u32(42873), u32(42875), u32(42877), u32((42878 | 1073741824)),
			(u32(42886) | u32(2147483648)), u32(42891), u32(42893), u32(42896), u32(42898),
			u32((42902 | 1073741824)), (u32(42920) | u32(2147483648)), u32(42922), u32(42923),
			u32(42924), u32(42925), u32(42926), u32(42928), u32(42929), u32(42930), u32(42931),
			u32((42932 | 1073741824)), (u32(42946) | u32(2147483648)), u32(42948), u32(42949),
			u32(42950), u32(42951), u32(42953), u32(42955), u32((42956 | 1073741824)),
			(u32(42970) | u32(2147483648)), u32(42972), u32(42973), u32(42978), u32(42997), u32(43884),
			u32(43885), u32((43888 | 1073741824)), (u32(43967) | u32(2147483648)),
			u32((65313 | 1073741824)), (u32(65338) | u32(2147483648)), u32((66560 | 1073741824)),
			(u32(66599) | u32(2147483648)), u32((66736 | 1073741824)), (u32(66771) | u32(2147483648)),
			u32((66928 | 1073741824)), (u32(66938) | u32(2147483648)), u32((66940 | 1073741824)),
			(u32(66954) | u32(2147483648)), u32((66956 | 1073741824)), (u32(66962) | u32(2147483648)),
			u32(66964), u32(66965), u32((68736 | 1073741824)), (u32(68786) | u32(2147483648)),
			u32((68944 | 1073741824)), (u32(68965) | u32(2147483648)), u32((71840 | 1073741824)),
			(u32(71871) | u32(2147483648)), u32((93760 | 1073741824)), (u32(93791) | u32(2147483648)),
			u32((93856 | 1073741824)), (u32(93880) | u32(2147483648)), u32(122688), u32(122696),
			u32(122698), u32(122701), u32(122705), u32((122728 | 1073741824)),
			(u32(122734) | u32(2147483648)), u32((122738 | 1073741824)),
			(u32(122750) | u32(2147483648)), u32((125184 | 1073741824)),
			(u32(125217) | u32(2147483648))]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_1[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32(97), u32(122), u32(956), u32(224), u32(246), u32(248), u32(254),
			u32(257), u32(303), u32(307), u32(311), u32(314), u32(328), u32(331), u32(375), u32(255),
			u32(378), u32(382), u32(115), u32(595), u32(387), u32(389), u32(596), u32(392), u32(598),
			u32(599), u32(396), u32(477), u32(601), u32(603), u32(402), u32(608), u32(611), u32(617),
			u32(616), u32(409), u32(623), u32(626), u32(629), u32(417), u32(421), u32(640), u32(424),
			u32(643), u32(429), u32(648), u32(432), u32(650), u32(651), u32(436), u32(438), u32(658),
			u32(441), u32(445), u32(454), u32(454), u32(457), u32(457), u32(460), u32(460), u32(476),
			u32(479), u32(495), u32(499), u32(499), u32(501), u32(405), u32(447), u32(505), u32(543),
			u32(414), u32(547), u32(563), u32(11365), u32(572), u32(410), u32(11366), u32(578),
			u32(384), u32(649), u32(652), u32(583), u32(591), u32(953), u32(881), u32(883), u32(887),
			u32(1011), u32(940), u32(941), u32(943), u32(972), u32(973), u32(974), u32(945), u32(961),
			u32(963), u32(971), u32(963), u32(983), u32(946), u32(952), u32(966), u32(960), u32(985),
			u32(1007), u32(954), u32(961), u32(952), u32(949), u32(1016), u32(1010), u32(1019),
			u32(891), u32(893), u32(1104), u32(1119), u32(1072), u32(1103), u32(1121), u32(1153),
			u32(1163), u32(1215), u32(1231), u32(1218), u32(1230), u32(1233), u32(1327), u32(1377),
			u32(1414), u32(11520), u32(11557), u32(11559), u32(11565), u32(5104), u32(5109), u32(1074),
			u32(1076), u32(1086), u32(1089), u32(1090), u32(1090), u32(1098), u32(1123), u32(42571),
			u32(7306), u32(4304), u32(4346), u32(4349), u32(4351), u32(7681), u32(7829), u32(7777),
			u32(7841), u32(7935), u32(7936), u32(7943), u32(7952), u32(7957), u32(7968), u32(7975),
			u32(7984), u32(7991), u32(8000), u32(8005), u32(8017), u32(8019), u32(8021), u32(8023),
			u32(8032), u32(8039), u32(8112), u32(8113), u32(8048), u32(8049), u32(953), u32(8050),
			u32(8053), u32(8144), u32(8145), u32(8054), u32(8055), u32(8160), u32(8161), u32(8058),
			u32(8059), u32(8165), u32(8056), u32(8057), u32(8060), u32(8061), u32(969), u32(107),
			u32(229), u32(8526), u32(8560), u32(8575), u32(8580), u32(9424), u32(9449), u32(11312),
			u32(11359), u32(11361), u32(619), u32(7549), u32(637), u32(11368), u32(11372), u32(593),
			u32(625), u32(592), u32(594), u32(11379), u32(11382), u32(575), u32(576), u32(11393),
			u32(11491), u32(11500), u32(11502), u32(11507), u32(42561), u32(42605), u32(42625),
			u32(42651), u32(42787), u32(42799), u32(42803), u32(42863), u32(42874), u32(42876),
			u32(7545), u32(42879), u32(42887), u32(42892), u32(613), u32(42897), u32(42899),
			u32(42903), u32(42921), u32(614), u32(604), u32(609), u32(620), u32(618), u32(670),
			u32(647), u32(669), u32(43859), u32(42933), u32(42947), u32(42900), u32(642), u32(7566),
			u32(42952), u32(42954), u32(612), u32(42957), u32(42971), u32(411), u32(631), u32(636),
			u32(42998), u32(43851), u32(43852), u32(5024), u32(5103), u32(65345), u32(65370),
			u32(66600), u32(66639), u32(66776), u32(66811), u32(66967), u32(66977), u32(66979),
			u32(66993), u32(66995), u32(67001), u32(67003), u32(67004), u32(68800), u32(68850),
			u32(68976), u32(68997), u32(71872), u32(71903), u32(93792), u32(93823), u32(93883),
			u32(93907), u32(122689), u32(122697), u32(122699), u32(122702), u32(122706), u32(122729),
			u32(122735), u32(122739), u32(122751), u32(125218), u32(125251)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_1_data[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32(223), u32(304), u32(329), u32(496), u32(1415), u32(7830), u32(7831),
			u32(7832), u32(7833), u32(7834), u32(7838), u32(8016), u32((8064 | 1073741824)),
			(u32(8071) | u32(2147483648)), u32((8072 | 1073741824)), (u32(8079) | u32(2147483648)),
			u32((8080 | 1073741824)), (u32(8087) | u32(2147483648)), u32((8088 | 1073741824)),
			(u32(8095) | u32(2147483648)), u32((8096 | 1073741824)), (u32(8103) | u32(2147483648)),
			u32((8104 | 1073741824)), (u32(8111) | u32(2147483648)), u32(8114), u32(8115), u32(8116),
			u32(8118), u32(8124), u32(8130), u32(8131), u32(8132), u32(8134), u32(8140), u32(8150),
			u32(8164), u32(8166), u32(8178), u32(8179), u32(8180), u32(8182), u32(8188), u32(64256),
			u32(64257), u32(64258), u32(64261), u32(64262), u32(64275), u32(64276), u32(64277),
			u32(64278), u32(64279), u32(122773)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_2[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32(115), u32(115), u32(105), u32(775), u32(700), u32(110), u32(106),
			u32(780), u32(1381), u32(1410), u32(104), u32(817), u32(116), u32(776), u32(119), u32(778),
			u32(121), u32(778), u32(97), u32(702), u32(115), u32(115), u32(965), u32(787), u32(7936),
			u32(953), u32(7943), u32(953), u32(7936), u32(953), u32(7943), u32(953), u32(7968),
			u32(953), u32(7975), u32(953), u32(7968), u32(953), u32(7975), u32(953), u32(8032),
			u32(953), u32(8039), u32(953), u32(8032), u32(953), u32(8039), u32(953), u32(8048),
			u32(953), u32(945), u32(953), u32(940), u32(953), u32(945), u32(834), u32(945), u32(953),
			u32(8052), u32(953), u32(951), u32(953), u32(942), u32(953), u32(951), u32(834), u32(951),
			u32(953), u32(953), u32(834), u32(961), u32(787), u32(965), u32(834), u32(8060), u32(953),
			u32(969), u32(953), u32(974), u32(953), u32(969), u32(834), u32(969), u32(953), u32(102),
			u32(102), u32(102), u32(105), u32(102), u32(108), u32(115), u32(116), u32(115), u32(116),
			u32(1396), u32(1398), u32(1396), u32(1381), u32(1396), u32(1387), u32(1406), u32(1398),
			u32(1396), u32(1389), u32(115), u32(115)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_2_data[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32(912), u32(944), u32(8018), u32(8020), u32(8022), u32(8119), u32(8135),
			u32(8146), u32(8147), u32(8151), u32(8162), u32(8163), u32(8167), u32(8183), u32(64259),
			u32(64260)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_3[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [u32(953), u32(776), u32(769), u32(965), u32(776), u32(769), u32(965),
			u32(787), u32(768), u32(965), u32(787), u32(769), u32(965), u32(787), u32(834), u32(945),
			u32(834), u32(953), u32(951), u32(834), u32(953), u32(953), u32(776), u32(768), u32(953),
			u32(776), u32(769), u32(953), u32(776), u32(834), u32(965), u32(776), u32(768), u32(965),
			u32(776), u32(769), u32(965), u32(776), u32(834), u32(969), u32(834), u32(953), u32(102),
			u32(102), u32(105), u32(102), u32(102), u32(108)]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_3_data[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [AnonStruct_808_40643{
			map_:         unsafe { &md_get_unicode_fold_info_fold_map_1[0] }
			data:         unsafe { &md_get_unicode_fold_info_fold_map_1_data[0] }
			map_size:     302
			n_codepoints: u32(1)
		}, AnonStruct_808_40643{
			map_:         unsafe { &md_get_unicode_fold_info_fold_map_2[0] }
			data:         unsafe { &md_get_unicode_fold_info_fold_map_2_data[0] }
			map_size:     53
			n_codepoints: u32(2)
		}, AnonStruct_808_40643{
			map_:         unsafe { &md_get_unicode_fold_info_fold_map_3[0] }
			data:         unsafe { &md_get_unicode_fold_info_fold_map_3_data[0] }
			map_size:     16
			n_codepoints: u32(3)
		}]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_get_unicode_fold_info_fold_map_list[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		C.memcpy(&md_is_html_cdata_open_str[0], c'<![CDATA[', 10)
	}
	if true {
		c2v_static_init := [AnonStruct_3510_131083{
			scheme:      c'http'
			scheme_size: Size(4)
			suffix:      c'//'
			suffix_size: Size(2)
		}, AnonStruct_3510_131083{
			scheme:      c'https'
			scheme_size: Size(5)
			suffix:      c'//'
			suffix_size: Size(2)
		}, AnonStruct_3510_131083{
			scheme:      c'ftp'
			scheme_size: Size(3)
			suffix:      c'//'
			suffix_size: Size(2)
		}]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_collect_marks_scheme_map[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		c2v_static_init := [Align.default_, Align.left, Align.right, Align.center]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_analyze_table_alignment_align_map[c2v_i_0] = c2v_element_0
		}
	}
	if true {
		C.memcpy(&md_process_verbatim_block_contents_indent_chunk_str[0], c'                ', 17)
	}
	if true {
		c2v_static_init := [unsafe { &a6[0] }, unsafe { &b6[0] }, unsafe { &c6[0] }, unsafe { &d6[0] },
			unsafe { &xx[0] }, unsafe { &f6[0] }, unsafe { &xx[0] }, unsafe { &h6[0] },
			unsafe { &i6[0] }, unsafe { &xx[0] }, unsafe { &xx[0] }, unsafe { &l6[0] },
			unsafe { &m6[0] }, unsafe { &n6[0] }, unsafe { &o6[0] }, unsafe { &p6[0] },
			unsafe { &xx[0] }, unsafe { &xx[0] }, unsafe { &s6[0] }, unsafe { &t6[0] },
			unsafe { &u6[0] }, unsafe { &xx[0] }, unsafe { &xx[0] }, unsafe { &xx[0] },
			unsafe { &xx[0] }, unsafe { &xx[0] }]
		for c2v_i_0, c2v_element_0 in c2v_static_init {
			md_is_html_block_start_condition_map6[c2v_i_0] = c2v_element_0
		}
	}
}
