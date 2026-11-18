module main

import commonmark
import encoding.html
import strings
import time

struct Renderer {
mut:
	blocks      []commonmark.BlockType
	out         strings.Builder
	xhtml       bool
	verbatim    bool
	tight       []bool
	image_depth int
	image_title string
}

fn (r Renderer) end_void() string {
	return if r.xhtml { ' />' } else { '>' }
}

fn (r Renderer) attribute(a commonmark.Attribute) string {
	if !r.verbatim { return r.escape_value(a.str()) }
	if a.size == 0 { return '' }
	value := a.str()
	mut result := strings.new_builder(value.len)
	mut i := 0
	unsafe {
		for a.substr_offsets[i] < a.size {
			start := int(a.substr_offsets[i])
			end := int(a.substr_offsets[i + 1])
			match a.substr_types[i] {
				.entity { result.write_string(value[start..end]) }
				.nullchar { result.write_string('�') }
				else { result.write_string(html.escape(value[start..end])) }
			}
			i++
		}
	}
	return result.str()
}

fn (r Renderer) escape_value(s string) string {
	value := s.replace('\x00', '�')
	return html.escape(if r.verbatim { value } else { html.unescape(value, all: true) })
}

fn enter_block(kind commonmark.BlockType, detail voidptr, data voidptr) i32 {
	mut r := unsafe { &Renderer(data) }
	unsafe {
		match kind {
			.doc, .html {}
			.quote { r.out.write_string('<blockquote>\n') }
			.ul {
				d := &commonmark.BlockUlDetail(detail)
				r.tight << (d.is_tight != 0)
				r.out.write_string('<ul>\n')
			}
			.ol {
				d := &commonmark.BlockOlDetail(detail)
				r.tight << (d.is_tight != 0)
				r.out.write_string(if d.start == 1 { '<ol>\n' } else { '<ol start="${d.start}">\n' })
			}
			.li {
				d := &commonmark.BlockLiDetail(detail)
				r.out.write_string(if d.is_task != 0 {
					'<li class="task-list-item">'
				} else {
					'<li>'
				})
				if d.is_task != 0 {
					r.out.write_string('<input type="checkbox" disabled="disabled"')
					if d.task_mark == `x` || d.task_mark == `X` {
						r.out.write_string(' checked="checked"')
					}
					r.out.write_string(r.end_void() + ' ')
				}
			}
			.hr { r.out.write_string('<hr' + r.end_void() + '\n') }
			.h {
				d := &commonmark.BlockHeadingDetail(detail)
				r.out.write_string('<h${d.level}>')
			}
			.p {
				if r.tight.len == 0 || !r.tight.last() || r.blocks.len == 0 || r.blocks.last() != .li {
					r.out.write_string('<p>')
				}
			}
			.code {
				d := &commonmark.BlockCodeDetail(detail)
				r.out.write_string('<pre><code')
				if d.lang.size > 0 {
					r.out.write_string(' class="language-${r.attribute(d.lang)}"')
				}
				r.out.write_string('>')
			}
			.table { r.out.write_string('<table>\n') }
			.thead { r.out.write_string('<thead>\n') }
			.tbody { r.out.write_string('<tbody>\n') }
			.tr { r.out.write_string('<tr>\n') }
			.th, .td {
				d := &commonmark.BlockCellDetail(detail)
				r.out.write_string('<${kind}')
				if d.align != .default_ { r.out.write_string(' align="${d.align}"') }
				r.out.write_string('>')
			}
			.admonition {
				d := &commonmark.BlockAdmonitionDetail(detail)
				r.out.write_string('<div class="admonition ${r.attribute(d.type_)}">\n')
			}
			.blank {
				d := &commonmark.BlockBlankDetail(detail)
				for _ in 0 .. int(d.line_count) { r.out.write_string('<br' + r.end_void() + '\n') }
			}
			.footnote_def_section { r.out.write_string('<section class="footnotes">\n<ol>\n') }
			.footnote_def {
				d := &commonmark.BlockFootnoteDefDetail(detail)
				r.out.write_string('<li id="fn-${d.id}">\n')
			}
		}
	}
	r.blocks << kind
	return 0
}

fn leave_block(kind commonmark.BlockType, detail voidptr, data voidptr) i32 {
	mut r := unsafe { &Renderer(data) }
	r.blocks.pop()
	match kind {
		.doc, .html, .hr, .blank {}
		.ul, .ol {
			r.tight.pop()
			r.out.write_string('</${kind}>\n')
		}
		.quote { r.out.write_string('</blockquote>\n') }
		.li { r.out.write_string('</li>\n') }
		.h {
			d := unsafe { &commonmark.BlockHeadingDetail(detail) }
			r.out.write_string('</h${d.level}>\n')
		}
		.p {
			if r.tight.len == 0 || !r.tight.last() || r.blocks.len == 0 || r.blocks.last() != .li {
				r.out.write_string('</p>\n')
			}
		}
		.code { r.out.write_string('</code></pre>\n') }
		.table, .thead, .tbody, .tr, .th, .td { r.out.write_string('</${kind}>\n') }
		.admonition { r.out.write_string('</div>\n') }
		.footnote_def_section { r.out.write_string('</ol>\n</section>\n') }
		.footnote_def {
			d := unsafe { &commonmark.BlockFootnoteDefDetail(detail) }
			for i in 1 .. int(d.ref_count) + 1 {
				r.out.write_string(' <a href="#fnref-${d.id}-${i}" class="footnote-backref">↩</a>')
			}
			r.out.write_string('</li>\n')
		}
	}
	return 0
}

