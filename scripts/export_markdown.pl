#!/usr/bin/perl
# Export every lesson .md to <chapter>/markdown_export/<stem>.pdf, plus one
# combined <chapter>_md.pdf per chapter (bookmarked, one lesson per new page).
#
# Each lesson becomes an HTML page that renders the Markdown with marked.js and
# the maths with KaTeX (both loaded from cdn.jsdelivr.net, so this needs an
# internet connection), and headless Google Chrome prints that page to A4 PDF.
# Needs only Perl and Chrome.
#
# Usage, from anywhere:
#   perl scripts/export_markdown.pl                       # every chapter
#   perl scripts/export_markdown.pl 09_confidence_intervals 05_introduction_to_probability
# Set CHROME to the chrome.exe path if Chrome is not in the default location.
use strict; use warnings;
use MIME::Base64 qw(encode_base64);
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);

my $ROOT = dirname(dirname(abs_path(__FILE__)));
my $WORK = (($ENV{TEMP} // File::Spec->tmpdir) =~ tr{\\}{/}r) . '/stats-markdown-export';
my @only = map { s{[\\/]+$}{}r } @ARGV;
my $CHROME = $ENV{CHROME} // 'C:/Program Files/Google/Chrome/Application/chrome.exe';
die "Chrome not found at $CHROME (set CHROME to its path)\n" unless -x $CHROME;
mkdir $WORK;

sub winpath { my $p = shift; $p =~ s{^/([a-zA-Z])/}{\U$1\E:/}; $p }
sub fileurl { my $p = winpath(shift); $p =~ s/ /%20/g; "file:///$p" }
sub slurp { my $f = shift; open my $fh, '<:raw', $f or die "$f: $!"; local $/; <$fh> }
sub lesson_key { my $s = shift; my ($a, $b) = $s =~ /^(\d+)-(\d+)-/; ($a // 999) * 1000 + ($b // 999) }

my $CSS = <<'CSS';
@page { size: A4; margin: 18mm 19mm 17mm;
  @bottom-center { content: counter(page) " / " counter(pages); font-family: Arial, sans-serif; font-size: 7pt; color: #6a737d; } }
html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
body { font-family: "Segoe UI", Arial, sans-serif; font-size: 10pt; line-height: 1.55; color: #24292f; margin: 0; }
h1, h2, h3, h4 { color: #1f3a5f; line-height: 1.25; break-after: avoid; }
h1 { font-size: 19pt; margin: 0 0 0.7em; }
h2 { font-size: 13.5pt; margin: 1.5em 0 0.55em; }
h3 { font-size: 11.5pt; margin: 1.3em 0 0.45em; }
p { margin: 0.55em 0; }
a { color: #1f6fb2; text-decoration: none; }
blockquote { margin: 1em 0; padding: 0.45em 1em; border-left: 4px solid #c8d1dc; background: #f7f9fb; color: #3b4a5a; }
blockquote p { margin: 0.3em 0; }
table { border-collapse: collapse; width: 100%; margin: 1em 0; font-size: 8.8pt; break-inside: avoid; }
th { background: #f1f4f8; font-weight: 600; }
th, td { border: 1px solid #d0d7de; padding: 4px 8px; }
hr { border: 0; border-top: 1px solid #d8dee4; margin: 1.6em 0; }
img { max-width: 100%; display: block; margin: 1em auto; break-inside: avoid; }
pre { background: #f6f8fa; border: 1px solid #e1e4e8; border-radius: 4px; padding: 0.6em 0.9em; white-space: pre-wrap; break-inside: avoid; }
code { font-family: Consolas, "Courier New", monospace; font-size: 8.8pt; }
:not(pre) > code { background: #f2f4f6; padding: 0 3px; border-radius: 3px; }
ul, ol { padding-left: 1.6em; }
li { margin: 0.2em 0; }
.katex { font-size: 1.08em; }
.katex-display { margin: 0.7em 0; break-inside: avoid; }
section.lesson + section.lesson { break-before: page; }
CSS

my $JS = <<'JS';
function decode(b64) { return new TextDecoder('utf-8').decode(Uint8Array.from(atob(b64), c => c.charCodeAt(0))); }
function render(md) {
  const math = [];
  md = md.replace(/\\\$/g, 'ESCDOLLARX');   // escaped \$ is a literal dollar sign, never maths
  // Protect code first (left untouched), then pull out $$...$$ and $...$ before Markdown parsing.
  const re = /(```[\s\S]*?```|`[^`\n]+`|\$\$[\s\S]+?\$\$|\$(?!\s)(?:\\.|[^$\\\n])+?\$)/g;
  const prepared = md.replace(re, m => {
    if (m.startsWith('`')) return m;
    const display = m.startsWith('$$');
    const tex = (display ? m.slice(2, -2) : m.slice(1, -1)).replace(/ESCDOLLARX/g, '\\$');
    math.push({ tex, display });
    return 'KATEXPH' + (math.length - 1) + 'X';
  });
  let html = marked.parse(prepared, { gfm: true, breaks: false });
  html = html.replace(/ESCDOLLARX/g, '$');
  return html.replace(/KATEXPH(\d+)X/g, (_, i) => {
    const m = math[+i];
    return katex.renderToString(m.tex, { displayMode: m.display, throwOnError: false, strict: false });
  });
}
const out = document.getElementById('out');
for (const d of DOCS) {
  const s = document.createElement('section');
  s.className = 'lesson';
  s.innerHTML = render(decode(d));
  out.appendChild(s);
}
document.fonts.ready.then(() => { document.body.dataset.done = '1'; });
JS

sub page {
  my ($title, $base, @mds) = @_;
  my $docs = join ",\n", map { '"' . encode_base64(slurp($_), '') . '"' } @mds;
  return <<"HTML";
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>$title</title>
<base href="$base">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex\@0.16.11/dist/katex.min.css">
<script src="https://cdn.jsdelivr.net/npm/katex\@0.16.11/dist/katex.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/marked\@12.0.2/marked.min.js"></script>
<style>$CSS</style></head>
<body><main id="out"></main>
<script>const DOCS = [
$docs
];
$JS</script></body></html>
HTML
}

sub print_pdf {
  my ($html, $pdf) = @_;
  unlink $pdf;
  my @cmd = ($CHROME, '--headless=new', '--disable-gpu', '--no-pdf-header-footer',
    '--generate-pdf-document-outline', '--virtual-time-budget=20000', '--run-all-compositor-stages-before-draw',
    '--user-data-dir=' . winpath("$WORK/chrome-profile"), '--print-to-pdf=' . winpath($pdf), fileurl($html));
  system(@cmd) == 0 or warn "chrome failed for $html\n";
  my $ok = -s $pdf;
  printf "  %-80s %s\n", $pdf =~ s{.*/([^/]+/[^/]+/[^/]+)$}{$1}r, $ok ? sprintf('%d KB', $ok / 1024) : 'MISSING';
  return $ok;
}

opendir my $dh, $ROOT or die $!;
my @chapters = sort grep { /^\d\d_/ && -d "$ROOT/$_" } readdir $dh;
@chapters = grep { my $c = $_; grep { $_ eq $c } @only } @chapters if @only;
my $fail = 0;
for my $ch (@chapters) {
  my $dir = "$ROOT/$ch";
  opendir my $cd, $dir or die $!;
  my @md = sort { lesson_key($a) <=> lesson_key($b) } grep { /^\d+-\d+-.*\.md$/ } readdir $cd;
  next unless @md;
  mkdir "$dir/markdown_export";
  print "$ch (" . scalar(@md) . " lessons)\n";
  my $base = fileurl("$dir/");
  for my $m (@md) {
    (my $stem = $m) =~ s/\.md$//;
    my $html = "$WORK/$stem.html";
    open my $fh, '>:raw', $html or die $!; print $fh page($stem, $base, "$dir/$m"); close $fh;
    print_pdf($html, "$dir/markdown_export/$stem.pdf") or $fail++;
  }
  my $html = "$WORK/${ch}_md.html";
  open my $fh, '>:raw', $html or die $!; print $fh page("$ch - Markdown lessons", $base, map { "$dir/$_" } @md); close $fh;
  print_pdf($html, "$dir/markdown_export/${ch}_md.pdf") or $fail++;
}
print $fail ? "$fail FAILED\n" : "all done\n";
