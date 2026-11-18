module main

fn test_commonmark_rendering() {
	assert convert('# Hello, *V*!\n\nA &copy; &amp; &#0; &unknown; <b>x</b>.\n', Options{})! == '<h1>Hello, <em>V</em>!</h1>\n<p>A © &amp; � &amp;unknown; <b>x</b>.</p>\n'
	assert convert('a  \nb\nc', Options{})! == '<p>a<br>\nb\nc</p>\n'
	assert convert('```v\na < b & c\n```', Options{})! == '<pre><code class="language-v">a &lt; b &amp; c\n</code></pre>\n'
	assert convert('a\x00b', Options{})! == '<p>a�b</p>\n'
}

fn test_lists_and_nested_image_alt() {
	assert convert('- one\n- two', Options{})! == '<ul>\n<li>one</li>\n<li>two</li>\n</ul>\n'
	assert convert('- one\n\n- two', Options{})! == '<ul>\n<li><p>one</p>\n</li>\n<li><p>two</p>\n</li>\n</ul>\n'
	assert convert('![a *b* ![c](nested)](image "a &quot; title")', Options{})! == '<p><img src="image" alt="a b c" title="a &#34; title"></p>\n'
	assert convert('- > quote', Options{})!.contains('<blockquote>\n<p>quote</p>\n')
}

fn test_full_document_and_xhtml() {
	options := parse_options(['-f', '-x', '--html-title=<Title>', '--html-css=a&b.css'])!
	output := convert('---\n\n![x](a)\n\na  \nb', options)!
	assert output.starts_with('<?xml version="1.0" encoding="UTF-8"?>')
	assert output.contains('<title>&lt;Title&gt;</title>')
	assert output.contains('href="a&amp;b.css" />')
	assert output.contains('<hr />')
	assert output.contains('<img src="a" alt="x" />')
	assert output.contains('<br />')
	assert output.ends_with('</body>\n</html>\n')
}

fn test_extensions() {
	options := parse_options(['--gfm', '--fhighlight', '--finsert', '--flatex-math', '--fwiki-links',
		'--fspoilers', '--fsuperscripts', '--fsubscripts'])!
	output := convert('- [x] done\n\n~~old~~ ==hi== ++new++ ||secret|| ^up^ ~down~ $x$ [[target|label]]\n\na | b\n:-|--:\nx | y\n\nref[^a] and again[^a]\n\n[^a]: note', options)!
	for fragment in ['checked="checked"', '<del>old</del>', '<mark>hi</mark>', '<ins>new</ins>',
		'<span class="spoiler">secret</span>', '<sup>up</sup>', '<sub>down</sub>', '\\(x\\)',
		'href="target"', '<table>', 'align="right"', 'id="fn-1"', 'id="fnref-1-2"', 'href="#fnref-1-2"'] {
		assert output.contains(fragment), fragment
	}
	assert convert('&copy;', parse_options(['--fverbatim-entities'])!)! == '<p>&copy;</p>\n'
	assert convert('<b>x</b>', parse_options(['--fno-html'])!)! == '<p>&lt;b&gt;x&lt;/b&gt;</p>\n'
	assert convert('a\nb', parse_options(['--fhard-soft-breaks'])!)! == '<p>a<br>\nb</p>\n'
}

fn test_option_handling() {
	options := parse_options(['--gfm', '--commonmark', '--ftables', '-oout.html', '--html-title',
		'A=B', '--html-css=x', '--html-css', 'y', '--', '-input.md'])!
	assert options.flags == extension_flags()['tables']
	assert options.output == 'out.html'
	assert options.input == '-input.md'
	assert options.title == 'A=B'
	assert options.css == ['x', 'y']
	for args in [['--unknown'], ['--funknown'], ['-o'], ['--html-title'], ['a', 'b'], ['--output=']] {
		if _ := parse_options(args) {
			assert false, 'accepted invalid arguments: ${args}'
		}
	}
	for name, flag in extension_flags() {
		assert parse_options(['--f${name}'])!.flags == flag
	}
	assert parse_options(['-h'])!.help
	assert parse_options(['-v'])!.version
	assert parse_options(['-s'])!.stat
	assert parse_options(['--github'])!.flags == parse_options(['--gfm'])!.flags
}

fn test_attribute_entities() {
	options := parse_options(['--fverbatim-entities'])!
	assert convert('[x](a&amp;b "&copy;")', options)! == '<p><a href="a&amp;b" title="&copy;">x</a></p>\n'
	assert convert('[x](a&amp;b "&copy;")', Options{})! == '<p><a href="a&amp;b" title="©">x</a></p>\n'
}
