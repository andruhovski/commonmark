# Compare the V event stream with the original C parser.
# Requires V and Clang on PATH. All generated files stay in tests/.validation.
$root = Split-Path $PSScriptRoot -Parent
$dir = Join-Path $PSScriptRoot '.validation'
New-Item -ItemType Directory -Force $dir | Out-Null
$VParser = Join-Path $dir 'parser.exe'
$Reference = Join-Path $dir 'reference.exe'
& v -o $VParser (Join-Path $root 'examples/events') *> (Join-Path $dir 'build.log')
if ($LASTEXITCODE -ne 0) { throw 'V build failed; see tests/.validation/build.log' }
& clang -D_CRT_SECURE_NO_WARNINGS (Join-Path $PSScriptRoot 'reference/md4c.c') (Join-Path $PSScriptRoot 'reference/reference.c') -o $Reference
if ($LASTEXITCODE -ne 0) { throw 'C reference build failed' }
$ErrorActionPreference = 'Stop'
$fixtures = @(
 '', '# Hello', "a`n===`n", "a`n---`n", "---`n", "a  `nb`nc`n",
 '> quote', "> outer`n>> inner`n>`n> para`n", "- a`n- b`n`n  second para`n", "1. one`n2. two`n   - nested`n",
 "    indented`n`n    code`n", ('```v' + "`nx := 1`n" + '```'), ('~~~ lang title' + "`na`n~~~"),
 '*em* **strong** ***both*** a_b_c __strong__', '`` a ` b `` and ` code `', '\*literal\* &amp; &#0; &#x1f600;',
 '[link](url "title") ![alt](image.png)', ('[ref][id]' + "`n`n[id]: <https://example.com> 'title'"),
 '[missing] [nested *em*](a(b)c)', '<https://example.com> <a@example.com>', '<!-- comment --> <b>x</b>',
 "<script>`na < b`n</script>`n", "<div>`nraw`n</div>`n", '<![CDATA[x]]>', "a`0b",
 'Привіт *світ* Καλημέρα 中文 😀', "[Straße]: /x`n`n[STRASSE]", "[ΑΒΓ]: /x`n`n[αβγ]",
 "a | b`n:-|--:`nx | y", "- [x] done`n- [ ] todo", '~~gone~~ ==mark== ++new++ ||hidden|| ^sup^ ~sub~',
 '$a+b$ and $$x$$', '[[target|label]]', "[^id] twice[^id]`n`n[^id]: footnote`n    continuation",
 "> [!NOTE]`n> note`n", 'www.example.com https://example.com/a_(b) x@example.com',
 "`t- tab`r`n`r`nend`r", "`n`nblank`n`n`n", '#nospace',
 'a **b *c** d*', '[a [b](c)](d)', '![a [b](c)](d)'
)
$rng = [Random]::new(314159)
$tokens = @('*','_','`','[',']','(',')','<','>','&',';','~','|','$','=','+',':','!','a','b',' ',"`n", "`t",'1. ','- ')
for ($i=0; $i -lt 100; $i++) {
 $s = [Text.StringBuilder]::new()
 for ($j=0; $j -lt 120; $j++) { [void]$s.Append($tokens[$rng.Next($tokens.Count)]) }
 $fixtures += $s.ToString()
}
$dir = Join-Path $PSScriptRoot '.validation'
New-Item -ItemType Directory -Force $dir | Out-Null
$file = Join-Path $dir 'input.md'
$count = 0
foreach ($flags in @(0, (4+8+1024+256+512+2048+524288+1048576), 16776974, 16777087)) {
 foreach ($fixture in $fixtures) {
  [IO.File]::WriteAllText($file, $fixture, [Text.UTF8Encoding]::new($false))
  $expected = @(& $Reference $file $flags)
  if ($LASTEXITCODE -ne 0) { throw "C parser failed at fixture $count" }
  $actual = @(& $VParser $file $flags)
  if ($LASTEXITCODE -ne 0) { throw "V parser failed at fixture $count" }
  if (($actual -join "`n") -cne ($expected -join "`n")) {
   [IO.File]::WriteAllText((Join-Path $dir 'expected.txt'), ($expected -join "`n"))
   [IO.File]::WriteAllText((Join-Path $dir 'actual.txt'), ($actual -join "`n"))
   throw "Event mismatch at fixture $count, flags $flags; see tests/.validation"
  }
  $count++
 }
}
Write-Output "Matched $count event streams (CommonMark and all extension flags)."
