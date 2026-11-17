module commonmark

fn ignore_block(kind BlockType, detail voidptr, data voidptr) i32 { return 0 }

fn ignore_span(kind SpanType, detail voidptr, data voidptr) i32 { return 0 }

fn ignore_text(kind TextType, text &Char, size Size, data voidptr) i32 { return 0 }

fn test_parse_smoke() {
	parser := Parser{
		enter_block: ignore_block
		leave_block: ignore_block
		enter_span:  ignore_span
		leave_span:  ignore_span
		text:        ignore_text
	}
	input := '# Hello\n\nA *small* [link](https://example.com).\n'
	assert parse_raw(unsafe { &Char(input.str) }, Size(input.len), &parser, unsafe { nil }) == 0
}

struct TestCapture {
mut:
	events []string
	text   string
	links  []string
}

fn capture_block(kind BlockType, detail voidptr, data voidptr) i32 {
	mut c := unsafe { &TestCapture(data) }
	c.events << 'b${int(kind)}'
	if kind == .h {
		assert unsafe { &BlockHeadingDetail(detail) }.level == 1
	}
	return 0
}

fn capture_span(kind SpanType, detail voidptr, data voidptr) i32 {
	mut c := unsafe { &TestCapture(data) }
	c.events << 's${int(kind)}'
	if kind == .a {
		d := unsafe { &SpanLinkDetail(detail) }
		c.links << unsafe { tos(&u8(d.href.text), int(d.href.size)) }.clone()
	}
	return 0
}

fn capture_text(kind TextType, text &Char, size Size, data voidptr) i32 {
	mut c := unsafe { &TestCapture(data) }
	c.events << 't${int(kind)}'
	c.text += unsafe { tos(&u8(text), int(size)) }
	return 0
}

fn capture_parser(flags u32) Parser {
	return Parser{
		flags:       flags
		enter_block: capture_block
		leave_block: ignore_block
		enter_span:  capture_span
		leave_span:  ignore_span
		text:        capture_text
	}
}

fn test_callbacks_details_and_userdata() {
	mut c := TestCapture{}
	p := capture_parser(0)
	assert parse('# Hi *V* [link](/path) ![alt](image.png)', &p, &c) == 0
	assert c.text == 'Hi V link alt'
	assert c.events == ['b0', 'b6', 't0', 's0', 't0', 't0', 's2', 't0', 't0', 's3', 't0']
	assert c.links == ['/path']
}

fn abort_block(kind BlockType, detail voidptr, data voidptr) i32 { return 37 }

fn test_callback_abort_and_invalid_abi() {
	p := Parser{
		enter_block: abort_block
		leave_block: ignore_block
		enter_span:  ignore_span
		leave_span:  ignore_span
		text:        ignore_text
	}
	assert parse('Hello', &p, unsafe { nil }) == 37
	invalid := Parser{ abi_version: 1 }
	assert parse('Hello', &invalid, unsafe { nil }) == -1
}

fn test_unicode_reference_folding_and_repeated_parse() {
	p := capture_parser(0)
	for _ in 0 .. 3 {
		mut c := TestCapture{}
		assert parse('[Straße]: /unicode\n\n[STRASSE] Привіт 😀', &p, &c) == 0
		assert c.links == ['/unicode']
		assert c.text == 'STRASSE Привіт 😀'
	}
}

fn test_extensions_and_nul() {
	p := capture_parser(flag_strikethrough | flag_tables)
	mut c := TestCapture{}
	assert parse('~~gone~~\n\na | b\n--|--\nx | y', &p, &c) == 0
	assert 's6' in c.events
	assert 'b10' in c.events
	mut nul := TestCapture{}
	assert parse('a\x00b', &p, &nul) == 0
	assert 't1' in nul.events
}
