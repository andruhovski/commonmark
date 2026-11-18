module main

import commonmark
import os

const version = 'md2html 0.0.1'

struct Options {
mut:
	flags    u32
	output   string
	input    string
	full     bool
	xhtml    bool
	stat     bool
	help     bool
	version  bool
	verbatim bool
	title    string = 'Markdown document'
	css      []string
}

fn extension_flags() map[string]u32 {
	return {
		'collapse-whitespace':        commonmark.flag_collapsewhitespace
		'permissive-atx-headers':     commonmark.flag_permissiveatxheaders
		'permissive-url-autolinks':   commonmark.flag_permissiveurlautolinks
		'permissive-email-autolinks': commonmark.flag_permissiveemailautolinks
		'permissive-www-autolinks':   commonmark.flag_permissivewwwautolinks
		'permissive-autolinks':       commonmark.flag_permissiveautolinks
		'no-indented-code':           commonmark.flag_noindentedcodeblocks
		'no-html-blocks':             commonmark.flag_nohtmlblocks
		'no-html-spans':              commonmark.flag_nohtmlspans
		'no-html':                    commonmark.flag_nohtml
		'tables':                     commonmark.flag_tables
		'strikethrough':              commonmark.flag_strikethrough
		'tasklists':                  commonmark.flag_tasklists
		'latex-math':                 commonmark.flag_latexmathspans
		'wiki-links':                 commonmark.flag_wikilinks
		'underline':                  commonmark.flag_underline
		'hard-soft-breaks':           commonmark.flag_hard_soft_breaks
		'spoilers':                   commonmark.flag_spoilers
		'superscripts':               commonmark.flag_superscripts
		'subscripts':                 commonmark.flag_subscripts
		'admonitions':                commonmark.flag_admonitions
		'footnotes':                  commonmark.flag_footnotes
		'highlight':                  commonmark.flag_highlight
		'preserve-blank-lines':       commonmark.flag_preserveblanklines
		'insert':                     commonmark.flag_insert
	}
}

fn parse_options(args []string) !Options {
	mut options := Options{}
	mut positional := false
	mut have_input := false
	mut i := 0
	flags := extension_flags()
	for i < args.len {
		arg := args[i]
		i++
		if !positional && arg == '--' {
			positional = true
			continue
		}
		if !positional && arg.starts_with('-') && arg != '-' {
			if arg == '-o' || arg == '--output' || arg == '--html-title' || arg == '--html-css' || arg.starts_with('--output=') || arg.starts_with('--html-title=') || arg.starts_with('--html-css=') || (arg.starts_with('-o') && !arg.starts_with('--')) {
				name := if arg.starts_with('-o') && !arg.starts_with('--') {
					'--output'
				} else {
					arg.all_before('=')
				}
				mut value := ''
				if arg.contains('=') {
					value = arg.all_after('=')
				} else if arg.starts_with('-o') && arg.len > 2 {
					value = arg[2..]
				} else {
					if i >= args.len { return error('missing value for ${arg}') }
					value = args[i]
					i++
				}
				match name {
					'--output' {
						if value == '' { return error('output filename cannot be empty') }
						options.output = value
					}
					'--html-title' { options.title = value }
'--html-css' {
	if value == '' { return error('CSS URL cannot be empty') }
	options.css << value
}
					else {}
				}
				continue
			}
			match arg {
				'-h', '--help' { options.help = true }
				'-v', '--version' { options.version = true }
				'-f', '--full-html' { options.full = true }
				'-x', '--xhtml' { options.xhtml = true }
				'-s', '--stat' { options.stat = true }
				'--commonmark' { options.flags = commonmark.dialect_commonmark }
				'--gfm', '--github' { options.flags = commonmark.dialect_github }
				'--fverbatim-entities' { options.verbatim = true }
				else {
					if arg.starts_with('--f') {
						if flag := flags[arg[3..]] {
							options.flags |= flag
						} else {
							return error('unknown option: ${arg}')
						}
					} else {
						return error('unknown option: ${arg}')
					}
				}
			}
		} else {
			if have_input { return error('only one input file is allowed') }
			options.input = arg
			have_input = true
		}
	}
	return options
}

fn help_text() string {
	mut text := 'Usage: md2html [OPTION]... [FILE]\nConvert input FILE (or standard input) in Markdown format to HTML.\n\nGeneral options:\n  -o, --output=FILE    Output file (default is standard output)\n  -f, --full-html      Generate full HTML document, including header\n  -x, --xhtml          Generate XHTML instead of HTML\n  -s, --stat           Measure time of input parsing (on standard error)\n  -h, --help           Display this help and exit\n  -v, --version        Display version and exit\n\nMarkdown dialect options:\n      --commonmark     CommonMark (default)\n      --gfm, --github  Github Flavored Markdown\n\nMarkdown extension and suppression options:\n'
	descriptions := {
		'admonitions':                'Enable admonitions'
		'collapse-whitespace':        'Collapse non-trivial whitespace'
		'footnotes':                  'Enable footnote references ([^label])'
		'hard-soft-breaks':           'Force all soft breaks to act as hard breaks'
		'highlight':                  'Enable highlight spans (==text==)'
		'insert':                     'Enable insert spans (++text++)'
		'latex-math':                 'Enable LaTeX style mathematics spans'
		'permissive-atx-headers':     'Allow ATX headers without delimiting space'
		'permissive-email-autolinks': 'Allow email autolinks without angle brackets or mailto:'
		'permissive-url-autolinks':   'Allow URL autolinks without angle brackets'
		'permissive-www-autolinks':   'Allow WWW autolinks without a scheme'
		'permissive-autolinks':       'Enable email, URL, and WWW autolinks'
		'preserve-blank-lines':       'Render extra blank lines between blocks as <br>'
		'spoilers':                   'Enable spoiler spans (||hidden text||)'
		'strikethrough':              'Enable strike-through spans (~~text~~)'
		'subscripts':                 'Enable subscript spans (~text~)'
		'superscripts':               'Enable superscript spans (^text^)'
		'tables':                     'Enable tables'
		'tasklists':                  'Enable task lists'
		'underline':                  'Enable underline spans'
		'wiki-links':                 'Enable wiki links'
		'no-html-blocks':             'Disable raw HTML blocks'
		'no-html-spans':              'Disable raw HTML spans'
		'no-html':                    'Disable raw HTML blocks and spans'
		'no-indented-code':           'Disable indented code blocks'
	}
	for name, description in descriptions {
		text += '      --f${name}\n                        ${description}\n'
	}
	return text + '\nHTML generator options:\n      --fverbatim-entities  Do not translate entities\n      --html-title=TITLE   Set the document title\n      --html-css=URL       Add a CSS link in full document mode (repeatable)\n\nUse - for standard input/output; -- ends option processing.\nDialect presets replace previously selected Markdown flags.\n'
}

fn main() {
	options := parse_options(os.args[1..]) or {
		eprintln('md2html: ${err}')
		exit(1)
	}
	if options.help {
		print(help_text())
		return
	}
	if options.version {
		println(version)
		return
	}
	input := if options.input == '' || options.input == '-' {
		os.get_raw_stdin().bytestr()
	} else {
		os.read_file(options.input) or {
			eprintln('md2html: ${err}')
			exit(1)
		}
	}
	output := convert(input, options) or {
		eprintln('md2html: ${err}')
		exit(1)
	}
	if options.output == '' || options.output == '-' {
		print(output)
	} else {
		os.write_file(options.output, output) or {
			eprintln('md2html: ${err}')
			exit(1)
		}
	}
}
