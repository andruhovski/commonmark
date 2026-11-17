module commonmark

// Parser flags retain the names and bit values of md4c.h.
pub const flag_collapsewhitespace = u32(0x1)
pub const flag_permissiveatxheaders = u32(0x2)
pub const flag_permissiveurlautolinks = u32(0x4)
pub const flag_permissiveemailautolinks = u32(0x8)
pub const flag_noindentedcodeblocks = u32(0x10)
pub const flag_nohtmlblocks = u32(0x20)
pub const flag_nohtmlspans = u32(0x40)
pub const flag_tables = u32(0x100)
pub const flag_strikethrough = u32(0x200)
pub const flag_permissivewwwautolinks = u32(0x400)
pub const flag_tasklists = u32(0x800)
pub const flag_latexmathspans = u32(0x1000)
pub const flag_wikilinks = u32(0x2000)
pub const flag_underline = u32(0x4000)
pub const flag_hard_soft_breaks = u32(0x8000)
pub const flag_spoilers = u32(0x10000)
pub const flag_superscripts = u32(0x20000)
pub const flag_subscripts = u32(0x40000)
pub const flag_admonitions = u32(0x80000)
pub const flag_footnotes = u32(0x100000)
pub const flag_highlight = u32(0x200000)
pub const flag_preserveblanklines = u32(0x400000)
pub const flag_insert = u32(0x800000)
pub const flag_permissiveautolinks = flag_permissiveemailautolinks | flag_permissiveurlautolinks | flag_permissivewwwautolinks
pub const flag_nohtml = flag_nohtmlblocks | flag_nohtmlspans
pub const dialect_commonmark = u32(0)
pub const dialect_github = flag_permissiveautolinks | flag_tables | flag_strikethrough | flag_tasklists | flag_admonitions | flag_footnotes

// parse accepts a V string and invokes the Parser callbacks synchronously.
// Like parse_raw, it returns 0 on success, -1 on parser failure, or the first
// nonzero callback result. Callback text and detail pointers are temporary.
pub fn parse(markdown string, parser &Parser, userdata voidptr) int {
	if u64(markdown.len) > u64(0xffffffff) { return -1 }
	return int(parse_raw(unsafe { &Char(markdown.str) }, Size(markdown.len), parser, userdata))
}

// str copies the attribute's UTF-8 bytes into an owned V string.
// Entity references remain encoded as in the source. Call this while the
// callback's attribute pointers are valid to retain the value after parsing.
pub fn (attribute Attribute) str() string {
	if attribute.size == 0 { return '' }
	return unsafe { tos(&u8(attribute.text), int(attribute.size)) }.clone()
}
