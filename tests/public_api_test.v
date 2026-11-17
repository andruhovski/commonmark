module main

import commonmark

struct Capture {
mut:
	text     string
	links    []string
	headings []u32
}

fn on_block(kind commonmark.BlockType, detail voidptr, data voidptr) i32 {
	if kind == .h {
		mut captured := unsafe { &Capture(data) }
		captured.headings << unsafe { &commonmark.BlockHeadingDetail(detail) }.level
	}
	return 0
}

fn leave_block(_ commonmark.BlockType, _ voidptr, _ voidptr) i32 { return 0 }

fn on_span(kind commonmark.SpanType, detail voidptr, data voidptr) i32 {
	if kind == .a {
		mut captured := unsafe { &Capture(data) }
		captured.links << unsafe { &commonmark.SpanLinkDetail(detail) }.href.str()
	}
	return 0
}

fn leave_span(_ commonmark.SpanType, _ voidptr, _ voidptr) i32 { return 0 }

fn on_text(_ commonmark.TextType, text &commonmark.Char, size commonmark.Size, data voidptr) i32 {
	mut captured := unsafe { &Capture(data) }
	captured.text += unsafe { tos(&u8(text), int(size)) }
	return 0
}

fn test_public_api_from_another_module() {
	mut captured := Capture{}
	parser := commonmark.Parser{
		flags:       commonmark.dialect_github
		enter_block: on_block
		leave_block: leave_block
		enter_span:  on_span
		leave_span:  leave_span
		text:        on_text
	}
	assert commonmark.parse('# Hello [V](https://vlang.io)', &parser, &captured) == 0
	assert captured.text == 'Hello V'
	assert captured.headings == [u32(1)]
	assert captured.links == ['https://vlang.io']
	// The attribute string is owned by the caller, even after parser cleanup.
	assert captured.links[0].len == 16
}