fn span_tag(kind commonmark.SpanType) string {
	return match kind {
		.em { 'em' }
		.strong { 'strong' }
		.code { 'code' }
		.ins { 'ins' }
		.del { 'del' }
		.u { 'u' }
		.superscript { 'sup' }
		.subscript { 'sub' }
		.mark { 'mark' }
		.a, .wikilink { 'a' }
		.latexmath, .latexmath_display, .spoiler { 'span' }
		else { '' }
	}
}

fn enter_span(kind commonmark.SpanType, detail voidptr, data voidptr) i32 {
	mut r := unsafe { &Renderer(data) }
	if r.image_depth > 0 {
		if kind == .img { r.image_depth++ }
		return 0
	}
	unsafe {
		match kind {
			.a {
				d := &commonmark.SpanLinkDetail(detail)
				r.out.write_string('<a href="${r.attribute(d.href)}"')
				if d.title.size > 0 { r.out.write_string(' title="${r.attribute(d.title)}"') }
				r.out.write_string('>')
			}
			.img {
				d := &commonmark.SpanImageDetail(detail)
				r.image_depth = 1
				r.image_title = r.attribute(d.title)
				r.out.write_string('<img src="${r.attribute(d.src)}" alt="')
			}
			.wikilink {
				d := &commonmark.SpanWikiLinkDetail(detail)
				r.out.write_string('<a class="wikilink" href="${r.attribute(d.target)}">')
			}
			.footnote_ref {
				d := &commonmark.SpanFootnoteRefDetail(detail)
				r.out.write_string('<sup class="footnote-ref"><a href="#fn-${d.id}" id="fnref-${d.id}-${d.ref_id}">${d.id}</a></sup>')
			}
			.latexmath { r.out.write_string('<span class="math">\\(') }
			.latexmath_display { r.out.write_string('<span class="math display">\\[') }
			.spoiler { r.out.write_string('<span class="spoiler">') }
			else { r.out.write_string('<${span_tag(kind)}>') }
		}
	}
	return 0
}

fn leave_span(kind commonmark.SpanType, _ voidptr, data voidptr) i32 {
	mut r := unsafe { &Renderer(data) }
	if r.image_depth > 0 {
		if kind == .img {
			r.image_depth--
			if r.image_depth == 0 {
				r.out.write_string('"')
				if r.image_title != '' { r.out.write_string(' title="${r.image_title}"') }
				r.out.write_string(r.end_void())
			}
		}
		return 0
	}
	if kind == .footnote_ref { return 0 }
	if kind == .latexmath { r.out.write_string('\\)') }
	if kind == .latexmath_display { r.out.write_string('\\]') }
	r.out.write_string('</${span_tag(kind)}>')
	return 0
}

fn render_text(kind commonmark.TextType, text &commonmark.Char, size commonmark.Size, data voidptr) i32 {
	mut r := unsafe { &Renderer(data) }
	s := unsafe { tos(&u8(text), int(size)) }
	match kind {
		.nullchar { r.out.write_string('�') }
		.br {
			r.out.write_string(if r.image_depth > 0 { ' ' } else { '<br' + r.end_void() + '\n' })
		}
		.softbr { r.out.write_string(if r.image_depth > 0 { ' ' } else { '\n' }) }
		.html { r.out.write_string(if r.image_depth > 0 { html.escape(s) } else { s }) }
		.entity { r.out.write_string(if r.verbatim { s } else { r.escape_value(s) }) }
		else { r.out.write_string(html.escape(s)) }
	}
	return 0
}

fn convert(input string, options Options) !string {
	mut renderer := Renderer{ out: strings.new_builder(input.len), xhtml: options.xhtml, verbatim: options.verbatim }
	parser := commonmark.Parser{ flags: options.flags, enter_block: enter_block, leave_block: leave_block, enter_span: enter_span, leave_span: leave_span, text: render_text }
	mut watch := time.new_stopwatch()
	result := commonmark.parse(input, &parser, &renderer)
	watch.stop()
	if options.stat { eprintln('Parsing time: ${watch.elapsed().microseconds()} µs') }
	if result != 0 { return error('Markdown parsing failed (${result})') }
	body := renderer.out.str()
	if !options.full { return body }
	start := if options.xhtml {
		'<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml">\n'
	} else {
		'<!DOCTYPE html>\n<html>\n'
	}
	mut document := start + '<head>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"' + renderer.end_void() + '\n<title>${html.escape(options.title)}</title>\n'
	for css in options.css {
		document += '<link rel="stylesheet" href="${html.escape(css)}"' + renderer.end_void() + '\n'
	}
	return document + '</head>\n<body>\n' + body + '</body>\n</html>\n'
}
