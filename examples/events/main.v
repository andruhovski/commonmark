module main

import os
import commonmark

// This example prints MD4C's event stream. Text is hexadecimal so embedded
// NULs and line endings are represented without loss.
fn trace_block_enter(kind commonmark.BlockType, detail voidptr, data voidptr) i32 {
	println('B+ ${int(kind)}')
	trace_block_detail(kind, detail)
	return 0
}

fn trace_block_leave(kind commonmark.BlockType, detail voidptr, data voidptr) i32 {
	println('B- ${int(kind)}')
	trace_block_detail(kind, detail)
	return 0
}

fn trace_span_enter(kind commonmark.SpanType, detail voidptr, data voidptr) i32 {
	println('S+ ${int(kind)}')
	trace_span_detail(kind, detail)
	return 0
}

fn trace_span_leave(kind commonmark.SpanType, detail voidptr, data voidptr) i32 {
	println('S- ${int(kind)}')
	trace_span_detail(kind, detail)
	return 0
}

fn trace_text(kind commonmark.TextType, text &commonmark.Char, size commonmark.Size, data voidptr) i32 {
	bytes := unsafe { tos(&u8(text), int(size)) }.bytes()
	println('T ${int(kind)} ${bytes.hex()}')
	return 0
}

fn main() {
	input := if os.args.len > 1 {
		os.read_file(os.args[1]) or {
			eprintln(err)
			exit(1)
		}
	} else {
		os.get_raw_stdin().bytestr()
	}
	flags := if os.args.len > 2 { os.args[2].u32() } else { u32(0) }
	parser := commonmark.Parser{
		flags:       flags
		enter_block: trace_block_enter
		leave_block: trace_block_leave
		enter_span:  trace_span_enter
		leave_span:  trace_span_leave
		text:        trace_text
	}
	result := commonmark.parse(input, &parser, unsafe { nil })
	if result != 0 {
		eprintln('Parsing failed: ${result}')
		exit(1)
	}
}

fn trace_attribute(a commonmark.Attribute) {
	text := if a.size == 0 { '' } else { unsafe { tos(&u8(a.text), int(a.size)) }.bytes().hex() }
	print('A ${text}')
	mut i := 0
	for a.size > 0 && unsafe { a.substr_offsets[i] } < a.size {
		print(' ${unsafe { int(a.substr_types[i]) }}:${unsafe { a.substr_offsets[i] }}')
		i++
	}
	println(' ${a.size}')
}

fn trace_block_detail(kind commonmark.BlockType, detail voidptr) {
	unsafe {
		match kind {
			.h {
				d := &commonmark.BlockHeadingDetail(detail)
				println('D ${d.level}')
			}
			.ul {
				d := &commonmark.BlockUlDetail(detail)
				println('D ${d.is_tight} ${int(d.mark)}')
			}
			.ol {
				d := &commonmark.BlockOlDetail(detail)
				println('D ${d.start} ${d.is_tight} ${int(d.mark_delimiter)}')
			}
			.li {
				d := &commonmark.BlockLiDetail(detail)
				println('D ${d.is_task}')
				if d.is_task != 0 { println('D ${int(d.task_mark)} ${d.task_mark_offset}') }
			}
			.code {
				d := &commonmark.BlockCodeDetail(detail)
				println('D ${int(d.fence_char)}')
				trace_attribute(d.info)
				trace_attribute(d.lang)
			}
			.table {
				d := &commonmark.BlockTableDetail(detail)
				println('D ${d.col_count} ${d.head_row_count} ${d.body_row_count}')
			}
			.th, .td {
				d := &commonmark.BlockCellDetail(detail)
				println('D ${int(d.align)}')
			}
			.admonition {
				d := &commonmark.BlockAdmonitionDetail(detail)
				trace_attribute(d.type_)
			}
			.footnote_def {
				d := &commonmark.BlockFootnoteDefDetail(detail)
				println('D ${d.id} ${d.ref_count}')
				trace_attribute(d.label)
			}
			.blank {
				d := &commonmark.BlockBlankDetail(detail)
				println('D ${d.line_count}')
			}
			else {}
		}
	}
}

fn trace_span_detail(kind commonmark.SpanType, detail voidptr) {
	unsafe {
		match kind {
			.a {
				d := &commonmark.SpanLinkDetail(detail)
				println('D ${d.is_autolink}')
				trace_attribute(d.href)
				trace_attribute(d.title)
			}
			.img {
				d := &commonmark.SpanImageDetail(detail)
				trace_attribute(d.src)
				trace_attribute(d.title)
			}
			.wikilink {
				d := &commonmark.SpanWikiLinkDetail(detail)
				trace_attribute(d.target)
			}
			.footnote_ref {
				d := &commonmark.SpanFootnoteRefDetail(detail)
				println('D ${d.id} ${d.ref_id}')
				trace_attribute(d.label)
			}
			else {}
		}
	}
}
