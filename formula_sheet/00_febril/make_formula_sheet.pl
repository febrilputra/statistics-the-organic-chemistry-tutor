#!/usr/bin/perl
# Builds the illustrated formula sheet for the whole repo (chapters 1-13):
#   formula_sheet.html  every formula, rendered with KaTeX, plus a hand-built SVG sketch per idea
#   formula_sheet.pdf   the same page printed to A4 by headless Google Chrome
# The sketches are computed here (normal, t, chi-square, binomial ... curves), in the same
# Okabe-Ito palette as the chapter figures. KaTeX is loaded from cdn.jsdelivr.net, so
# printing the PDF needs an internet connection.
# Usage, from anywhere:   perl formula_sheet/00_febril/make_formula_sheet.pl
# Set CHROME to the chrome.exe path if Chrome is not in the default location.
use strict; use warnings; use utf8;
use POSIX qw(erf lgamma);
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);

my $OUT    = dirname(abs_path(__FILE__));
my $CHROME = $ENV{CHROME} // 'C:/Program Files/Google/Chrome/Application/chrome.exe';
my $WORK   = (($ENV{TEMP} // File::Spec->tmpdir) =~ tr{\\}{/}r) . '/stats-formula-sheet';
my $PI     = 3.14159265358979;

my %C = (blue => '#0072B2', orange => '#D55E00', green => '#009E73', yellow => '#E69F00',
         sky => '#56B4E9', pink => '#CC79A7', ink => '#222222', muted => '#555555',
         mid => '#BFD3E6', mid2 => '#A9CCE6', lb => '#EAF2F8', lo => '#FBE3D6', lg => '#D5EFE6',
         tail => '#E8B4B4', tailtxt => '#C0392B', grid => '#E6E6E6', ly => '#FCE9C2');

# ---------------------------------------------------------------- SVG helpers
sub f1  { my $v = sprintf '%.1f', $_[0]; $v =~ s/\.0$//; $v eq '-0' ? '0' : $v }
sub esc { my $s = shift; $s =~ s/&/&amp;/g; $s =~ s/</&lt;/g; $s =~ s/>/&gt;/g; $s }
sub T {
  my ($x, $y, $s, %o) = @_;
  my $e = '';
  $e .= ' font-weight="bold"'  if $o{bold};
  $e .= ' font-style="italic"' if $o{italic};
  $e .= ' font-family="Consolas, monospace"' if $o{mono};
  $e .= ' stroke="#ffffff" stroke-width="3" stroke-linejoin="round" paint-order="stroke"' if $o{halo};
  qq{<text x="} . f1($x) . qq{" y="} . f1($y) . qq{" font-size="} . ($o{size} // 9) . qq{" fill="} . ($o{fill} // $C{ink})
    . qq{" text-anchor="} . ($o{anchor} // 'middle') . qq{"$e>} . esc($s) . '</text>';
}
sub L {
  my ($x1, $y1, $x2, $y2, %o) = @_;
  my $e = '';
  $e .= qq{ stroke-dasharray="$o{dash}"}     if $o{dash};
  $e .= qq{ marker-end="url(#$o{end})"}      if $o{end};
  $e .= qq{ marker-start="url(#$o{start})"}  if $o{start};
  qq{<line x1="} . f1($x1) . qq{" y1="} . f1($y1) . qq{" x2="} . f1($x2) . qq{" y2="} . f1($y2)
    . qq{" stroke="} . ($o{c} // $C{ink}) . qq{" stroke-width="} . ($o{w} // 1) . qq{"$e/>};
}
sub R {
  my ($x, $y, $w, $h, %o) = @_;
  my $e = '';
  $e .= qq{ stroke="$o{stroke}" stroke-width="} . ($o{sw} // 1) . '"' if $o{stroke};
  $e .= qq{ rx="$o{rx}"}               if $o{rx};
  $e .= qq{ stroke-dasharray="$o{dash}"} if $o{dash};
  $e .= qq{ opacity="$o{op}"}          if defined $o{op};
  qq{<rect x="} . f1($x) . qq{" y="} . f1($y) . qq{" width="} . f1($w) . qq{" height="} . f1($h)
    . qq{" fill="} . ($o{fill} // 'none') . qq{"$e/>};
}
sub Ci {
  my ($x, $y, $r, %o) = @_;
  my $e = '';
  $e .= qq{ stroke="$o{stroke}" stroke-width="} . ($o{sw} // 1) . '"' if $o{stroke};
  $e .= qq{ opacity="$o{op}"} if defined $o{op};
  $e .= qq{ clip-path="url(#$o{clip})"} if $o{clip};
  qq{<circle cx="} . f1($x) . qq{" cy="} . f1($y) . qq{" r="$r" fill="} . ($o{fill} // $C{ink}) . qq{"$e/>};
}
sub P {
  my ($d, %o) = @_;
  my $e = '';
  $e .= qq{ stroke="$o{c}" stroke-width="} . ($o{w} // 1.5) . '" stroke-linejoin="round"' if $o{c};
  $e .= qq{ stroke-dasharray="$o{dash}"} if $o{dash};
  $e .= qq{ opacity="$o{op}"}            if defined $o{op};
  $e .= qq{ marker-end="url(#$o{end})"}  if $o{end};
  qq{<path d="$d" fill="} . ($o{fill} // 'none') . qq{"$e/>};
}
sub svg { my ($w, $h, @b) = @_; qq{<svg class="ill" viewBox="0 0 $w $h" xmlns="http://www.w3.org/2000/svg">\n} . join("\n", @b) . "\n</svg>" }

# (xa..xb, ya..yb) in data units  ->  (l..r, b..t) in pixels
sub mapper {
  my ($xa, $xb, $ya, $yb, $l, $r, $t, $b) = @_;
  (sub { $l + ($_[0] - $xa) / ($xb - $xa) * ($r - $l) }, sub { $b - ($_[0] - $ya) / ($yb - $ya) * ($b - $t) });
}
sub fpath {
  my ($f, $a, $b, $X, $Y, $n) = @_; $n //= 100;
  my @p = map { my $x = $a + ($b - $a) * $_ / $n; f1($X->($x)) . ',' . f1($Y->($f->($x))) } 0 .. $n;
  'M' . join(' L', @p);
}
sub curve { my ($f, $a, $b, $X, $Y, %o) = @_; P(fpath($f, $a, $b, $X, $Y, $o{n}), c => $o{c} // $C{blue}, w => $o{w} // 1.6, dash => $o{dash}) }
sub area {
  my ($f, $a, $b, $X, $Y, %o) = @_;
  my $d = fpath($f, $a, $b, $X, $Y, 60) . ' L' . f1($X->($b)) . ',' . f1($Y->(0)) . ' L' . f1($X->($a)) . ',' . f1($Y->(0)) . ' Z';
  P($d, fill => $o{fill} // $C{mid}, op => $o{op});
}
sub tick { my ($x, $y, $lab, %o) = @_; L($x, $y, $x, $y + 3, c => $C{muted}) . T($x, $y + 12, $lab, size => $o{size} // 8, fill => $o{fill} // $C{muted}) }
sub bracket {   # horizontal bracket with end ticks and a centred label on a white halo
  my ($x1, $x2, $y, $lab, %o) = @_;
  my $c = $o{c} // $C{ink};
  L($x1, $y, $x2, $y, c => $c) . L($x1, $y, $x1, $y + 4, c => $c) . L($x2, $y, $x2, $y + 4, c => $c)
    . T(($x1 + $x2) / 2, $o{below} ? $y + 13 : $y - 3, $lab, size => $o{size} // 8, fill => $c, bold => $o{bold});
}

# ---------------------------------------------------------------- maths helpers
sub npdf   { my ($x, $m, $s) = @_; $m //= 0; $s //= 1; exp(-0.5 * (($x - $m) / $s)**2) / ($s * sqrt(2 * $PI)) }
sub ncdf   { 0.5 * (1 + erf($_[0] / sqrt 2)) }
sub tpdf   { my ($x, $v) = @_; exp(lgamma(($v + 1) / 2) - lgamma($v / 2)) / sqrt($v * $PI) * (1 + $x * $x / $v)**(-($v + 1) / 2) }
sub chipdf { my ($x, $k) = @_; return 0 if $x <= 0; exp(($k / 2 - 1) * log($x) - $x / 2 - ($k / 2) * log(2) - lgamma($k / 2)) }
sub gampdf { my ($x, $k, $th) = @_; return 0 if $x <= 0; exp(($k - 1) * log($x) - $x / $th - lgamma($k) - $k * log($th)) }
sub choose { my ($n, $k) = @_; my $c = 1; $c = $c * ($n - $_ + 1) / $_ for 1 .. $k; $c }
sub fact   { my $f = 1; $f *= $_ for 2 .. $_[0]; $f }
my $SEED = 1;
sub seed  { $SEED = shift }
sub rnd   { $SEED = ($SEED * 1103515245 + 12345) % 2147483648; $SEED / 2147483648 }
sub rnorm { my $u1 = rnd() || 1e-9; my $u2 = rnd(); sqrt(-2 * log($u1)) * cos(2 * $PI * $u2) }

# ================================================================ the sketches
# Chapter 1
sub ill_pop_sample {
  seed(7); my @b;
  push @b, qq{<ellipse cx="90" cy="50" rx="82" ry="44" fill="$C{lb}" stroke="$C{blue}" stroke-width="1.5"/>};
  my $n = 0;
  while ($n < 70) { my ($x, $y) = (8 + 164 * rnd(), 6 + 88 * rnd());
    next unless (($x - 90) / 76)**2 + (($y - 50) / 38)**2 < 1; next if ($x - 112)**2 + ($y - 58)**2 < 26**2;
    push @b, Ci($x, $y, 1.7, fill => $C{blue}, op => 0.5); $n++ }
  push @b, Ci(112, 58, 22, fill => $C{lo}, stroke => $C{orange}, sw => 1.5);
  $n = 0;
  while ($n < 9) { my ($x, $y) = (92 + 40 * rnd(), 38 + 40 * rnd());
    next unless ($x - 112)**2 + ($y - 58)**2 < 16**2; push @b, Ci($x, $y, 1.9, fill => $C{orange}); $n++ }
  push @b, T(82, 22, 'POPULATION · N · μ, σ, p', size => 8, fill => $C{blue}, bold => 1, halo => 1);
  push @b, T(112, 104, 'sample · n · x̄, s, p̂', size => 8, fill => $C{orange}, bold => 1);
  push @b, T(186, 18, 'Descriptive', size => 9, bold => 1, anchor => 'start');
  push @b, T(186, 30, 'summarize the data you have:', size => 7.6, fill => $C{muted}, anchor => 'start');
  push @b, T(186, 41, 'tables, graphs, x̄, median, s', size => 7.6, fill => $C{muted}, anchor => 'start');
  push @b, T(186, 62, 'Inferential', size => 9, bold => 1, anchor => 'start');
  push @b, T(186, 74, 'generalize sample → population', size => 7.6, fill => $C{muted}, anchor => 'start');
  push @b, T(186, 85, 'with a stated confidence', size => 7.6, fill => $C{muted}, anchor => 'start');
  svg(300, 108, @b);
}
sub ill_noir {
  my @b; my @fill = ('#D6E6F2', '#A9CCE6', '#6FA8D2', $C{blue});
  my @name = qw(Nominal Ordinal Interval Ratio);
  my @prop = ('labels only', '+ order', '+ equal gaps', '+ true zero');
  my @ex   = ('eye color', 'rankings', '°C, years', 'kg, cm, money');
  for my $i (0 .. 3) {
    my ($x, $h) = (8 + $i * 73, 26 + $i * 17);
    push @b, R($x, 92 - $h, 66, $h, fill => $fill[$i], rx => 2);
    push @b, T($x + 33, 88 - $h, $name[$i], size => 9, bold => 1);
    push @b, T($x + 33, 92 - $h + 13, $prop[$i], size => 7.8, fill => $i == 3 ? '#ffffff' : $C{ink});
    push @b, T($x + 33, 104, $ex[$i], size => 7.6, fill => $C{muted}, italic => 1);
  }
  push @b, L(8, 92, 292, 92, c => $C{muted});
  push @b, L(70, 114, 230, 114, c => $C{muted}, end => 'ahm');
  push @b, T(150, 111, 'N → O → I → R: more information', size => 7.6, fill => $C{muted}, halo => 1);
  svg(300, 118, @b);
}

# Chapter 2
sub ill_freq {
  my @b; my @f = (2, 5, 8, 4, 1); my $n = 20;
  my ($X, $Y) = mapper(0.4, 5.6, 0, 1.08, 26, 196, 10, 86);
  push @b, L($X->(0.4), $Y->(1), $X->(5.6), $Y->(1), c => $C{grid}, dash => '3 2');
  push @b, L($X->(0.4), $Y->(0), $X->(5.6), $Y->(0), c => $C{muted});
  for my $v (0, 0.5, 1) { push @b, L(23, $Y->($v), 26, $Y->($v), c => $C{muted}), T(20, $Y->($v) + 3, $v, size => 7.5, fill => $C{muted}, anchor => 'end') }
  my ($cum, @pts) = (0);
  for my $i (0 .. 4) {
    my $rf = $f[$i] / $n; $cum += $rf;
    push @b, R($X->($i + 1 - 0.3), $Y->($rf), $X->(1.6) - $X->(1), $Y->(0) - $Y->($rf), fill => $C{mid}, stroke => $C{blue});
    push @b, T($X->($i + 1), $Y->($rf) - 3, sprintf('%.2f', $rf), size => 7, fill => $C{blue});
    push @b, tick($X->($i + 1), $Y->(0), $i + 1);
    push @pts, f1($X->($i + 1)) . ',' . f1($Y->($cum));
  }
  push @b, P('M' . join(' L', @pts), c => $C{orange}, w => 1.6);
  push @b, Ci(split(/,/, $_), 2.6, fill => $C{orange}) for @pts;
  push @b, T($X->(0.55), 18, 'RF = f / n (bars)', size => 8, fill => $C{blue}, anchor => 'start', bold => 1);
  push @b, T($X->(4.9), $Y->(1) - 4, 'CRF → 1', size => 8, fill => $C{orange}, anchor => 'end', bold => 1);
  push @b, T(110, 108, 'value V', size => 7.5, fill => $C{muted});
  my @rows = (['V', 'f', 'RF', 'CRF'], [1, 2, '.10', '.10'], [2, 5, '.25', '.35'], [3, 8, '.40', '.75'], [4, 4, '.20', '.95'], [5, 1, '.05', '1.00'], ['Σ', 20, '1.00', '']);
  my @cx = (214, 236, 260, 287);
  for my $r (0 .. $#rows) {
    my $y = 18 + $r * 13;
    push @b, L(206, $y + 3.5, 296, $y + 3.5, c => $C{grid}) if $r == 0 || $r == 5;
    for my $c (0 .. 3) { push @b, T($cx[$c], $y, $rows[$r][$c], size => 7.8, bold => ($r == 0 || $r == 6), fill => $c == 2 ? $C{blue} : $c == 3 ? $C{orange} : $C{ink}) }
  }
  svg(300, 112, @b);
}
sub ill_dot_stem {
  my @b; my %cnt = (2 => 1, 3 => 2, 4 => 4, 5 => 3, 6 => 1, 7 => 1);
  my ($X) = mapper(1.5, 7.5, 0, 1, 10, 150, 0, 1);
  push @b, L(10, 78, 150, 78, c => $C{muted});
  for my $v (2 .. 7) {
    push @b, tick($X->($v), 78, $v);
    push @b, Ci($X->($v), 78 - 7 - 11 * $_, 4.3, fill => $v == 4 ? $C{orange} : $C{blue}) for 0 .. $cnt{$v} - 1;
  }
  push @b, T($X->(4), 26, 'mode (tallest)', size => 7.8, fill => $C{orange}, bold => 1);
  push @b, T(80, 102, 'dot plot: one dot per value', size => 7.6, fill => $C{muted});
  my @lines = ('4 │ 2 7', '5 │ 1 3 8', '6 │ 0 4 4 9', '7 │ 5');
  push @b, T(176, 12, 'stem │ leaf', size => 7.6, fill => $C{muted}, anchor => 'start');
  push @b, T(180, 28 + 14 * $_, $lines[$_], size => 10, mono => 1, anchor => 'start') for 0 .. 3;
  push @b, R(172, 86, 112, 15, fill => $C{ly}, rx => 3);
  push @b, T(178, 97, 'key: 5 │ 3 = 53', size => 8.5, mono => 1, anchor => 'start', bold => 1);
  svg(300, 106, @b);
}
sub ill_hist_poly {
  my @b; my @f = (2, 4, 7, 9, 5, 3);
  my ($X, $Y) = mapper(29.5, 109.5, 0, 10.5, 12, 292, 12, 88);
  for my $i (0 .. 5) {
    my $lo = 39.5 + 10 * $i;
    push @b, R($X->($lo), $Y->($f[$i]), $X->($lo + 10) - $X->($lo), $Y->(0) - $Y->($f[$i]), fill => $C{mid}, stroke => $C{blue});
    push @b, T($X->($lo + 5), 99, (40 + 10 * $i) . '–' . (49 + 10 * $i), size => 7.2, fill => $C{muted});
  }
  push @b, L($X->(29.5), $Y->(0), $X->(109.5), $Y->(0), c => $C{muted});
  my @mx = (34.5, map({ 44.5 + 10 * $_ } 0 .. 5), 104.5); my @mf = (0, @f, 0);
  push @b, P('M' . join(' L', map { f1($X->($mx[$_])) . ',' . f1($Y->($mf[$_])) } 0 .. $#mx), c => $C{orange}, w => 1.8);
  push @b, Ci($X->($mx[$_]), $Y->($mf[$_]), 2.6, fill => $C{orange}) for 0 .. $#mx;
  push @b, T($X->(34.5), $Y->(0) - 7, 'f = 0', size => 7.5, fill => $C{orange});
  push @b, T($X->(104.5), $Y->(0) - 7, 'f = 0', size => 7.5, fill => $C{orange});
  push @b, T(16, 18, 'bars touch · polygon joins class midpoints', size => 7.8, fill => $C{muted}, anchor => 'start');
  push @b, T(16, 30, 'midpoint of 40–49 = (40 + 49)/2 = 44.5', size => 7.8, fill => $C{orange}, anchor => 'start');
  svg(300, 104, @b);
}

# Chapter 3
sub ill_center {
  my @b; my @d = (1, 2, 2, 4, 6, 9, 18);
  my ($X) = mapper(0, 20, 0, 1, 12, 290, 0, 1);
  push @b, L(12, 58, 290, 58, c => $C{muted});
  push @b, L($X->($_), 58, $X->($_), 61, c => $C{muted}), T($X->($_), 70, $_, size => 7.5, fill => $C{muted}) for (0, 5, 10, 15, 20);
  my %seen; for my $v (@d) { push @b, Ci($X->($v), 51 - 9 * ($seen{$v}++ // 0), 3.8, fill => $C{ink}) }
  push @b, bracket($X->(1), $X->(18), 26, 'range = H − L = 18 − 1 = 17', size => 7.8);
  push @b, P('M' . f1($X->(9.5) - 4) . ',36 L' . f1($X->(9.5) + 4) . ',36 L' . f1($X->(9.5)) . ',42 Z', fill => $C{pink});
  my @m = ([2, 'mode 2', $C{blue}, 84], [4, 'median 4', $C{green}, 96], [6, 'x̄ = 6', $C{orange}, 84], [9.5, 'midrange 9.5', $C{pink}, 96]);
  for (@m) {
    my ($v, $lab, $c, $y) = @$_;
    push @b, P('M' . f1($X->($v)) . ',73 L' . f1($X->($v) - 4) . ',79 L' . f1($X->($v) + 4) . ',79 Z', fill => $c) if $v != 9.5;
    push @b, L($X->($v), 79, $X->($v), $y - 8, c => $c, dash => '2 2') if $y == 96 && $v != 9.5;
    push @b, T($X->($v), $y, $lab, size => 8, fill => $c, bold => 1);
  }
  push @b, L($X->(9.5), 42, $X->(9.5), 87, c => $C{pink}, dash => '2 2');
  push @b, T(290, 86, 'n = 7 (odd): median = value', size => 7.6, fill => $C{muted}, anchor => 'end');
  push @b, T(290, 97, 'at position (n + 1)/2 = 4', size => 7.6, fill => $C{muted}, anchor => 'end');
  push @b, T($X->(18) - 8, 47, '18 pulls the mean up', size => 7.2, fill => $C{muted}, anchor => 'end', italic => 1) ;
  svg(300, 102, @b);
}
sub ill_means {
  my @b;
  my ($X) = mapper(9, 21, 0, 1, 12, 288, 0, 1);
  push @b, L(12, 42, 288, 42, c => $C{muted});
  push @b, tick($X->(10), 42, 'a = 10'), tick($X->(20), 42, 'b = 20');
  my @m = ([40 / 3, 'H 13.3', $C{pink}, 12], [sqrt 200, 'G 14.1', $C{green}, 24], [15, 'A 15', $C{blue}, 12], [sqrt 250, 'R 15.8', $C{orange}, 24]);
  for (@m) { my ($v, $lab, $c, $y) = @$_; push @b, L($X->($v), $y + 3, $X->($v), 42, c => $c, w => 1.3), Ci($X->($v), 42, 3, fill => $c), T($X->($v), $y, $lab, size => 8, fill => $c, bold => 1) }
  push @b, T(100, 64, 'HM ≤ GM ≤ AM ≤ RMS', size => 8.5, bold => 1), T(215, 64, 'GM² = AM · HM', size => 8.5, bold => 1);
  my ($W) = mapper(60, 100, 0, 1, 40, 260, 0, 1); my $yb = 108;
  push @b, L($W->(62), $yb, $W->(98), $yb, w => 2.5);
  push @b, Ci($W->(70), $yb - 6.5, 6, fill => $C{mid2}, stroke => $C{blue}), Ci($W->(90), $yb - 11, 10.4, fill => $C{mid2}, stroke => $C{blue});
  push @b, T($W->(70), $yb - 16, 'x = 70, w = 1', size => 7.5, fill => $C{blue}), T($W->(90), $yb - 25, 'x = 90, w = 3', size => 7.5, fill => $C{blue});
  push @b, P('M' . f1($W->(85)) . ',' . ($yb + 1.5) . ' L' . f1($W->(85) - 7) . ',' . ($yb + 14) . ' L' . f1($W->(85) + 7) . ',' . ($yb + 14) . ' Z', fill => $C{orange});
  push @b, L($W->(80), $yb + 1, $W->(80), $yb + 10, c => $C{muted}, dash => '2 2'), T($W->(80) - 3, $yb + 12, 'plain mean 80', size => 7, fill => $C{muted}, anchor => 'end');
  push @b, T(150, $yb + 26, 'balance point x̄w = (1·70 + 3·90)/(1 + 3) = 85', size => 8, fill => $C{orange}, bold => 1);
  svg(300, $yb + 30, @b);
}
sub ill_sd {
  my @b; my @d = (2, 4, 4, 5, 7, 8); my ($m, $s) = (5, sqrt 4.8);
  my ($X) = mapper(0, 10, 0, 1, 14, 180, 0, 1);
  push @b, R($X->($m - $s), 13, $X->($m + $s) - $X->($m - $s), 79, fill => $C{lb});
  push @b, T($X->($m - $s) + 2, 20, 'x̄ − s', size => 7, fill => $C{blue}, anchor => 'start'), T($X->($m + $s) - 2, 20, 'x̄ + s', size => 7, fill => $C{blue}, anchor => 'end');
  push @b, L($X->($m), 9, $X->($m), 92, c => $C{ink}, dash => '3 2'), T($X->($m), 8, 'x̄ = 5', size => 7.8, bold => 1);
  for my $i (0 .. $#d) {
    my ($v, $y) = ($d[$i], 28 + 12 * $i); my $dv = $v - $m;
    my $c = $dv < 0 ? $C{blue} : $C{orange};
    push @b, L($X->($m), $y, $X->($v) + ($dv < 0 ? 3 : -3), $y, c => $c, w => 1.4, end => $dv < 0 ? 'ahb' : 'aho') if $dv;
    push @b, Ci($X->($v), $y, 2.8, fill => $C{ink});
    push @b, T($X->($v) + ($dv < 0 ? -6 : 6), $y + 3, ($dv > 0 ? '+' : $dv < 0 ? '−' : '') . abs($dv), size => 7.5, fill => $dv ? $c : $C{muted}, anchor => $dv < 0 ? 'end' : 'start');
  }
  push @b, L(14, 96, 180, 96, c => $C{muted});
  push @b, tick($X->($_), 96, $_) for (0, 2, 4, 6, 8, 10);
  my @t = (['data 2, 4, 4, 5, 7, 8', $C{muted}], ['Σ(x − x̄) = 0  (always)', $C{ink}], ['squares 9+1+1+0+4+9', $C{muted}], ['Σ(x − x̄)² = 24', $C{ink}],
           ['s² = 24/(6 − 1) = 4.8', $C{blue}], ['s = √4.8 ≈ 2.19', $C{blue}], ['MAD = 10/6 ≈ 1.67', $C{green}]);
  push @b, T(190, 14 + 14 * $_, $t[$_][0], size => 7.9, fill => $t[$_][1], anchor => 'start', bold => ($_ == 4 || $_ == 5)) for 0 .. $#t;
  svg(300, 112, @b);
}
sub ill_cv {
  my @b;
  my ($X) = mapper(55, 100, 0, 1, 42, 222, 0, 1);
  my @rows = (['Test A', [79, 84, 86, 81, 89], 83.8, 3.962, 'CV = 4.7%', '3.96 / 83.8', 26, $C{lb}, $C{blue}],
              ['Test B', [63, 72, 92, 84, 78], 77.8, 11.10, 'CV = 14.3%', '11.10 / 77.8', 62, $C{lo}, $C{orange}]);
  for (@rows) {
    my ($name, $d, $mn, $s, $cv, $calc, $y, $fill, $c) = @$_;
    push @b, R($X->($mn - $s), $y - 9, $X->($mn + $s) - $X->($mn - $s), 18, fill => $fill, stroke => $c, sw => 0.8);
    push @b, L($X->($mn), $y - 11, $X->($mn), $y + 11, c => $c, w => 1.5);
    push @b, Ci($X->($_), $y, 3.3, fill => $C{ink}) for @$d;
    push @b, T(4, $y + 3, $name, size => 8.5, bold => 1, anchor => 'start');
    push @b, T(232, $y - 1, $cv, size => 9, bold => 1, fill => $c, anchor => 'start');
    push @b, T(232, $y + 10, $calc, size => 7.5, fill => $C{muted}, anchor => 'start');
  }
  push @b, L(42, 84, 222, 84, c => $C{muted});
  push @b, tick($X->($_), 84, $_) for (60, 70, 80, 90, 100);
  push @b, T(132, 8, 'shaded band = x̄ ± s', size => 7.5, fill => $C{muted});
  svg(300, 100, @b);
}
sub ill_grouped {
  my @b; my @f = (3, 7, 12, 8, 4);
  my ($X, $Y) = mapper(44.5, 104.5, 0, 13.5, 14, 178, 10, 94);
  for my $i (0 .. 4) {
    my $lo = 49.5 + 10 * $i;
    push @b, R($X->($lo), $Y->($f[$i]), $X->($lo + 10) - $X->($lo), $Y->(0) - $Y->($f[$i]), fill => $i == 2 ? $C{mid2} : $C{mid}, stroke => $C{blue});
    my $lab = $i == 1 ? 'f₁=7' : $i == 2 ? 'fm=12' : $i == 3 ? 'f₂=8' : $f[$i];
    push @b, T($X->($lo + 5), $Y->($f[$i]) - 3, $lab, size => 7.2, fill => $i >= 1 && $i <= 3 ? $C{ink} : $C{muted}, bold => $i == 2);
  }
  push @b, L($X->(44.5), $Y->(0), $X->(104.5), $Y->(0), c => $C{muted});
  push @b, L($X->(69.5), $Y->(7), $X->(79.5), $Y->(12), c => $C{orange}, w => 1.3);
  push @b, L($X->(69.5), $Y->(12), $X->(79.5), $Y->(8), c => $C{orange}, w => 1.3);
  my $mode = 69.5 + 10 * 5 / 9;
  push @b, L($X->($mode), $Y->(7 + 5 * 5 / 9), $X->($mode), $Y->(0) + 14, c => $C{orange}, dash => '2 2');
  push @b, T($X->(69.5), 103, 'L = 69.5', size => 7.2, fill => $C{muted}, anchor => 'end'), T($X->(79.5), 103, '79.5', size => 7.2, fill => $C{muted}, anchor => 'start');
  push @b, T($X->($mode), 116, 'mode ≈ 75.1', size => 8, fill => $C{orange}, bold => 1);
  push @b, T($X->(84.5), 116, 'h = 10', size => 7.2, fill => $C{muted}, anchor => 'start');
  my @t = (['classes 50–59 … 90–99', $C{muted}], ['n = Σf = 34', $C{ink}], ['cum. f: 3, 10, 22, …', $C{muted}], ['n/2 = 17 → median class', $C{muted}],
           ['70–79, C = 10, f = 12', $C{muted}], ['median = 69.5 + (17−10)/12·10', $C{green}], ['         ≈ 75.3', $C{green}], ['x̄ ≈ Σfm / Σf ≈ 75.4', $C{blue}]);
  push @b, T(184, 12 + 13.5 * $_, $t[$_][0], size => 7.4, fill => $t[$_][1], anchor => 'start', bold => ($_ == 6 || $_ == 7)) for 0 .. $#t;
  svg(300, 120, @b);
}

# Chapter 4
sub ill_quartiles {
  my @b; my @d = (2, 4, 5, 7, 8, 10, 12, 13, 15, 18, 20);
  my %q = (3 => ['Q₁ = 5', $C{sky}], 6 => ['Q₂ = 10 (median)', $C{green}], 9 => ['Q₃ = 15', $C{sky}]);
  push @b, T(14, 12, 'sorted data, n = 11', size => 7.8, fill => $C{muted}, anchor => 'start');
  for my $i (0 .. 10) {
    my $x = 14 + 24 * $i; my $p = $i + 1;
    push @b, R($x, 32, 24, 20, fill => $q{$p} ? ($p == 6 ? $C{lg} : $C{lb}) : '#ffffff', stroke => '#9AA7B4');
    push @b, T($x + 12, 46, $d[$i], size => 9, bold => !!$q{$p});
    push @b, T($x + 12, 28, $p, size => 6.8, fill => $C{muted});
    if ($q{$p}) { push @b, L($x + 12, 53, $x + 12, 60, c => $q{$p}[1] eq $C{sky} ? $C{blue} : $C{green}, end => $p == 6 ? 'ahg' : 'ahb'); push @b, T($x + 12, 70, $q{$p}[0], size => 8, bold => 1, fill => $p == 6 ? $C{green} : $C{blue}) }
  }
  push @b, T(150, 88, 'position of Qk = k(n + 1)/4 → 3, 6, 9     each quarter holds 25%', size => 7.8, fill => $C{ink});
  svg(300, 94, @b);
}
sub ill_boxplot {
  my @b; my ($X) = mapper(-4, 38, 0, 1, 12, 290, 0, 1);
  my ($q1, $q2, $q3, $lo, $hi, $out) = (10, 14, 18, 4, 27, 34);
  push @b, L($X->(-2), 16, $X->(-2), 68, c => $C{tailtxt}, dash => '3 2'), L($X->(30), 16, $X->(30), 68, c => $C{tailtxt}, dash => '3 2');
  push @b, T($X->(-2) - 2, 10, 'Q₁ − 1.5·IQR = −2', size => 7.4, fill => $C{tailtxt}, anchor => 'start');
  push @b, T($X->(30), 10, 'Q₃ + 1.5·IQR = 30', size => 7.4, fill => $C{tailtxt});
  push @b, L($X->($lo), 42, $X->($q1), 42, w => 1.3), L($X->($q3), 42, $X->($hi), 42, w => 1.3);
  push @b, L($X->($lo), 36, $X->($lo), 48, w => 1.3), L($X->($hi), 36, $X->($hi), 48, w => 1.3);
  push @b, R($X->($q1), 31, $X->($q3) - $X->($q1), 22, fill => $C{mid}, stroke => $C{blue}, sw => 1.3);
  push @b, L($X->($q2), 31, $X->($q2), 53, c => $C{blue}, w => 2);
  push @b, Ci($X->($out), 42, 3.5, fill => $C{orange});
  push @b, T($X->($out), 58, 'outlier', size => 7.6, fill => $C{orange}, bold => 1);
  push @b, T($X->($q1), 27, 'Q₁', size => 8, bold => 1), T($X->($q2), 27, 'Q₂', size => 8, bold => 1), T($X->($q3), 27, 'Q₃', size => 8, bold => 1);
  push @b, bracket($X->($q1), $X->($q3), 58, 'IQR = 8', size => 7.6, c => $C{blue}, below => 1);
  push @b, T($X->($hi), 58, 'whisker', size => 7, fill => $C{muted});
  push @b, L(12, 76, 290, 76, c => $C{muted});
  push @b, tick($X->($_), 76, $_) for (0, 5, 10, 15, 20, 25, 30, 35);
  svg(300, 94, @b);
}
sub ill_skew {
  my @b;
  my @panels = (
    ['skewed left',  'mean < median < mode', sub { gampdf(10 - $_[0], 3, 1) }, [7, 7.326, 8], [3.0, 6.08, 7.326, 8.273, 9.7]],
    ['symmetric',    'mean = median = mode', sub { npdf($_[0], 5, 1.6) },        [5, 5, 5],       [1.3, 3.92, 5, 6.08, 8.7]],
    ['skewed right', 'mean > median > mode', sub { gampdf($_[0], 3, 1) },       [3, 2.674, 2],   [0.3, 1.727, 2.674, 3.92, 7.0]],
  );
  for my $i (0 .. 2) {
    my ($title, $rel, $f, $mmm, $bx) = @{ $panels[$i] };
    my $ox = 4 + $i * 99;
    my ($X, $Y) = mapper(0, 10, 0, 0.3, $ox + 3, $ox + 93, 16, 68);
    push @b, area($f, 0.01, 9.99, $X, $Y, fill => $C{lb});
    push @b, curve($f, 0.01, 9.99, $X, $Y, c => $C{blue}, w => 1.4);
    push @b, L($X->(0), $Y->(0), $X->(10), $Y->(0), c => $C{muted});
    my ($mean, $med, $mode) = @$mmm;
    push @b, L($X->($mode), $Y->(0), $X->($mode), $Y->($f->($mode)), c => $C{blue}, w => 1.5);
    push @b, L($X->($med), $Y->(0), $X->($med), $Y->($f->($med)), c => $C{green}, w => 1.5);
    push @b, L($X->($mean), $Y->(0), $X->($mean), $Y->($f->($mean)), c => $C{orange}, w => 1.5, dash => $i == 1 ? '3 2' : undef);
    my ($w1, $a, $m, $c, $w2) = @$bx;
    push @b, L($X->($w1), 81, $X->($w2), 81, c => $C{ink}), R($X->($a), 75, $X->($c) - $X->($a), 12, fill => '#ffffff', stroke => $C{ink}), L($X->($m), 75, $X->($m), 87, c => $C{green}, w => 1.5);
    push @b, T($ox + 48, 9, $title, size => 8.5, bold => 1);
    push @b, T($ox + 48, 100, $rel, size => 7, fill => $C{muted});
  }
  svg(300, 104, @b);
}

# Chapter 5
sub ill_complement {
  my @b;
  push @b, R(10, 8, 168, 80, fill => $C{lo}, stroke => $C{ink});
  push @b, Ci(82, 48, 29, fill => $C{mid}, stroke => $C{blue}, sw => 1.5);
  push @b, T(82, 52, 'A', size => 12, bold => 1, fill => $C{blue});
  push @b, T(148, 30, 'A′', size => 12, bold => 1, fill => $C{orange});
  push @b, T(150, 44, '(not A)', size => 7.5, fill => $C{orange});
  push @b, T(18, 20, 'S', size => 10, bold => 1, anchor => 'start');
  push @b, T(190, 26, 'P(A) + P(A′) = 1', size => 8.5, bold => 1, anchor => 'start');
  push @b, T(190, 40, 'P(A′) = 1 − P(A)', size => 8.5, fill => $C{orange}, bold => 1, anchor => 'start');
  push @b, T(190, 62, '“at least one”', size => 7.8, fill => $C{muted}, anchor => 'start');
  push @b, T(190, 74, '= 1 − P(none)', size => 8.5, bold => 1, anchor => 'start');
  svg(300, 94, @b);
}
sub ill_addition {
  my @b;
  push @b, R(6, 8, 140, 70, stroke => $C{ink}), R(154, 8, 140, 70, stroke => $C{ink});
  push @b, Ci(58, 43, 28, fill => $C{blue}, op => 0.28), Ci(94, 43, 28, fill => $C{orange}, op => 0.28);
  push @b, Ci(58, 43, 28, fill => 'none', stroke => $C{blue}, sw => 1.3), Ci(94, 43, 28, fill => 'none', stroke => $C{orange}, sw => 1.3);
  push @b, T(44, 46, 'A', size => 11, bold => 1, fill => $C{blue}), T(108, 46, 'B', size => 11, bold => 1, fill => $C{orange});
  push @b, T(76, 46, 'A∩B', size => 7, bold => 1);
  push @b, T(76, 90, 'overlap counted twice → subtract once', size => 7.3, fill => $C{muted});
  push @b, Ci(196, 43, 25, fill => $C{blue}, op => 0.28, stroke => $C{blue}, sw => 1.3), Ci(254, 43, 25, fill => $C{orange}, op => 0.28, stroke => $C{orange}, sw => 1.3);
  push @b, T(196, 47, 'A', size => 11, bold => 1, fill => $C{blue}), T(254, 47, 'B', size => 11, bold => 1, fill => $C{orange});
  push @b, T(224, 90, 'mutually exclusive: P(A∩B) = 0', size => 7.3, fill => $C{muted});
  svg(300, 96, @b);
}
sub ill_conditional {
  my @b;
  push @b, qq{<defs><clipPath id="cpB"><circle cx="92" cy="46" r="30"/></clipPath></defs>};
  push @b, R(6, 6, 136, 76, stroke => $C{ink});
  push @b, Ci(92, 46, 30, fill => $C{lo}, stroke => $C{orange}, sw => 2.4);
  push @b, Ci(54, 46, 30, fill => 'none', stroke => $C{muted}, sw => 1), Ci(54, 46, 30, fill => $C{blue}, op => 0.45, clip => 'cpB');
  push @b, T(40, 50, 'A', size => 11, bold => 1, fill => $C{muted}), T(108, 50, 'B', size => 11, bold => 1, fill => $C{orange});
  push @b, T(74, 94, 'given B: B becomes the whole space', size => 7.3, fill => $C{muted});
  my @cx = (170, 207, 241, 277); my @ry = (18, 36, 52, 68);
  push @b, R(152, 27, 144, 16, fill => $C{lo});
  push @b, R(190, 27, 34, 16, stroke => $C{orange}, sw => 1.5);
  my @rows = (['', 'A', 'A′', 'total'], ['B', 15, 15, 30], ['B′', 25, 45, 70], ['total', 40, 60, 100]);
  for my $r (0 .. 3) { for my $c (0 .. 3) { push @b, T($cx[$c], $ry[$r], $rows[$r][$c], size => 8, bold => ($r == 0 || $c == 0)) } }
  push @b, L(152, 22, 296, 22, c => $C{grid}), L(152, 58, 296, 58, c => $C{grid}), L(188, 8, 188, 74, c => $C{grid}), L(258, 8, 258, 74, c => $C{grid});
  push @b, T(224, 86, 'P(A | B) = 15/30 = 0.50', size => 8, fill => $C{orange}, bold => 1);
  push @b, T(224, 97, 'but P(A) = 40/100 = 0.40', size => 7.6, fill => $C{muted});
  svg(300, 100, @b);
}
sub ill_tree {
  my @b; my ($rx, $ry) = (10, 58);
  my @l1 = ([78, 30, 'A', '0.01'], [78, 86, 'A′', '0.99']);
  my @l2 = ([150, 12, '+', '0.95', 0, '.01×.95 = .0095', 1], [150, 44, '−', '0.05', 0, '.01×.05 = .0005', 0],
            [150, 72, '+', '0.10', 1, '.99×.10 = .099', 1],  [150, 102, '−', '0.90', 1, '.99×.90 = .891', 0]);
  for (@l1) { my ($x, $y, $lab, $p) = @$_; push @b, L($rx + 4, $ry, $x - 8, $y, c => $C{muted}); push @b, T(($rx + $x) / 2 - 2, ($ry + $y) / 2 + ($y < $ry ? -3 : 9), $p, size => 7.4, fill => $C{blue}) }
  for (@l2) {
    my ($x, $y, $lab, $p, $par, $leaf, $pos) = @$_; my ($px, $py) = @{ $l1[$par] }[0, 1];
    push @b, L($px + 8, $py, $x - 6, $y, c => $C{muted});
    push @b, T(($px + $x) / 2 + 2, ($py + $y) / 2 + ($y < $py ? -3 : 9), $p, size => 7.2, fill => $C{blue});
    push @b, T($x, $y + 3.5, $lab, size => 10, bold => 1, fill => $pos ? $C{orange} : $C{ink});
    push @b, T($x + 9, $y + 3, $leaf, size => 7.4, anchor => 'start', fill => $pos ? $C{orange} : $C{muted}, bold => $pos);
  }
  push @b, Ci($rx, $ry, 3, fill => $C{ink});
  push @b, T($_->[0], $_->[1] + 3.5, $_->[2], size => 10, bold => 1) for @l1;
  my @t = (['Bayes', 1, $C{ink}], ['P(A | +) =', 0, $C{ink}], ['P(+|A)P(A) / P(+)', 0, $C{muted}], ['= .0095 / (.0095 + .099)', 0, $C{orange}], ['≈ 0.088', 1, $C{orange}],
           ['× along a branch,', 0, $C{muted}], ['+ across branches', 0, $C{muted}]);
  push @b, T(222, 14 + 13.5 * $_, $t[$_][0], size => $_ == 0 ? 8.5 : 7.4, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 112, @b);
}
sub ill_expected {
  my @b; my $z = 58; my $k = 1.9;
  my @o = ([20, 0.25, '20 × .25 = 5', 0], [5, 0.25, '5 × .25 = 1.25', 8], [-10, 0.5, '−10 × .5 = −5', 0]);
  my $x = 14;
  for (@o) {
    my ($v, $p, $lab, $dx) = @$_; my $w = 176 * $p;
    push @b, R($x, $v > 0 ? $z - $v * $k : $z, $w, abs($v) * $k, fill => $v > 0 ? $C{mid} : $C{lo}, stroke => $v > 0 ? $C{blue} : $C{orange});
    push @b, T($x + $w / 2 + $dx, $v > 0 ? $z - $v * $k - 4 : $z - $v * $k + 10, $lab, size => 7.2, fill => $v > 0 ? $C{blue} : $C{orange}, bold => 1);
    push @b, T($x + $w / 2, $v > 0 ? $z + 10 : $z - 4, "p = $p", size => 7, fill => $C{muted});
    $x += $w;
  }
  push @b, L(10, $z, 194, $z, c => $C{ink});
  push @b, T(104, 106, 'width = probability, height = value', size => 7.4, fill => $C{muted}, italic => 1);
  my @t = (['E(X) = Σ x · P(x)', 1, $C{ink}], ['= 5 + 1.25 − 5', 0, $C{muted}], ['= 1.25 per game', 1, $C{green}], ['(long-run average)', 0, $C{muted}], ['n games → n · E(X)', 0, $C{ink}]);
  push @b, T(204, 20 + 15 * $_, $t[$_][0], size => 8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 110, @b);
}

# Chapter 6
sub barchart {   # generic pmf bar chart; returns (@b, X, Y)
  my ($pm, $x0, $x1, $ymax, $col, %o) = @_;
  my ($X, $Y) = mapper($x0 - 0.6, $x1 + 0.6, 0, $ymax, 14, $o{r} // 196, 12, 84);
  my @b;
  for my $x ($x0 .. $x1) {
    my $p = $pm->($x); my $c = $col->($x);
    push @b, R($X->($x - 0.36), $Y->($p), $X->(0.72) - $X->(0), $Y->(0) - $Y->($p), fill => $c->[0], stroke => $c->[1], sw => 0.8);
    push @b, tick($X->($x), $Y->(0), $x, size => 7.2) if !$o{every} || $x % $o{every} == 0;
  }
  push @b, L($X->($x0 - 0.6), $Y->(0), $X->($x1 + 0.6), $Y->(0), c => $C{muted});
  (\@b, $X, $Y);
}
sub ill_binom {
  my ($n, $p) = (10, 0.3);
  my ($b, $X, $Y) = barchart(sub { choose($n, $_[0]) * $p**$_[0] * (1 - $p)**($n - $_[0]) }, 0, 10, 0.3,
                             sub { $_[0] == 3 ? [$C{lo}, $C{orange}] : [$C{mid}, $C{blue}] });
  my @b = @$b;
  push @b, T($X->(3), $Y->(0.2668) - 4, '0.267', size => 7.4, fill => $C{orange}, bold => 1);
  push @b, T($X->(6.2), 22, 'peak near μ = np = 3', size => 7.6, anchor => 'start');
  my @t = (['n = 10, p = 0.3', 0, $C{muted}], ['P(X = 3)', 1, $C{orange}], ['= ₁₀C₃ (0.3)³ (0.7)⁷', 0, $C{orange}], ['≈ 0.267', 1, $C{orange}], ['σ = √(npq) = √2.1', 0, $C{ink}], ['≈ 1.45', 0, $C{ink}]);
  push @b, T(204, 18 + 14 * $_, $t[$_][0], size => 7.8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 98, @b);
}
sub ill_geom {
  my $p = 0.3;
  my ($b, $X, $Y) = barchart(sub { (1 - $p)**($_[0] - 1) * $p }, 1, 10, 0.32, sub { $_[0] > 4 ? [$C{lo}, $C{orange}] : [$C{mid}, $C{blue}] });
  my @b = @$b;
  push @b, L($X->(1 / $p), 12, $X->(1 / $p), $Y->(0), c => $C{ink}, dash => '2 2'), T($X->(1 / $p) + 3, 18, 'μ = 1/p ≈ 3.33', size => 7.6, anchor => 'start');
  push @b, T($X->(7.5), $Y->(0.06) - 6, 'P(X > 4) = q⁴ ≈ 0.24', size => 7.6, fill => $C{orange}, bold => 1);
  my @t = (['p = 0.3, q = 0.7', 0, $C{muted}], ['1st success on trial x:', 0, $C{ink}], ['P(X = x) = qˣ⁻¹ p', 1, $C{blue}], ['P(X ≤ x) = 1 − qˣ', 0, $C{ink}], ['P(X > x) = qˣ', 0, $C{orange}], ['σ² = q / p²', 0, $C{ink}]);
  push @b, T(204, 18 + 14 * $_, $t[$_][0], size => 7.8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 98, @b);
}
sub ill_poisson {
  my $mu = 4;
  my ($b, $X, $Y) = barchart(sub { $mu**$_[0] * exp(-$mu) / fact($_[0]) }, 0, 12, 0.22, sub { $_[0] <= 2 ? [$C{lg}, $C{green}] : [$C{mid}, $C{blue}] });
  my @b = @$b;
  push @b, L($X->($mu), 12, $X->($mu), $Y->(0), c => $C{ink}, dash => '2 2'), T($X->($mu) + 3, 18, 'μ = 4', size => 7.6, anchor => 'start');
  push @b, T($X->(0.7), $Y->(0.205) - 4, 'P(X ≤ 2)', size => 7.4, fill => $C{green}, bold => 1);
  push @b, T($X->(0.7), $Y->(0.205) + 6, '≈ 0.238', size => 7.4, fill => $C{green}, bold => 1);
  my @t = (['μ = 4 events / interval', 0, $C{muted}], ['P(X = x) = μˣ e^(−μ) / x!', 1, $C{blue}], ['P(X ≤ 2) = e⁻⁴(1 + 4 + 8)', 0, $C{green}], ['mean = variance = μ', 0, $C{ink}],
           ['new interval: rescale μ', 0, $C{ink}], ['μ₂ / μ₁ = t₂ / t₁', 0, $C{ink}]);
  push @b, T(200, 18 + 14 * $_, $t[$_][0], size => 7.6, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 98, @b);
}
sub ill_disc_cont {
  my @b;
  my ($X, $Y) = mapper(-0.5, 6.5, 0, 0.35, 10, 140, 12, 62);
  for my $x (0 .. 6) { my $p = choose(6, $x) * 0.5**6; push @b, L($X->($x), $Y->(0), $X->($x), $Y->($p), c => $C{blue}, w => 1.4), Ci($X->($x), $Y->($p), 3, fill => $C{blue}) }
  push @b, L(10, $Y->(0), 140, $Y->(0), c => $C{muted});
  push @b, T(75, 76, 'counted → discrete', size => 8.2, bold => 1), T(75, 87, 'separate values, gaps between', size => 7.2, fill => $C{muted});
  my ($X2, $Y2) = mapper(-3.2, 3.2, 0, 0.42, 160, 290, 12, 62);
  push @b, area(sub { npdf($_[0]) }, -3.2, 3.2, $X2, $Y2, fill => $C{lo}), curve(sub { npdf($_[0]) }, -3.2, 3.2, $X2, $Y2, c => $C{orange});
  push @b, L(160, $Y2->(0), 290, $Y2->(0), c => $C{muted});
  push @b, T(225, 76, 'measured → continuous', size => 8.2, bold => 1), T(225, 87, 'any value in a range', size => 7.2, fill => $C{muted});
  svg(300, 92, @b);
}

# Chapter 7
sub ill_pdf_cdf {
  my @b; my ($a, $b) = (-0.5, 1.2);
  my ($X, $Y) = mapper(-3.2, 3.2, 0, 0.42, 8, 140, 10, 76);
  push @b, area(sub { npdf($_[0]) }, $a, $b, $X, $Y, fill => $C{lo});
  push @b, curve(sub { npdf($_[0]) }, -3.2, 3.2, $X, $Y), L(8, 76, 140, 76, c => $C{muted});
  push @b, tick($X->($a), 76, 'a'), tick($X->($b), 76, 'b');
  push @b, T($X->(0.35), 64, 'area', size => 7.6, fill => $C{orange}, bold => 1);
  push @b, T(74, 102, 'PDF: P(a < X < b) = area', size => 7.6, bold => 1);
  my ($X2, $Y2) = mapper(-3.2, 3.2, 0, 1.05, 172, 292, 10, 76);
  my ($Fa, $Fb) = (ncdf($a), ncdf($b));
  push @b, L(172, $Y2->(1), 292, $Y2->(1), c => $C{grid}, dash => '3 2');
  push @b, L(172, $Y2->($Fa), $X2->($a), $Y2->($Fa), c => $C{muted}, dash => '2 2'), L($X2->($a), $Y2->($Fa), $X2->($a), 76, c => $C{muted}, dash => '2 2');
  push @b, L(172, $Y2->($Fb), $X2->($b), $Y2->($Fb), c => $C{muted}, dash => '2 2'), L($X2->($b), $Y2->($Fb), $X2->($b), 76, c => $C{muted}, dash => '2 2');
  push @b, L(176, $Y2->($Fa), 176, $Y2->($Fb), c => $C{orange}, w => 3);
  push @b, curve(sub { ncdf($_[0]) }, -3.2, 3.2, $X2, $Y2), L(172, 76, 292, 76, c => $C{muted}), L(172, 10, 172, 76, c => $C{muted});
  push @b, T(168, $Y2->($Fa) + 3, 'F(a)', size => 7, anchor => 'end', fill => $C{muted}), T(168, $Y2->($Fb) + 3, 'F(b)', size => 7, anchor => 'end', fill => $C{muted});
  push @b, T(168, $Y2->(1) + 3, '1', size => 7, anchor => 'end', fill => $C{muted});
  push @b, tick($X2->($a), 76, 'a'), tick($X2->($b), 76, 'b');
  push @b, T(232, 102, 'CDF: F(b) − F(a), same area', size => 7.6, bold => 1);
  svg(300, 106, @b);
}
sub ill_uniform {
  my @b; my ($a, $b) = (2, 10);
  my ($X, $Y) = mapper(0, 12, 0, 0.17, 14, 196, 14, 80);
  push @b, R($X->($a), $Y->(1 / 8), $X->($b) - $X->($a), $Y->(0) - $Y->(1 / 8), fill => $C{lb}, stroke => $C{blue}, sw => 1.4);
  push @b, R($X->(4), $Y->(1 / 8), $X->(7) - $X->(4), $Y->(0) - $Y->(1 / 8), fill => $C{lo}, stroke => $C{orange}, sw => 1.2);
  push @b, L(14, 80, 196, 80, c => $C{muted});
  push @b, tick($X->($_), 80, $_) for (0, 2, 4, 6, 7, 10, 12);
  push @b, T($X->($a), 106, 'a', size => 7.6, fill => $C{blue}, bold => 1), T($X->($b), 106, 'b', size => 7.6, fill => $C{blue}, bold => 1);
  push @b, T($X->(5.5), 60, '3 × 1/8', size => 7.6, fill => $C{orange}, bold => 1);
  push @b, T($X->(6), $Y->(1 / 8) - 4, 'height = 1/(b − a) = 1/8', size => 7.6, fill => $C{blue});
  my @t = (['U(2, 10)', 1, $C{ink}], ['P(4 < X < 7)', 0, $C{orange}], ['= width / (b − a)', 0, $C{orange}], ['= 3/8 = 0.375', 1, $C{orange}], ['μ = (a + b)/2 = 6', 0, $C{ink}], ['σ = (b − a)/√12 ≈ 2.31', 0, $C{ink}]);
  push @b, T(204, 18 + 14 * $_, $t[$_][0], size => 7.8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 110, @b);
}
sub ill_expon {
  my @b; my $l = 0.2; my $f = sub { $l * exp(-$l * $_[0]) };
  my ($X, $Y) = mapper(0, 22, 0, 0.22, 16, 196, 10, 80);
  push @b, area($f, 8, 22, $X, $Y, fill => $C{lo}), area($f, 0, 8, $X, $Y, fill => $C{lb});
  push @b, curve($f, 0, 22, $X, $Y), L(16, 80, 196, 80, c => $C{muted}), L(16, 10, 16, 80, c => $C{muted});
  push @b, tick($X->($_), 80, $_) for (0, 5, 8, 10, 15, 20);
  push @b, Ci($X->(0), $Y->($l), 2.6, fill => $C{blue}), T($X->(0) + 5, $Y->($l) + 3, 'y-intercept = λ = 1/μ = 0.2', size => 7.4, fill => $C{blue}, anchor => 'start');
  push @b, T($X->(12), $Y->(0.03), 'P(X > 8)', size => 7.6, fill => $C{orange}, bold => 1);
  push @b, T($X->(3.4), $Y->(0.03), '1 − e^(−λx)', size => 7.2, fill => $C{blue});
  my @t = (['μ = 5 (e.g. years)', 0, $C{muted}], ['P(X > 8) = e^(−λx)', 0, $C{orange}], ['= e^(−1.6) ≈ 0.202', 1, $C{orange}], ['P(X < 8) ≈ 0.798', 0, $C{blue}], ['σ = μ = 1/λ', 0, $C{ink}]);
  push @b, T(204, 20 + 15 * $_, $t[$_][0], size => 7.8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 98, @b);
}

# Chapter 8
sub ill_zscore {
  my @b;
  my ($X, $Y) = mapper(-3.4, 3.4, 0, 0.42, 16, 286, 10, 70);
  push @b, area(sub { npdf($_[0]) }, -3.4, 1.5, $X, $Y, fill => $C{mid});
  push @b, curve(sub { npdf($_[0]) }, -3.4, 3.4, $X, $Y), L(16, 70, 286, 70, c => $C{muted});
  push @b, L($X->(1.5), 34, $X->(1.5), 70, c => $C{orange}, w => 1.5);
  push @b, T($X->(-0.4), 60, 'left area = 0.9332 (z-table)', size => 7.6, fill => $C{blue}, bold => 1, halo => 1);
  push @b, T(16, 16, 'μ = 74, σ = 8, x = 86', size => 7.6, fill => $C{muted}, anchor => 'start');
  push @b, T(16, 28, 'z = (86 − 74)/8 = 1.5', size => 7.8, fill => $C{orange}, bold => 1, anchor => 'start');
  push @b, T(286, 16, 'right area', size => 7.4, fill => $C{muted}, anchor => 'end');
  push @b, T(286, 28, '= 1 − 0.9332 = 0.0668', size => 7.4, fill => $C{muted}, anchor => 'end');
  for my $k (-3 .. 3) { push @b, tick($X->($k), 70, 74 + 8 * $k, size => 7.4); push @b, T($X->($k), 96, $k, size => 7.4, fill => $C{blue}) }
  push @b, T(4, 82, 'x', size => 7.6, italic => 1, anchor => 'start'), T(4, 96, 'z', size => 7.6, italic => 1, fill => $C{blue}, anchor => 'start');
  svg(300, 100, @b);
}
sub ill_empirical {
  my @b;
  my ($X, $Y) = mapper(-3.6, 3.6, 0, 0.42, 8, 292, 44, 98);
  my @fill = ('#F0F0F0', $C{lb}, $C{mid}, $C{mid2}, $C{mid2}, $C{mid}, $C{lb}, '#F0F0F0');
  my @cut = (-3.6, -3, -2, -1, 0, 1, 2, 3, 3.6);
  push @b, area(sub { npdf($_[0]) }, $cut[$_], $cut[$_ + 1], $X, $Y, fill => $fill[$_]) for 0 .. 7;
  push @b, L($X->($_), $Y->(0), $X->($_), $Y->(npdf($_)), c => '#ffffff', w => 1) for (-2, -1, 0, 1, 2);
  push @b, curve(sub { npdf($_[0]) }, -3.6, 3.6, $X, $Y), L(8, 98, 292, 98, c => $C{muted});
  push @b, bracket($X->(-3), $X->(3), 10, '99.7%', bold => 1);
  push @b, bracket($X->(-2), $X->(2), 22, '95%', bold => 1);
  push @b, bracket($X->(-1), $X->(1), 34, '68%', bold => 1);
  my @pct = ('0.15', '2.35', '13.5', '34', '34', '13.5', '2.35', '0.15'); my @ctr = (-3.3, -2.5, -1.5, -0.5, 0.5, 1.5, 2.5, 3.3);
  push @b, T($X->($ctr[$_]), 110, $pct[$_] . '%', size => 7.4, fill => $_ == 3 || $_ == 4 ? $C{blue} : $C{ink}, bold => ($_ == 3 || $_ == 4)) for 0 .. 7;
  my @lab = ('μ−3σ', 'μ−2σ', 'μ−σ', 'μ', 'μ+σ', 'μ+2σ', 'μ+3σ');
  push @b, L($X->($_ - 3), 98, $X->($_ - 3), 101, c => $C{muted}), T($X->($_ - 3), 122, $lab[$_], size => 7.2, fill => $C{muted}) for 0 .. 6;
  svg(300, 126, @b);
}
sub ill_clt {
  my @b; my $pop = sub { gampdf($_[0], 2, 2) }; my $se = 2 * sqrt(2) / sqrt(30);
  my ($X, $Y) = mapper(0, 14, 0, 0.82, 14, 196, 8, 84);
  push @b, area($pop, 0.01, 14, $X, $Y, fill => $C{lo}, op => 0.8), curve($pop, 0.01, 14, $X, $Y, c => $C{orange}, w => 1.4);
  push @b, area(sub { npdf($_[0], 4, $se) }, 2, 6, $X, $Y, fill => $C{mid}, op => 0.85), curve(sub { npdf($_[0], 4, $se) }, 2, 6, $X, $Y, c => $C{blue}, w => 1.6, n => 160);
  push @b, L($X->(4), 8, $X->(4), 84, c => $C{ink}, dash => '2 2'), L(14, 84, 196, 84, c => $C{muted});
  push @b, tick($X->(4), 84, 'μ');
  push @b, T($X->(4.9), $Y->(0.66), 'sample means x̄', size => 7.6, fill => $C{blue}, bold => 1, anchor => 'start');
  push @b, T($X->(4.9), $Y->(0.66) + 10, '(n = 30): SD = σ/√n', size => 7.4, fill => $C{blue}, anchor => 'start');
  push @b, T($X->(7.2), $Y->(0.1), 'population (skewed), SD = σ', size => 7.4, fill => $C{orange}, anchor => 'start', halo => 1);
  my @t = (['μx̄ = μ', 1, $C{ink}], ['σx̄ = σ / √n', 1, $C{blue}], ['x̄ ≈ normal for n ≥ 30,', 0, $C{muted}], ['whatever the shape', 0, $C{muted}], ['sum ~ N(nμ, √n σ)', 0, $C{ink}]);
  push @b, T(204, 20 + 15 * $_, $t[$_][0], size => 7.8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 98, @b);
}
sub ill_lln {
  seed(2024); my @b; my ($h, @pts) = (0);
  my ($X, $Y) = mapper(0, log(500) / log(10), 0, 1, 26, 290, 8, 54);
  for my $n (1 .. 500) { $h++ if rnd() < 0.5; push @pts, f1($X->(log($n) / log(10))) . ',' . f1($Y->($h / $n)) }
  push @b, L(26, $Y->(0.5), 290, $Y->(0.5), c => $C{orange}, dash => '4 2');
  push @b, P('M' . join(' L', @pts), c => $C{blue}, w => 1.2);
  push @b, L(26, 54, 290, 54, c => $C{muted}), L(26, 8, 26, 54, c => $C{muted});
  push @b, T(22, $Y->($_) + 3, $_, size => 7, fill => $C{muted}, anchor => 'end') for (0, 0.5, 1);
  push @b, tick($X->(log($_) / log(10)), 54, $_, size => 7) for (1, 10, 100, 500);
  push @b, T(286, 47, 'law of large numbers: running share of heads → 0.5', size => 7.4, fill => $C{blue}, anchor => 'end', halo => 1);
  push @b, T(158, 76, 'number of flips (log scale)', size => 7, fill => $C{muted});
  svg(300, 80, @b);
}

# Chapter 9
sub ill_ci_z {
  my @b;
  my ($X, $Y) = mapper(-3.4, 3.4, 0, 0.42, 14, 286, 8, 66);
  push @b, area(sub { npdf($_[0]) }, -1.96, 1.96, $X, $Y, fill => $C{mid});
  push @b, area(sub { npdf($_[0]) }, -3.4, -1.96, $X, $Y, fill => $C{tail}), area(sub { npdf($_[0]) }, 1.96, 3.4, $X, $Y, fill => $C{tail});
  push @b, curve(sub { npdf($_[0]) }, -3.4, 3.4, $X, $Y), L(14, 66, 286, 66, c => $C{muted});
  push @b, T(150, 48, 'CL = 95%', size => 8.5, bold => 1, fill => $C{blue});
  push @b, T($X->(-2.6), 50, 'α/2 = .025', size => 7.4, fill => $C{tailtxt}), T($X->(2.6), 50, 'α/2 = .025', size => 7.4, fill => $C{tailtxt});
  push @b, tick($X->(-1.96), 66, '−z = −1.96'), tick($X->(1.96), 66, 'z = 1.96'), tick($X->(0), 66, '0');
  push @b, L($X->(-1.96), 96, $X->(1.96), 96, c => $C{blue}, w => 2.2), L($X->(-1.96), 91, $X->(-1.96), 101, c => $C{blue}, w => 2), L($X->(1.96), 91, $X->(1.96), 101, c => $C{blue}, w => 2);
  push @b, Ci(150, 96, 3.2, fill => $C{orange}), T(150, 91, 'x̄', size => 8.5, bold => 1, fill => $C{orange});
  push @b, T($X->(-1.96) - 5, 99, 'x̄ − EBM', size => 7.8, anchor => 'end', bold => 1), T($X->(1.96) + 5, 99, 'x̄ + EBM', size => 7.8, anchor => 'start', bold => 1);
  svg(300, 106, @b);
}
sub ill_t {
  my @b;
  my ($X, $Y) = mapper(-4.2, 4.2, 0, 0.42, 10, 196, 10, 80);
  push @b, area(sub { tpdf($_[0], 3) }, 3.182, 4.2, $X, $Y, fill => $C{lo}), area(sub { tpdf($_[0], 3) }, -4.2, -3.182, $X, $Y, fill => $C{lo});
  push @b, curve(sub { npdf($_[0]) }, -4.2, 4.2, $X, $Y, c => $C{blue}), curve(sub { tpdf($_[0], 3) }, -4.2, 4.2, $X, $Y, c => $C{orange});
  push @b, L(10, 80, 196, 80, c => $C{muted});
  push @b, tick($X->(-1.96), 80, '−1.96', fill => $C{blue}), tick($X->(1.96), 80, '1.96', fill => $C{blue}), tick($X->(3.182), 80, '3.18', fill => $C{orange}), tick($X->(-3.182), 80, '−3.18', fill => $C{orange});
  push @b, T($X->(0.45), 16, 'z (normal)', size => 7.6, fill => $C{blue}, bold => 1, anchor => 'start');
  push @b, T($X->(2.1), $Y->(0.16), 't, ν = 3', size => 7.6, fill => $C{orange}, bold => 1, anchor => 'start');
  push @b, T($X->(2.1), $Y->(0.16) + 10, 'fatter tails', size => 7.2, fill => $C{orange}, anchor => 'start');
  my @t = (['ν = n − 1', 1, $C{ink}], ['one-tail area', 0, $C{muted}], ['α/2 = (1 − CL)/2', 0, $C{ink}], ['95%, n = 4 (ν = 3):', 0, $C{muted}], ['t = 3.182 > z = 1.96', 1, $C{orange}], ['→ wider interval', 0, $C{muted}]);
  push @b, T(206, 18 + 14 * $_, $t[$_][0], size => 7.8, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 98, @b);
}
sub ill_prop_ci {
  my @b; my ($ph, $E) = (0.55, 0.06);
  my ($X, $Y) = mapper(0.40, 0.70, 0, 14, 14, 286, 6, 48);
  push @b, area(sub { npdf($_[0], $ph, 0.0306) }, $ph - $E, $ph + $E, $X, $Y, fill => $C{lb});
  push @b, curve(sub { npdf($_[0], $ph, 0.0306) }, 0.43, 0.67, $X, $Y, c => $C{blue}, w => 1.3);
  push @b, L($X->($ph), 6, $X->($ph), 64, c => $C{orange}, dash => '2 2');
  push @b, L($X->($ph - $E), 64, $X->($ph + $E), 64, c => $C{orange}, w => 2.4);
  push @b, L($X->($ph - $E), 58, $X->($ph - $E), 70, c => $C{orange}, w => 2), L($X->($ph + $E), 58, $X->($ph + $E), 70, c => $C{orange}, w => 2);
  push @b, Ci($X->($ph), 64, 3.3, fill => $C{orange});
  push @b, T($X->($ph - $E / 2), 60, 'E', size => 8.5, bold => 1, fill => $C{orange}), T($X->($ph + $E / 2), 60, 'E', size => 8.5, bold => 1, fill => $C{orange});
  push @b, T($X->($ph) + 6, 14, 'p̂ = x/n = 0.55', size => 7.8, bold => 1, fill => $C{orange}, anchor => 'start');
  push @b, T($X->($ph - $E) - 5, 67, 'p̂ − E = 0.49', size => 7.6, anchor => 'end'), T($X->($ph + $E) + 5, 67, 'p̂ + E = 0.61', size => 7.6, anchor => 'start');
  push @b, L(14, 80, 286, 80, c => $C{muted});
  push @b, tick($X->($_ / 100), 80, sprintf('%.2f', $_ / 100), size => 7) for (40, 45, 50, 55, 60, 65, 70);
  svg(300, 96, @b);
}
sub ill_samplesize {
  my @b; my $f = sub { $_[0] * (1 - $_[0]) };
  my ($X, $Y) = mapper(0, 1, 0, 0.28, 26, 176, 10, 80);
  push @b, area($f, 0, 1, $X, $Y, fill => $C{lb}), L(26, $Y->(0.25), 176, $Y->(0.25), c => $C{orange}, dash => '4 2');
  push @b, curve($f, 0, 1, $X, $Y), L(26, 80, 176, 80, c => $C{muted}), L(26, 10, 26, 80, c => $C{muted});
  push @b, Ci($X->(0.5), $Y->(0.25), 3.2, fill => $C{orange});
  push @b, T(22, $Y->(0.25) + 3, '0.25', size => 7, fill => $C{orange}, anchor => 'end'), T(22, 83, '0', size => 7, fill => $C{muted}, anchor => 'end');
  push @b, tick($X->($_), 80, $_) for (0, 0.5, 1);
  push @b, T($X->(0.5), $Y->(0.25) - 5, 'max at p̂ = 0.5 → safest n', size => 7.4, fill => $C{orange}, bold => 1);
  push @b, T($X->(0.5), $Y->(0.09), 'p̂(1 − p̂)', size => 7.6, fill => $C{blue});
  my @t = (['95%, E = 0.05, p̂ = 0.5:', 0, $C{muted}], ['n = 1.96² (0.25) / 0.05²', 0, $C{ink}], ['= 384.2 → 385', 1, $C{orange}], ['(always round UP)', 0, $C{muted}], ['halve E → 4 × n', 1, $C{ink}]);
  push @b, T(186, 20 + 15 * $_, $t[$_][0], size => 7.6, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 96, @b);
}
sub ill_cheb {
  my @b; my @k = (1.5, 2, 3);
  my ($X, $Y) = mapper(0, 3, 0, 100, 26, 196, 12, 80);
  push @b, L(26, $Y->($_), 196, $Y->($_), c => $C{grid}), T(22, $Y->($_) + 3, "$_%", size => 7, fill => $C{muted}, anchor => 'end') for (0, 50, 100);
  for my $i (0 .. 2) {
    my $c = 100 * (1 - 1 / $k[$i]**2); my $n = 100 * (2 * ncdf($k[$i]) - 1); my $x = $X->($i + 0.5);
    push @b, R($x - 20, $Y->($c), 19, $Y->(0) - $Y->($c), fill => $C{lo}, stroke => $C{orange}), T($x - 10.5, $Y->($c) - 3, sprintf('%.1f', $c), size => 7, fill => $C{orange}, bold => 1);
    push @b, R($x + 1, $Y->($n), 19, $Y->(0) - $Y->($n), fill => $C{mid}, stroke => $C{blue}), T($x + 10.5, $Y->($n) - 3, sprintf('%.1f', $n), size => 7, fill => $C{blue});
    push @b, T($x, 92, "k = $k[$i]", size => 7.8);
  }
  push @b, R(204, 16, 9, 9, fill => $C{lo}, stroke => $C{orange}), T(217, 24, 'Chebyshev:', size => 7.8, bold => 1, fill => $C{orange}, anchor => 'start');
  push @b, T(204, 36, 'at least 1 − 1/k²', size => 7.6, anchor => 'start'), T(204, 47, 'for ANY shape', size => 7.6, anchor => 'start');
  push @b, R(204, 58, 9, 9, fill => $C{mid}, stroke => $C{blue}), T(217, 66, 'normal (exact)', size => 7.8, bold => 1, fill => $C{blue}, anchor => 'start');
  push @b, T(204, 78, 'empirical rule', size => 7.6, anchor => 'start');
  svg(300, 98, @b);
}

# Chapter 10
sub ill_tails {
  my @b;
  my @p = (['Hₐ: ≠  two-tailed', 'α/2 in each tail', 'z = ±1.96', [[-3.4, -1.96], [1.96, 3.4]]],
           ['Hₐ: <  left-tailed', 'all of α on the left', 'z = −1.645', [[-3.4, -1.645]]],
           ['Hₐ: >  right-tailed', 'all of α on the right', 'z = +1.645', [[1.645, 3.4]]]);
  for my $i (0 .. 2) {
    my ($t1, $t2, $t3, $tails) = @{ $p[$i] }; my $ox = 4 + 99 * $i;
    my ($X, $Y) = mapper(-3.4, 3.4, 0, 0.42, $ox + 3, $ox + 93, 6, 52);
    push @b, area(sub { npdf($_[0]) }, -3.4, 3.4, $X, $Y, fill => $C{lb});
    push @b, area(sub { npdf($_[0]) }, @$_, $X, $Y, fill => $C{tail}) for @$tails;
    push @b, curve(sub { npdf($_[0]) }, -3.4, 3.4, $X, $Y, w => 1.3), L($ox + 3, 52, $ox + 93, 52, c => $C{muted});
    push @b, T($ox + 48, 66, $t1, size => 8, bold => 1), T($ox + 48, 77, $t2, size => 7.2, fill => $C{tailtxt}), T($ox + 48, 88, "$t3 (α = .05)", size => 7.2, fill => $C{muted});
  }
  svg(300, 92, @b);
}
sub ill_errors {
  my @b; my ($c, $d) = (1.645, 2.8);
  my ($X, $Y) = mapper(-3.5, 6.2, 0, 0.42, 8, 292, 18, 78);
  push @b, area(sub { npdf($_[0], $d) }, $d - 3.6, $c, $X, $Y, fill => $C{ly});
  push @b, area(sub { npdf($_[0]) }, $c, 3.6, $X, $Y, fill => $C{tail});
  push @b, curve(sub { npdf($_[0]) }, -3.5, 3.6, $X, $Y, c => $C{blue}), curve(sub { npdf($_[0], $d) }, $d - 3.6, 6.2, $X, $Y, c => $C{orange});
  push @b, L(8, 78, 292, 78, c => $C{muted}), L($X->($c), 12, $X->($c), 86, c => $C{ink}, w => 1.3);
  push @b, T($X->(0), 12, 'H₀ true', size => 8, bold => 1, fill => $C{blue}), T($X->($d), 12, 'Hₐ true', size => 8, bold => 1, fill => $C{orange});
  push @b, T($X->(2.15), $Y->(0.03) + 1, 'α', size => 10, bold => 1, fill => $C{tailtxt});
  push @b, T($X->(1.15), $Y->(0.05) + 1, 'β', size => 10, bold => 1, fill => '#9A6B00');
  push @b, L($X->(3.4), $Y->(0.15), $X->(4.25), $Y->(0.27), c => $C{orange}, w => 0.8);
  push @b, T($X->(4.3), $Y->(0.28), 'power = 1 − β', size => 7.6, bold => 1, fill => $C{orange}, anchor => 'start');
  push @b, T($X->($c) - 4, 96, '← fail to reject H₀', size => 7.6, anchor => 'end', fill => $C{muted}), T($X->($c) + 4, 96, 'reject H₀ →', size => 7.6, anchor => 'start', fill => $C{muted});
  svg(300, 100, @b);
}
sub ill_decision {
  my @b;
  my ($X, $Y) = mapper(-3.6, 3.6, 0, 0.42, 8, 292, 8, 70);
  push @b, area(sub { npdf($_[0]) }, -1.96, 1.96, $X, $Y, fill => $C{lb});
  push @b, area(sub { npdf($_[0]) }, -3.6, -1.96, $X, $Y, fill => $C{tail}), area(sub { npdf($_[0]) }, 1.96, 3.6, $X, $Y, fill => $C{tail});
  push @b, curve(sub { npdf($_[0]) }, -3.6, 3.6, $X, $Y), L(8, 70, 292, 70, c => $C{muted});
  push @b, T(150, 56, 'fail to reject H₀', size => 8, bold => 1, fill => $C{blue});
  push @b, T($X->(-2.75), 50, 'reject', size => 7.8, bold => 1, fill => $C{tailtxt}), T($X->(3.05), 50, 'reject', size => 7.8, bold => 1, fill => $C{tailtxt});
  push @b, tick($X->(-1.96), 70, '−1.96'), tick($X->(1.96), 70, '1.96');
  push @b, L($X->(2.4), 22, $X->(2.4), 70, c => $C{orange}, w => 1.8), Ci($X->(2.4), 70, 3, fill => $C{orange});
  push @b, T(292, 16, 'test statistic z = 2.40 → reject H₀', size => 7.8, bold => 1, fill => $C{orange}, anchor => 'end');
  push @b, T(150, 96, 'two-tailed, α = 0.05: compare the test statistic with ±1.96', size => 7.4, fill => $C{muted});
  svg(300, 100, @b);
}
sub ill_pvalue {
  my @b;
  my ($X, $Y) = mapper(-3.6, 3.6, 0, 0.42, 8, 292, 8, 72);
  push @b, area(sub { npdf($_[0]) }, 1.8, 3.6, $X, $Y, fill => $C{orange}, op => 0.45);
  push @b, curve(sub { npdf($_[0]) }, -3.6, 3.6, $X, $Y), L(8, 72, 292, 72, c => $C{muted});
  push @b, L($X->(1.645), 30, $X->(1.645), 72, c => $C{tailtxt}, dash => '3 2'), L($X->(1.8), 50, $X->(1.8), 72, c => $C{orange}, w => 1.8);
  push @b, T($X->(1.645) - 2, 84, 'critical 1.645 (α = .05)', size => 7.2, fill => $C{tailtxt}, anchor => 'end');
  push @b, T($X->(1.8) + 2, 84, 'z = 1.80', size => 7.2, fill => $C{orange}, anchor => 'start', bold => 1);
  push @b, T(292, 16, 'p-value = P(Z ≥ 1.80 | H₀)', size => 7.8, anchor => 'end', bold => 1, fill => $C{orange});
  push @b, T(292, 28, '= 0.036 < α = 0.05', size => 7.8, anchor => 'end', fill => $C{orange});
  push @b, T(292, 40, '→ reject H₀', size => 7.8, anchor => 'end', bold => 1);
  push @b, T(8, 98, 'two-tailed test: p-value = 2 × one-tail area', size => 7.4, fill => $C{muted}, anchor => 'start');
  svg(300, 102, @b);
}

# Chapter 11
sub ill_se_triangle {
  my @b; my ($s1, $s2) = (sqrt(0.384), sqrt(2.89 / 12));
  my ($X, $Y) = mapper(79.4, 86.6, 0, 0.9, 8, 168, 12, 72);
  push @b, area(sub { npdf($_[0], 82, $s1) }, 79.4, 86.6, $X, $Y, fill => $C{blue}, op => 0.18), curve(sub { npdf($_[0], 82, $s1) }, 79.4, 86.6, $X, $Y, c => $C{blue}, w => 1.4);
  push @b, area(sub { npdf($_[0], 84, $s2) }, 79.4, 86.6, $X, $Y, fill => $C{orange}, op => 0.18), curve(sub { npdf($_[0], 84, $s2) }, 79.4, 86.6, $X, $Y, c => $C{orange}, w => 1.4);
  push @b, L(8, 72, 168, 72, c => $C{muted});
  push @b, T($X->(82), $Y->(npdf(0) / $s1) - 3, 'x̄₁ = 82', size => 7.4, fill => $C{blue}, bold => 1), T($X->(84), $Y->(npdf(0) / $s2) - 3, 'x̄₂ = 84', size => 7.4, fill => $C{orange}, bold => 1);
  push @b, L($X->(82), 82, $X->(84), 82, start => 'ah', end => 'ah'), T($X->(83), 95, 'gap x̄₁ − x̄₂ = −2', size => 7.4);
  my ($x0, $y0, $k) = (196, 82, 100);
  push @b, P("M$x0,$y0 L" . f1($x0 + $k * $s1) . ",$y0 L$x0," . f1($y0 - $k * $s2) . ' Z', fill => $C{lb}, c => $C{ink}, w => 1);
  push @b, R($x0, $y0 - 6, 6, 6, stroke => $C{ink}, sw => 0.7);
  push @b, L($x0, $y0, $x0 + $k * $s1, $y0, c => $C{blue}, w => 2.2), L($x0, $y0, $x0, $y0 - $k * $s2, c => $C{orange}, w => 2.2);
  push @b, L($x0 + $k * $s1, $y0, $x0, $y0 - $k * $s2, c => $C{ink}, w => 2.2);
  push @b, T($x0 + $k * $s1 / 2, $y0 + 11, 'SE₁ = 0.62', size => 7.4, fill => $C{blue}, bold => 1);
  push @b, T($x0 - 3, $y0 - $k * $s2 / 2 + 3, 'SE₂ = 0.49', size => 7.4, fill => $C{orange}, bold => 1, anchor => 'end');
  push @b, T($x0 + $k * $s1 / 2 + 6, $y0 - $k * $s2 / 2 - 3, 'SE diff = 0.79', size => 7.6, bold => 1, anchor => 'start');
  push @b, T(296, 14, 'variances add:', size => 7.4, fill => $C{muted}, anchor => 'end'), T(296, 25, '√(0.62² + 0.49²)', size => 7.4, fill => $C{muted}, anchor => 'end');
  svg(300, 100, @b);
}
sub ill_cohen {
  my @b; my $sp = sqrt(12.5);
  my ($X, $Y) = mapper(72, 101, 0, 0.125, 10, 290, 12, 66);
  push @b, area(sub { npdf($_[0], 85, $sp) }, 72, 101, $X, $Y, fill => $C{blue}, op => 0.15), area(sub { npdf($_[0], 88, $sp) }, 72, 101, $X, $Y, fill => $C{orange}, op => 0.15);
  push @b, curve(sub { npdf($_[0], 85, $sp) }, 72, 101, $X, $Y, c => $C{blue}), curve(sub { npdf($_[0], 88, $sp) }, 72, 101, $X, $Y, c => $C{orange});
  push @b, L(10, 66, 290, 66, c => $C{muted});
  push @b, L($X->(85), $Y->(npdf(0) / $sp), $X->(85), 78, c => $C{blue}, dash => '2 2'), L($X->(88), $Y->(npdf(0) / $sp), $X->(88), 78, c => $C{orange}, dash => '2 2');
  push @b, L($X->(85) + 1, 76, $X->(88) - 1, 76, start => 'ah', end => 'ah'), T($X->(88) + 5, 79, '|x̄₁ − x̄₂| = 88 − 85 = 3', size => 7.6, anchor => 'start', bold => 1);
  my $yh = $Y->(npdf(1) / $sp);
  push @b, L($X->(88), $yh, $X->(88 + $sp), $yh, c => $C{ink}, w => 1.4, end => 'ah'), T($X->(88 + $sp / 2), $yh - 4, 's_p = 3.54', size => 7.4, bold => 1, halo => 1);
  push @b, T($X->(78.6), $Y->(0.07), 'group 1', size => 7.6, fill => $C{blue}, anchor => 'end', bold => 1), T($X->(94.4), $Y->(0.07), 'group 2', size => 7.6, fill => $C{orange}, anchor => 'start', bold => 1);
  push @b, T(150, 96, 'd = 3 / 3.54 ≈ 0.85 → large      (0.2 small · 0.5 medium · 0.8 large)', size => 7.6);
  svg(300, 100, @b);
}
sub ill_two_prop {
  my @b;
  my ($X, $Y) = mapper(0, 1, 0, 0.5, 0, 1, 14, 76);
  push @b, L(30, $Y->($_), 172, $Y->($_), c => $C{grid}), T(26, $Y->($_) + 3, $_, size => 7, fill => $C{muted}, anchor => 'end') for (0, 0.25, 0.5);
  push @b, R(50, $Y->(0.42), 40, $Y->(0) - $Y->(0.42), fill => $C{mid}, stroke => $C{blue}), R(115, $Y->(0.35), 40, $Y->(0) - $Y->(0.35), fill => $C{lo}, stroke => $C{orange});
  push @b, T(70, $Y->(0.42) - 4, '84/200 = .42', size => 7.4, fill => $C{blue}, bold => 1), T(135, $Y->(0.378) - 4, '105/300 = .35', size => 7.4, fill => $C{orange}, bold => 1);
  push @b, L(40, $Y->(0.378), 168, $Y->(0.378), c => $C{ink}, w => 1.4, dash => '4 2');
  push @b, T(70, 88, 'p̂₁ (group 1)', size => 7.6), T(135, 88, 'p̂₂ (group 2)', size => 7.6);
  my @t = (['H₀: p₁ = p₂', 1, $C{ink}], ['pool (dashed line):', 0, $C{muted}], ['p̄ = (x₁ + x₂)/(n₁ + n₂)', 0, $C{ink}], ['= 189/500 = 0.378', 1, $C{ink}], ['one shared p̄ goes', 0, $C{muted}], ['into the SE', 0, $C{muted}]);
  push @b, T(182, 18 + 13.5 * $_, $t[$_][0], size => 7.6, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 94, @b);
}
sub ill_paired {
  my @b; my @be = (150, 142, 160, 155, 148, 165); my @af = (144, 140, 151, 152, 145, 158);
  my ($X, $Y) = mapper(0, 1, 136, 168, 0, 1, 10, 80);
  for my $i (0 .. 5) { push @b, L(30, $Y->($be[$i]), 110, $Y->($af[$i]), c => '#9AA7B4'), Ci(30, $Y->($be[$i]), 3, fill => $C{blue}), Ci(110, $Y->($af[$i]), 3, fill => $C{orange}) }
  push @b, T(30, 94, 'before', size => 7.8, fill => $C{blue}, bold => 1), T(110, 94, 'after', size => 7.8, fill => $C{orange}, bold => 1);
  push @b, T(70, 8, 'same 6 people', size => 7.2, fill => $C{muted});
  my ($D) = mapper(-10.5, 0.5, 0, 1, 150, 292, 0, 1); my %seen;
  push @b, L(150, 58, 292, 58, c => $C{muted}); push @b, tick($D->($_), 58, $_) for (-10, -5, 0);
  for my $d (map { $af[$_] - $be[$_] } 0 .. 5) { push @b, Ci($D->($d), 52 - 7 * ($seen{$d}++ // 0), 3, fill => $C{ink}) }
  push @b, P('M' . f1($D->(-5)) . ',60 L' . f1($D->(-5) - 4) . ',66 L' . f1($D->(-5) + 4) . ',66 Z', fill => $C{green});
  push @b, T($D->(-5), 30, 'x̄d = −5', size => 7.8, fill => $C{green}, bold => 1);
  push @b, T(221, 14, 'differences d = after − before', size => 7.4, fill => $C{muted});
  push @b, T(221, 84, 'one-sample t on the d values', size => 7.4), T(221, 95, 'df = (number of pairs) − 1 = 5', size => 7.4, fill => $C{muted});
  svg(300, 100, @b);
}

# Chapter 12
sub ill_gof {
  my @b; my @o = (23, 16, 14, 19, 28); my @day = qw(Mon Tue Wed Thu Fri);
  my ($X, $Y) = mapper(0.4, 5.6, 0, 31, 14, 198, 10, 80);
  for my $i (0 .. 4) {
    my $x = $i + 1; my $g = $o[$i] - 20;
    push @b, R($X->($x - 0.32), $Y->($o[$i]), $X->(0.64) - $X->(0), $Y->(0) - $Y->($o[$i]), fill => $C{mid}, stroke => $C{blue});
    push @b, L($X->($x), $Y->(20), $X->($x), $Y->($o[$i]), c => $C{orange}, w => 2.2);
    push @b, T($X->($x) + 3, $Y->($o[$i]) + ($g > 0 ? -3 : 10), ($g > 0 ? '+' : '−') . abs($g), size => 7.4, fill => $C{orange}, bold => 1, anchor => 'start');
    push @b, T($X->($x), 91, $day[$i], size => 7.4, fill => $C{muted});
  }
  push @b, L($X->(0.4), $Y->(20), $X->(5.6), $Y->(20), c => $C{orange}, dash => '4 2', w => 1.3);
  push @b, L($X->(0.4), 80, $X->(5.6), 80, c => $C{muted});
  my @t = (['O = observed (bars)', 0, $C{blue}], ['E = n·p = 20 (dashed)', 0, $C{orange}], ['gaps O − E sum to 0', 0, $C{muted}], ['χ² = Σ (O − E)² / E', 1, $C{ink}], ['= 126 / 20 = 6.3', 1, $C{ink}], ['df = k − 1 = 4', 0, $C{ink}]);
  push @b, T(206, 16 + 14 * $_, $t[$_][0], size => 7.6, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 96, @b);
}
sub ill_chisq {
  my @b;
  my ($X, $Y) = mapper(0, 22, 0, 0.26, 12, 290, 10, 80);
  push @b, area(sub { chipdf($_[0], 5) }, 11.07, 22, $X, $Y, fill => $C{tail});
  push @b, curve(sub { chipdf($_[0], 3) }, 0.02, 22, $X, $Y, c => $C{sky}, n => 160);
  push @b, curve(sub { chipdf($_[0], 5) }, 0.02, 22, $X, $Y, c => $C{blue}, w => 1.9);
  push @b, curve(sub { chipdf($_[0], 10) }, 0.02, 22, $X, $Y, c => $C{green});
  push @b, L(12, 80, 290, 80, c => $C{muted});
  push @b, tick($X->($_), 80, $_) for (0, 5, 10, 15, 20);
  my @leg = (['df = 3', $C{sky}], ['df = 5', $C{blue}], ['df = 10', $C{green}]);
  for (0 .. 2) { push @b, L(214, 30 + 12 * $_, 228, 30 + 12 * $_, c => $leg[$_][1], w => 2), T(232, 33 + 12 * $_, $leg[$_][0], size => 7.6, fill => $leg[$_][1], bold => 1, anchor => 'start') }
  push @b, L($X->(11.07), $Y->(chipdf(11.07, 5)), $X->(11.07), 80, c => $C{tailtxt}, dash => '2 2');
  push @b, T(150, 104, 'red tail: α = 0.05 beyond the critical value 11.07 (df = 5)', size => 7.4, fill => $C{tailtxt});
  push @b, T(290, 16, 'χ² ≥ 0 · right-skewed · center ≈ df', size => 7.6, anchor => 'end', fill => $C{muted});
  svg(300, 108, @b);
}
sub ill_chidist {   # the df = 4 density with its mean, the p-value area beyond 6.3 and the 5% tail beyond 9.49
  my @b;
  my $f = sub { chipdf($_[0], 4) };
  my ($X, $Y) = mapper(0, 16, 0, 0.19, 12, 290, 22, 80);
  push @b, area($f, 6.3, 16, $X, $Y, fill => $C{lo});
  push @b, area($f, 9.49, 16, $X, $Y, fill => $C{tail});
  push @b, curve($f, 0.01, 16, $X, $Y, c => $C{blue}, w => 1.9, n => 160);
  push @b, L(12, 80, 290, 80, c => $C{muted});
  push @b, tick($X->($_), 80, $_) for (0, 4, 8, 12, 16);
  push @b, L($X->(4), 24, $X->(4), 80, c => $C{ink}, dash => '3 2');
  push @b, T($X->(4) + 3, 30, 'mean μ = k = 4', size => 7.6, bold => 1, anchor => 'start');
  push @b, L($X->(6.3), 46, $X->(6.3), 80, c => $C{orange}, w => 1.3);
  push @b, T($X->(6.3) + 3, 50, 'χ² = 6.3 → area beyond ≈ 0.178 (p-value)', size => 7.4, fill => $C{orange}, anchor => 'start');
  push @b, L($X->(9.49), 62, $X->(9.49), 80, c => $C{tailtxt}, dash => '2 2');
  push @b, T($X->(9.49) + 3, 66, '9.49 → area beyond 0.05', size => 7.4, fill => $C{tailtxt}, anchor => 'start');
  push @b, T(150, 104, 'df = 4: f(x) = x·e^(−x/2) / 4, peak at x = k − 2 = 2, mean at k = 4', size => 7.4, fill => $C{muted});
  push @b, T(290, 12, 'more df → curve moves right and spreads (σ = √2k)', size => 7.2, anchor => 'end', fill => $C{muted});
  svg(300, 108, @b);
}
sub ill_indep {
  my @b;
  my @cx = (24, 66, 106, 146, 186); my @ry = (8, 26, 48, 70);
  push @b, R(46, 26, 40, 22, fill => $C{lo}, stroke => $C{orange}, sw => 1.6);
  push @b, R(166, 26, 40, 22, fill => $C{lb}, stroke => $C{blue}), R(46, 70, 40, 18, fill => $C{lb}, stroke => $C{blue});
  push @b, L(6, 26, 206, 26, c => $C{grid}), L(6, 70, 206, 70, c => $C{grid}), L(46, 8, 46, 88, c => $C{grid}), L(166, 8, 166, 88, c => $C{grid});
  my @rows = (['', 'C1', 'C2', 'C3', 'total'], ['R1', 30, 45, 25, 100], ['R2', 50, 35, 15, 100], ['total', 80, 80, 40, 200]);
  for my $r (0 .. 3) { for my $c (0 .. 4) {
    my $y = $r == 0 ? 20 : $r == 3 ? 83 : $ry[$r] + 13;
    push @b, T($cx[$c], $y, $rows[$r][$c], size => 8, bold => ($r == 0 || $c == 0 || ($r == 3 && $c == 4)), fill => (($r == 1 && $c == 4) || ($r == 3 && $c == 1)) ? $C{blue} : $C{ink});
  } }
  push @b, T(66, 46, 'E = 40', size => 6.8, fill => $C{orange}, bold => 1);
  my @t = (['E(R1, C1)', 1, $C{orange}], ['= row × col / grand', 0, $C{ink}], ['= 100 × 80 / 200 = 40', 0, $C{orange}], ['df = (r − 1)(c − 1)', 1, $C{ink}], ['= (2 − 1)(3 − 1) = 2', 0, $C{ink}]);
  push @b, T(212, 16 + 14 * $_, $t[$_][0], size => 7.4, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  push @b, T(150, 102, 'H₀: the two variables are independent', size => 7.4, fill => $C{muted});
  svg(300, 106, @b);
}

# Chapter 13
my @XY = ([3, 4], [4, 5], [6, 9], [8, 10], [9, 12]);
sub ill_lsq {
  my @b; my ($m, $c) = (170 / 130, (40 - 170 / 130 * 30) / 5);
  my ($X, $Y) = mapper(0, 10.5, 0, 14, 22, 196, 8, 84);
  push @b, L(22, 84, 196, 84, c => $C{muted}), L(22, 8, 22, 84, c => $C{muted});
  push @b, tick($X->($_), 84, $_) for (0, 2, 4, 6, 8, 10);
  push @b, T(18, $Y->($_) + 3, $_, size => 7, fill => $C{muted}, anchor => 'end') for (0, 5, 10);
  push @b, L($X->(1), $Y->($m + $c), $X->(10.3), $Y->($m * 10.3 + $c), c => $C{orange}, w => 1.8);
  for (@XY) { my ($x, $y) = @$_; push @b, L($X->($x), $Y->($y), $X->($x), $Y->($m * $x + $c), c => $C{tailtxt}, dash => '2 1.5', w => 1.2), Ci($X->($x), $Y->($y), 3.2, fill => $C{blue}) }
  push @b, T($X->(1.2), $Y->(12.5), 'ŷ = 1.308x + 0.154', size => 7.8, fill => $C{orange}, bold => 1, anchor => 'start');
  push @b, T($X->(6.6), $Y->(3.2), 'residual = y − ŷ', size => 7.2, fill => $C{tailtxt}, anchor => 'start');
  my @t = (['n = 5, Σx = 30, Σy = 40', 0, $C{muted}], ['Σxy = 274, Σx² = 206', 0, $C{muted}], ['m = (5·274 − 30·40)', 0, $C{ink}], ['    / (5·206 − 30²)', 0, $C{ink}], ['  = 170/130 ≈ 1.308', 1, $C{orange}], ['b = (40 − m·30)/5 ≈ 0.154', 1, $C{orange}]);
  push @b, T(202, 16 + 14 * $_, $t[$_][0], size => 7.2, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  push @b, T(110, 104, 'the line that makes Σ residual² as small as possible', size => 7.2, fill => $C{muted}, italic => 1);
  svg(300, 108, @b);
}
sub ill_cov {
  my @b; my ($mx, $my) = (6, 8);
  my ($X, $Y) = mapper(2, 10, 2, 14, 18, 186, 8, 90);
  push @b, R($X->($mx), $Y->(14), $X->(10) - $X->($mx), $Y->($my) - $Y->(14), fill => $C{lg}), R($X->(2), $Y->($my), $X->($mx) - $X->(2), $Y->(2) - $Y->($my), fill => $C{lg});
  push @b, R($X->(2), $Y->(14), $X->($mx) - $X->(2), $Y->($my) - $Y->(14), fill => $C{lo}), R($X->($mx), $Y->($my), $X->(10) - $X->($mx), $Y->(2) - $Y->($my), fill => $C{lo});
  for (@XY) { my ($x, $y) = @$_; next if $x == $mx;
    my ($x1, $x2) = sort { $a <=> $b } ($X->($mx), $X->($x)); my ($y1, $y2) = sort { $a <=> $b } ($Y->($my), $Y->($y));
    push @b, R($x1, $y1, $x2 - $x1, $y2 - $y1, stroke => $C{green}, sw => 0.9, dash => '2 1.5') }
  push @b, L($X->($mx), 8, $X->($mx), 90, c => $C{ink}, dash => '3 2'), L(18, $Y->($my), 186, $Y->($my), c => $C{ink}, dash => '3 2');
  push @b, Ci($X->($_->[0]), $Y->($_->[1]), 3.2, fill => $C{blue}) for @XY;
  push @b, T($X->(9.5), $Y->(13.2), '+', size => 14, bold => 1, fill => $C{green}), T($X->(2.5), $Y->(2.6), '+', size => 14, bold => 1, fill => $C{green});
  push @b, T($X->(2.5), $Y->(13.2), '−', size => 14, bold => 1, fill => $C{orange}), T($X->(9.5), $Y->(2.6), '−', size => 14, bold => 1, fill => $C{orange});
  push @b, T($X->($mx) + 3, 98, 'x̄ = 6', size => 7.2, anchor => 'start'), T(184, $Y->($my) - 3, 'ȳ = 8', size => 7.2, anchor => 'end');
  my @t = (['each box = (x − x̄)(y − ȳ)', 0, $C{green}], ['12 + 6 + 0 + 4 + 12', 0, $C{muted}], ['Σ = 34', 1, $C{ink}], ['cov = 34 / (5 − 1) = 8.5', 1, $C{blue}], ['all points in + corners', 0, $C{muted}], ['→ positive relationship', 0, $C{muted}]);
  push @b, T(194, 16 + 14 * $_, $t[$_][0], size => 7.2, bold => $t[$_][1], fill => $t[$_][2], anchor => 'start') for 0 .. $#t;
  svg(300, 104, @b);
}
sub ill_corr {
  my @b; my @rho = (0.9, 0, -0.9); my @name = ('strong positive', 'no linear link', 'strong negative');
  for my $i (0 .. 2) {
    seed(31 + 7 * $i); my (@x, @y);
    for (1 .. 28) { my $a = rnorm(); my $e = rnorm(); push @x, $a; push @y, $rho[$i] * $a + sqrt(1 - $rho[$i]**2) * $e }
    my ($n, $sx, $sy, $sxy, $sxx, $syy) = (scalar @x, 0, 0, 0, 0, 0);
    for (0 .. $#x) { $sx += $x[$_]; $sy += $y[$_]; $sxy += $x[$_] * $y[$_]; $sxx += $x[$_]**2; $syy += $y[$_]**2 }
    my $r = ($n * $sxy - $sx * $sy) / sqrt(($n * $sxx - $sx**2) * ($n * $syy - $sy**2));
    my $ox = 6 + 99 * $i;
    my ($X, $Y) = mapper(-2.7, 2.7, -2.7, 2.7, $ox + 4, $ox + 88, 6, 70);
    push @b, R($ox + 2, 4, 88, 68, stroke => $C{grid});
    push @b, Ci($X->($x[$_]), $Y->($y[$_]), 2.3, fill => $C{blue}, op => 0.85) for 0 .. $#x;
    push @b, T($ox + 46, 84, sprintf('r = %.2f', $r) =~ s/-/−/r, size => 8.2, bold => 1), T($ox + 46, 95, $name[$i], size => 7.2, fill => $C{muted});
  }
  svg(300, 100, @b);
}

# ================================================================ the page
my $CSS = <<'CSS';
@page { size: A4; margin: 10mm 9mm 11mm;
  @bottom-center { content: "Statistics formula sheet  ·  " counter(page) " / " counter(pages); font-family: Arial, sans-serif; font-size: 6.5pt; color: #6a737d; } }
html { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
* { box-sizing: border-box; }
body { font-family: "Segoe UI", Arial, sans-serif; font-size: 8.1pt; line-height: 1.36; color: #24292f; margin: 0; background: #ffffff; }
.wrap { max-width: 196mm; margin: 0 auto; padding: 0 2mm; }
header.top { border-bottom: 2.5px solid #1f3a5f; margin: 0 0 3mm; padding: 2mm 0 2mm; display: flex; justify-content: space-between; align-items: flex-end; gap: 6mm; }
header.top h1 { font-size: 19pt; margin: 0; color: #1f3a5f; letter-spacing: -0.3px; line-height: 1.1; }
header.top .sub { margin: 1mm 0 0; color: #3b4a5a; font-size: 8.2pt; }
header.top .legend { font-size: 7.4pt; color: #3b4a5a; text-align: right; line-height: 1.6; flex-shrink: 0; }
.sw { display: inline-block; width: 9px; height: 9px; border-radius: 2px; vertical-align: -1px; margin: 0 2px 0 6px; }
h2.ch { font-size: 10.5pt; color: #ffffff; background: #1f3a5f; margin: 1.5mm 0 2.5mm; padding: 2.2px 9px; border-radius: 4px; break-after: avoid; page-break-after: avoid; }
h2.ch .num { display: inline-block; background: #ffffff; color: #1f3a5f; border-radius: 3px; padding: 0 5px; margin-right: 6px; font-size: 9pt; }
.cols { columns: 2; column-gap: 4mm; }
.card { break-inside: avoid; page-break-inside: avoid; display: block; width: 100%; border: 1px solid #d0d7de; border-radius: 5px; margin: 0 0 3.2mm; padding: 4px 7px 5px; background: #ffffff; }
.card h3 { font-size: 9.2pt; color: #1f3a5f; margin: 0 0 3px; padding-bottom: 2px; border-bottom: 1px solid #e3e8ee; display: flex; justify-content: space-between; align-items: baseline; gap: 6px; }
.card h3 .ls { font-size: 6.8pt; font-weight: normal; color: #6a737d; white-space: nowrap; }
.card p { margin: 2px 0; }
table.ft { border-collapse: collapse; width: 100%; margin: 2px 0 3px; }
table.ft td, table.ft th { padding: 1.5px 4px; border-bottom: 1px solid #eef1f4; vertical-align: middle; text-align: left; }
table.ft th { font-size: 7.2pt; color: #6a737d; font-weight: 600; background: #f6f8fa; }
table.ft td.k { color: #3b4a5a; font-size: 7.5pt; white-space: nowrap; width: 1%; }
table.ft tr:last-child td { border-bottom: 0; }
table.ft.c td, table.ft.c th { text-align: center; }
.f { text-align: center; margin: 3px 0; }
.nb { font-size: 7.4pt; color: #3b4a5a; background: #f7f9fb; border-left: 3px solid #c8d1dc; padding: 2px 6px; margin: 3px 0 1px; }
.nb b { color: #1f3a5f; }
ul.tight { margin: 2px 0; padding-left: 14px; } ul.tight li { margin: 1px 0; }
svg.ill { width: 100%; height: auto; display: block; margin: 4px 0 2px; overflow: visible; }
svg.ill text { font-family: "Segoe UI", Arial, sans-serif; }
code { font-family: Consolas, "Courier New", monospace; font-size: 7.4pt; background: #f2f4f6; padding: 0 2px; border-radius: 2px; }
.katex { font-size: 1.04em; }
.b { color: #0072B2; } .o { color: #D55E00; } .g { color: #009E73; } .r { color: #C0392B; }
.full { break-inside: avoid; border: 1.5px solid #1f3a5f; border-radius: 5px; padding: 5px 8px 6px; margin: 1mm 0 3mm; }
.full h3 { font-size: 10pt; color: #1f3a5f; margin: 0 0 3px; }
.full table.ft td { padding: 2.5px 5px; }
@media screen { body { background: #eef1f4; } .wrap { max-width: 210mm; background: #ffffff; padding: 8mm 9mm; margin: 6mm auto; box-shadow: 0 1px 4px rgba(0,0,0,.12); } }
@media screen and (max-width: 640px) { .cols { columns: 1; } .wrap { padding: 4mm 16px; margin: 0; } header.top { display: block; } header.top .legend { text-align: left; margin-top: 2mm; } table.ft { display: block; overflow-x: auto; } }
CSS

my $BODY = <<'BODY';
<header class="top">
  <div>
    <h1>Statistics Formula Sheet</h1>
    <p class="sub">Every formula from chapters 1–13 of these notes, each with a sketch of what it means. Grey numbers (e.g. <b>3.11</b>) point to the lesson note.</p>
  </div>
  <div class="legend">
    In the sketches:<br>
    <span class="sw" style="background:#0072B2"></span>population · H₀ · main quantity<br>
    <span class="sw" style="background:#D55E00"></span>sample · Hₐ · what is asked<br>
    <span class="sw" style="background:#E8B4B4"></span>tail · rejection region
  </div>
</header>

<!-- ======================================================= 1 -->
<h2 class="ch"><span class="num">1</span>Introduction to statistics</h2>
<div class="cols">
<div class="card"><h3>Population vs sample <span class="ls">1.2 · 1.4</span></h3>
<table class="ft c"><tr><th></th><th>size</th><th>mean</th><th>SD</th><th>var.</th><th>prop.</th></tr>
<tr><td class="k">population → <b>parameter</b></td><td>$N$</td><td>$\mu$</td><td>$\sigma$</td><td>$\sigma^2$</td><td>$p$</td></tr>
<tr><td class="k">sample → <b>statistic</b></td><td>$n$</td><td>$\bar x$</td><td>$s$</td><td>$s^2$</td><td>$\hat p$</td></tr></table>
@@pop_sample@@
<p class="nb">We compute statistics ($\bar x, s, \hat p$) to <b>estimate</b> unknown parameters ($\mu, \sigma, p$). Bigger samples → more precise inferences.</p>
</div>
<div class="card"><h3>Types of data &amp; scales of measurement <span class="ls">1.3 · 1.5 · 6.5</span></h3>
<ul class="tight"><li><b>Quantitative</b> (numbers): <b>discrete</b> = counted, whole values · <b>continuous</b> = measured, any value in a range.</li>
<li><b>Qualitative</b> (categories, words): colors, tastes, opinions.</li></ul>
@@noir@@
<p class="nb">Ratios like "twice as much" only make sense on a <b>ratio</b> scale (true zero): 20 kg is twice 10 kg, but 20 °C is not twice as hot as 10 °C.</p>
</div>
</div>

<!-- ======================================================= 2 -->
<h2 class="ch"><span class="num">2</span>Graphs and tables</h2>
<div class="cols">
<div class="card"><h3>Frequency tables <span class="ls">2.1 · 2.2 · 2.3</span></h3>
<table class="ft">
<tr><td class="k">total</td><td>$n = \sum f$</td><td class="k">relative freq.</td><td>$\text{RF} = \dfrac{f}{n}$ (sums to 1)</td></tr>
<tr><td class="k">cumulative RF</td><td colspan="3">CRF = running sum of RF; never decreases, ends at <b>1.00</b> → "share at or below"</td></tr>
<tr><td class="k">mean from table</td><td>$\bar x = \dfrac{\sum V f}{n}$</td><td class="k">median</td><td>position $\frac{n+1}{2}$ via running $f$</td></tr></table>
@@freq@@
</div>
<div class="card"><h3>Dot plots, line plots, stem-and-leaf <span class="ls">2.4 – 2.7</span></h3>
@@dot_stem@@
<ul class="tight"><li>Height of a column = <b>frequency</b>; mode = tallest column; total amount $= \sum(\text{value}\times\text{frequency})$.</li>
<li>"<b>at least</b> $k$" = $x \ge k$, "<b>at most</b> $k$" = $x \le k$ — both include $k$.</li>
<li>Stem = leading digit(s), leaf = last digit, sorted, no empty stems skipped, <b>always a key</b>. Side-by-side: left leaves run in reverse.</li></ul>
</div>
<div class="card"><h3>Histogram &amp; frequency polygon <span class="ls">2.8 · 2.9</span></h3>
<p class="f">$\text{class midpoint} = \dfrac{\text{lower bound} + \text{upper bound}}{2}$</p>
@@hist_poly@@
<p class="nb">Equal-width classes. Histogram bars <b>touch</b> (bar-graph bars don't). For the polygon, add a point with $f = 0$ one class width beyond each end. Long right tail → <b>skewed right</b>.</p>
</div>
</div>

<!-- ======================================================= 3 -->
<h2 class="ch"><span class="num">3</span>Central tendency and variation</h2>
<div class="cols">
<div class="card"><h3>Mean, median, mode, range <span class="ls">3.2 – 3.5 · 3.9</span></h3>
<table class="ft">
<tr><td class="k">mean</td><td>$\bar x = \dfrac{\sum x}{n}$ (sample) &nbsp; $\mu = \dfrac{\sum x}{N}$ (population)</td></tr>
<tr><td class="k">median (sorted!)</td><td>$n$ odd: $a_{\frac{n+1}{2}}$ &nbsp;&nbsp; $n$ even: $\dfrac{a_{n/2} + a_{n/2+1}}{2}$</td></tr>
<tr><td class="k">mode</td><td>most frequent value (can be none, or several)</td></tr>
<tr><td class="k">range · midrange</td><td>$H - L$ &nbsp;·&nbsp; $\dfrac{H + L}{2}$ &nbsp;·&nbsp; coeff. of range $\dfrac{H - L}{H + L}$</td></tr>
<tr><td class="k">missing value</td><td>$n \times \text{target mean} - \sum(\text{known values})$</td></tr></table>
@@center@@
</div>
<div class="card"><h3>Four means &amp; the weighted mean <span class="ls">3.1 · 3.6 · 3.7</span></h3>
<table class="ft"><tr><th>mean</th><th>$n$ values</th><th>two values $a, b$</th></tr>
<tr><td class="k">arithmetic A</td><td>$\dfrac{x_1 + \dots + x_n}{n}$</td><td>$\dfrac{a+b}{2}$</td></tr>
<tr><td class="k">geometric G</td><td>$(x_1 x_2 \cdots x_n)^{1/n}$</td><td>$\sqrt{ab}$</td></tr>
<tr><td class="k">harmonic H</td><td>$\dfrac{n}{\sum 1/x}$</td><td>$\dfrac{2ab}{a+b}$</td></tr>
<tr><td class="k">root mean square R</td><td>$\sqrt{\dfrac{\sum x^2}{n}}$</td><td>$\sqrt{\dfrac{a^2+b^2}{2}}$</td></tr>
<tr><td class="k">weighted</td><td colspan="2">$\bar x_w = \dfrac{\sum w x}{\sum w}$ &nbsp; ($x$ = what you average, $w$ = how much each counts)</td></tr></table>
@@means@@
<p class="nb"><b>Harmonic</b> = average speed over equal distances. <b>Weighted</b> = grades, GPA, mixtures; pulled toward the heaviest weights.</p>
</div>
<div class="card"><h3>Variance, standard deviation, MAD <span class="ls">3.11 · 3.13 · 3.18 · 3.19</span></h3>
<table class="ft"><tr><th></th><th>sample (÷ $n-1$)</th><th>population (÷ $N$)</th></tr>
<tr><td class="k">variance</td><td>$s^2 = \dfrac{\sum (x - \bar x)^2}{n - 1}$</td><td>$\sigma^2 = \dfrac{\sum (x - \mu)^2}{N}$</td></tr>
<tr><td class="k">standard deviation</td><td>$s = \sqrt{s^2}$</td><td>$\sigma = \sqrt{\sigma^2}$</td></tr>
<tr><td class="k">mean abs. deviation</td><td colspan="2">$\text{MAD} = \dfrac{\sum |x - \bar x|}{n}$ &nbsp;&nbsp; signed: $\dfrac{\sum (x - \bar x)}{n} = 0$ always</td></tr></table>
@@sd@@
<p class="nb">SD = typical distance from the mean; variance is in <b>squared</b> units. Excel: <code>STDEV.S</code>/<code>VAR.S</code> (sample), <code>STDEV.P</code>/<code>VAR.P</code> (population).</p>
</div>
<div class="card"><h3>Coefficient of variation &amp; quick uncertainty <span class="ls">3.10 · 3.12</span></h3>
<table class="ft">
<tr><td class="k">coefficient of variation</td><td>$\text{CV} = \dfrac{s}{\bar x}\times 100\%$ &nbsp; (population: $\dfrac{\sigma}{\mu}\times 100\%$)</td></tr>
<tr><td class="k">quick uncertainty</td><td>report $\bar x \pm u$, &nbsp; $u = \dfrac{\text{range}}{2}$ rounded to 1 significant figure</td></tr></table>
@@cv@@
<p class="nb">CV has <b>no units</b> → use it to compare spread between data sets with different means or units. Test B varies 3× more relative to its mean.</p>
</div>
<div class="card"><h3>Grouped data <span class="ls">3.14 – 3.17</span></h3>
<table class="ft">
<tr><td class="k">mean</td><td>$\bar x \approx \dfrac{\sum f m}{\sum f}$, &nbsp;$m$ = class midpoint</td></tr>
<tr><td class="k">SD</td><td>$s \approx \sqrt{\dfrac{\sum f (m - \bar x)^2}{n - 1}}$, &nbsp; $n = \sum f$</td></tr>
<tr><td class="k">median</td><td>$L + \left(\dfrac{\frac n2 - C}{f}\right) h$ &nbsp; ($C$ = cum. freq. <b>before</b> median class)</td></tr>
<tr><td class="k">mode</td><td>$L + h\left(\dfrac{f_m - f_1}{2f_m - f_1 - f_2}\right)$ &nbsp; ($f_1$ before, $f_2$ after)</td></tr></table>
@@grouped@@
<p class="nb">$L$ = lower <b>boundary</b> (69.5, not 70) and $h$ = boundary width (10, not 9). Results are estimates.</p>
</div>
<div class="card"><h3>Statistics in Excel <span class="ls">3.8</span></h3>
<table class="ft">
<tr><td class="k">basics</td><td><code>SUM</code> <code>COUNT</code> <code>AVERAGE</code> <code>MEDIAN</code> <code>MODE</code> <code>MIN</code> <code>MAX</code></td></tr>
<tr><td class="k">spread</td><td><code>STDEV.S</code> <code>VAR.S</code> (sample) · <code>STDEV.P</code> <code>VAR.P</code> (population)</td></tr>
<tr><td class="k">position</td><td><code>QUARTILE(range, 0…4)</code> · <code>PERCENTILE(range, k/100)</code> · decile $D_k$ = <code>PERCENTILE(range, k/10)</code></td></tr>
<tr><td class="k">regression</td><td><code>SLOPE</code> <code>INTERCEPT</code> <code>CORREL</code> · tables: <code>NORM.S.DIST</code>, <code>T.INV</code>, <code>CHISQ.INV.RT</code></td></tr></table>
<p class="nb">Excel's quartile rule can differ slightly from the hand method — several conventions exist.</p>
</div>
</div>

<!-- ======================================================= 4 -->
<h2 class="ch"><span class="num">4</span>Measures of position</h2>
<div class="cols">
<div class="card"><h3>Quartiles, deciles, percentiles <span class="ls">4.1 · 4.3</span></h3>
<table class="ft">
<tr><td class="k">position of $P_k$</td><td>$L_k = \dfrac{k}{100}(n + 1)$ &nbsp;&nbsp; quartile: $\dfrac{k(n+1)}{4}$</td></tr>
<tr><td class="k">percentile of value $v$</td><td>$\dfrac{x + 0.5\,y}{n}\times 100$ &nbsp; ($x$ below $v$, $y$ equal to $v$)</td></tr>
<tr><td class="k">same thing</td><td>$Q_1 = P_{25}, \;\; Q_2 = D_5 = P_{50}, \;\; Q_3 = P_{75}$</td></tr></table>
@@quartiles@@
<p class="nb">Position not a whole number → average the two neighbours (or interpolate: 10.2 → $a_{10} + 0.2(a_{11} - a_{10})$).</p>
</div>
<div class="card"><h3>IQR, box plots &amp; outliers <span class="ls">4.2 · 4.3 · 4.4</span></h3>
<table class="ft">
<tr><td class="k">IQR · quartile deviation</td><td>$\text{IQR} = Q_3 - Q_1, \qquad \text{QD} = \dfrac{Q_3 - Q_1}{2}$</td></tr>
<tr><td class="k">coeff. of QD (no units)</td><td>$\text{CQD} = \dfrac{Q_3 - Q_1}{Q_3 + Q_1}$</td></tr>
<tr><td class="k">outlier fences</td><td>$Q_1 - 1.5\,\text{IQR}$ &nbsp;and&nbsp; $Q_3 + 1.5\,\text{IQR}$</td></tr></table>
@@boxplot@@
<p class="nb">Box = $Q_1$ to $Q_3$, line = median; whiskers reach the most extreme <b>non-outliers</b>; values beyond the fences are dots.</p>
</div>
<div class="card"><h3>Shape &amp; skewness <span class="ls">4.5 · 1.1</span></h3>
@@skew@@
<p class="nb">Lines: <b class="b">mode</b>, <b class="g">median</b>, <b class="o">mean</b>. The mean is pulled toward the tail. On a box plot the <b>longer side</b> points the way of the skew. One / two / many peaks = unimodal / bimodal / multimodal.</p>
</div>
</div>

<!-- ======================================================= 5 -->
<h2 class="ch"><span class="num">5</span>Probability</h2>
<div class="cols">
<div class="card"><h3>Basic probability &amp; complements <span class="ls">5.1 · 5.3 · 5.8</span></h3>
<p class="f">$P(A) = \dfrac{n(A)}{n(S)} = \dfrac{\text{favorable}}{\text{total}}, \qquad 0 \le P(A) \le 1$<br>$P(A') = 1 - P(A)$</p>
@@complement@@
<p class="nb">$n$ fair coin flips in one given order: $(1/2)^n$. "In any order" → count every arrangement that works.</p>
</div>
<div class="card"><h3>Addition rule — "or" <span class="ls">5.2 · 5.6 · 5.7</span></h3>
<p class="f">$P(A \cup B) = P(A) + P(B) - P(A \cap B)$<br>mutually exclusive: $P(A \cup B) = P(A) + P(B)$</p>
@@addition@@
<p class="nb"><b>or</b> → $\cup$ → add (minus the overlap). A probability above 1 means an overlap was counted twice.</p>
</div>
<div class="card"><h3>Conditional probability &amp; multiplication — "and" <span class="ls">5.4 · 5.5 · 5.7 · 5.8</span></h3>
<table class="ft">
<tr><td class="k">conditional</td><td>$P(A \mid B) = \dfrac{P(A \cap B)}{P(B)} = \dfrac{n(A \cap B)}{n(B)}$</td></tr>
<tr><td class="k">multiplication</td><td>$P(A \cap B) = P(A \mid B)\,P(B) = P(B \mid A)\,P(A)$</td></tr>
<tr><td class="k">independent</td><td>$P(A \cap B) = P(A)\,P(B)$ &nbsp; (with replacement)</td></tr>
<tr><td class="k">chain (dependent)</td><td>$P(A_1 \cap B_2 \cap C_3) = P(A_1)\,P(B_2 \mid A_1)\,P(C_3 \mid A_1 \cap B_2)$</td></tr></table>
@@conditional@@
<p class="nb"><b>Independent ≠ mutually exclusive.</b> Independent: one doesn't affect the other. Mutually exclusive: can't both happen, $P(A\cap B) = 0$. Without replacement → update counts <b>and</b> total.</p>
</div>
<div class="card"><h3>Tree diagrams &amp; Bayes' theorem <span class="ls">5.10 · 5.11</span></h3>
<p class="f">$P(A \mid B) = \dfrac{P(B \mid A)\,P(A)}{P(B)}$<br>$P(B) = P(B \mid A)\,P(A) + P(B \mid A')\,P(A')$ &nbsp; (add the branches that end in $B$)</p>
@@tree@@
<p class="nb">Rare condition (1%) + 10% false positives → only ~9% of positive tests are real. Check with counts (e.g. 10,000 people).</p>
</div>
<div class="card"><h3>Expected value <span class="ls">5.9</span></h3>
<p class="f">$E(X) = \sum x\,P(x) = x_1p_1 + x_2p_2 + \dots + x_np_n$</p>
@@expected@@
<p class="nb">Total expected over $n$ trials $= n\,E(X)$. Losses go in as <b>negative</b> values; the $p$'s add to 1. $E(X)$ is a long-run average — no single game pays exactly 1.25.</p>
</div>
</div>

<!-- ======================================================= 6 -->
<h2 class="ch"><span class="num">6</span>Discrete probability distributions</h2>
<div class="cols">
<div class="card"><h3>Binomial — $x$ successes in $n$ trials <span class="ls">6.1 · 6.2</span></h3>
<p class="f">$P(X = x) = {}_nC_x\, p^x q^{\,n-x}, \qquad {}_nC_x = \dfrac{n!}{(n-x)!\,x!}, \qquad q = 1 - p$<br>$\mu = np, \qquad \sigma = \sqrt{npq}$</p>
@@binom@@
<p class="nb">Fixed $n$, success/failure, independent trials, same $p$. "Exactly" → one term; "at most / at least / fewer than" → add terms (remember $x = 0$).</p>
</div>
<div class="card"><h3>Geometric — waiting for the first success <span class="ls">6.1 · 6.3</span></h3>
<table class="ft c"><tr><th>on trial $x$</th><th>by trial $x$</th><th>before $x$</th><th>after $x$</th><th>$x$ or later</th></tr>
<tr><td>$q^{x-1}p$</td><td>$1 - q^x$</td><td>$1 - q^{x-1}$</td><td>$q^x$</td><td>$q^{x-1}$</td></tr></table>
<p class="f">$\mu = \dfrac1p, \qquad \sigma^2 = \dfrac{1-p}{p^2}, \qquad \sigma = \dfrac{\sqrt{1-p}}{p}$</p>
@@geom@@
</div>
<div class="card"><h3>Poisson — events in an interval <span class="ls">6.1 · 6.4</span></h3>
<p class="f">$P(X = x) = \dfrac{\mu^x e^{-\mu}}{x!}, \qquad \dfrac{\mu_2}{\mu_1} = \dfrac{t_2}{t_1}, \qquad \text{mean} = \sigma^2 = \mu,\;\; \sigma = \sqrt\mu$</p>
@@poisson@@
<p class="nb">Adjust $\mu$ first whenever the question's interval differs from the given rate. "More than $k$" → $1 - P(X \le k)$.</p>
</div>
<div class="card"><h3>Discrete vs continuous <span class="ls">6.5</span></h3>
@@disc_cont@@
<p class="nb"><b>Discrete</b> (ch. 6): binomial, geometric, Poisson — probabilities sit on single values. <b>Continuous</b> (ch. 7–8): uniform, exponential, normal — probability is <b>area</b>. Rounding turns continuous data into discrete data.</p>
</div>
</div>

<!-- ======================================================= 7 -->
<h2 class="ch"><span class="num">7</span>Continuous distributions</h2>
<div class="cols">
<div class="card"><h3>PDF &amp; CDF rules <span class="ls">7.1 · 7.2</span></h3>
<table class="ft">
<tr><td class="k">PDF $f(x)$</td><td>$f(x) \ge 0$, total area $= 1$, probability $=$ area</td></tr>
<tr><td class="k">one value</td><td>$P(X = a) = 0 \;\Rightarrow\; P(X \lt a) = P(X \le a)$</td></tr>
<tr><td class="k">CDF $F(x)$</td><td>$F(x) = P(X \le x)$ = area to the left</td></tr>
<tr><td class="k">right · between</td><td>$P(X \gt x) = 1 - F(x), \qquad P(a \lt X \lt b) = F(b) - F(a)$</td></tr></table>
@@pdf_cdf@@
</div>
<div class="card"><h3>Uniform $U(a, b)$ <span class="ls">7.3</span></h3>
<table class="ft">
<tr><td class="k">PDF · CDF</td><td>$f(x) = \dfrac{1}{b - a}, \qquad F(x) = \dfrac{x - a}{b - a}$</td></tr>
<tr><td class="k">probability</td><td>$P = \text{base} \times \text{height} = \dfrac{\text{interval width}}{b - a}$</td></tr>
<tr><td class="k">mean = median</td><td>$\mu = \dfrac{a + b}{2}$</td></tr>
<tr><td class="k">spread</td><td>$\sigma^2 = \dfrac{(b-a)^2}{12}, \qquad \sigma = \dfrac{b-a}{\sqrt{12}}$</td></tr>
<tr><td class="k">$k$-th percentile</td><td>$K = a + \dfrac{k}{100}(b - a)$ &nbsp; (outside $[a, b]$ the probability is 0)</td></tr></table>
@@uniform@@
</div>
<div class="card"><h3>Exponential — waiting times &amp; lifetimes <span class="ls">7.4</span></h3>
<table class="ft">
<tr><td class="k">rate · PDF</td><td>$\lambda = \dfrac1\mu, \qquad f(x) = \lambda e^{-\lambda x}\;\;(x \ge 0), \qquad \sigma = \mu$</td></tr>
<tr><td class="k">left · right</td><td>$P(X \lt x) = 1 - e^{-\lambda x}, \qquad P(X \gt x) = e^{-\lambda x}$</td></tr>
<tr><td class="k">between</td><td>$P(a \lt X \lt b) = e^{-\lambda a} - e^{-\lambda b}$</td></tr></table>
@@expon@@
</div>
</div>

<!-- ======================================================= 8 -->
<h2 class="ch"><span class="num">8</span>Normal distribution, CLT and standard error</h2>
<div class="cols">
<div class="card"><h3>z-scores &amp; normal probabilities <span class="ls">8.1 · 8.2</span></h3>
<p class="f">$z = \dfrac{x - \mu}{\sigma}, \qquad x = \mu + z\sigma, \qquad f(x) = \dfrac{1}{\sigma\sqrt{2\pi}}\, e^{-\frac12\left(\frac{x-\mu}{\sigma}\right)^2}$</p>
@@zscore@@
<p class="nb">z-table = <b>left</b> area. Right = 1 − left; between = difference of two lefts. Percentile: area → $z$ → $x$. Count = probability × group size.</p>
</div>
<div class="card"><h3>Empirical rule (68 – 95 – 99.7) <span class="ls">8.1 · 8.2</span></h3>
@@empirical@@
<p class="nb">Normal data only. Precise values: 68.27 / 95.45 / 99.73 %, per region 34.13 / 13.59 / 2.14 / 0.135 %. For any shape use Chebyshev (9.6).</p>
</div>
<div class="card"><h3>Sampling distributions: LLN, CLT, standard error <span class="ls">8.3 · 8.4 · 8.5</span></h3>
<table class="ft"><tr><th>question about…</th><th>distribution</th><th>z</th></tr>
<tr><td class="k">one value $x$</td><td>$X \sim N(\mu, \sigma)$</td><td>$\dfrac{x - \mu}{\sigma}$</td></tr>
<tr><td class="k">mean of $n$ values</td><td>$\bar X \sim N\!\left(\mu, \frac{\sigma}{\sqrt n}\right)$</td><td>$\dfrac{\bar x - \mu}{\sigma/\sqrt n}$</td></tr>
<tr><td class="k">sum of $n$ values</td><td>$\sum X \sim N(n\mu, \sqrt n\,\sigma)$</td><td>$\dfrac{\sum x - n\mu}{\sqrt n\,\sigma}$</td></tr>
<tr><td class="k">standard error</td><td>$\sigma_{\bar x} = \dfrac{\sigma}{\sqrt n}$ (population $\sigma$)</td><td>$\text{SE} = \dfrac{s}{\sqrt n}$ (sample $s$)</td></tr></table>
@@clt@@
@@lln@@
<p class="nb">SD = spread of <b>individual values</b>; SE = spread of <b>sample means</b>. SE ∝ $1/\sqrt n$. The LLN says nothing about a single trial — the next flip is still 50/50.</p>
</div>
</div>

<!-- ======================================================= 9 -->
<h2 class="ch"><span class="num">9</span>Confidence intervals</h2>
<div class="cols">
<div class="card"><h3>CI for a mean, $\sigma$ known (z) <span class="ls">9.1 · 9.2</span></h3>
<p class="f">$\bar x - z\dfrac{\sigma}{\sqrt n} \lt \mu \lt \bar x + z\dfrac{\sigma}{\sqrt n}, \qquad \text{EBM} = z\dfrac{\sigma}{\sqrt n}$<br>look up $z$ from the left area $\dfrac{1 + \text{CL}}{2}$</p>
@@ci_z@@
<table class="ft c"><tr><th>CL</th><th>90%</th><th>95%</th><th>98%</th><th>99%</th></tr>
<tr><td class="k">left area</td><td>0.95</td><td>0.975</td><td>0.99</td><td>0.995</td></tr>
<tr><td class="k">$z$</td><td><b>1.645</b></td><td><b>1.96</b></td><td><b>2.33</b></td><td><b>2.575</b></td></tr></table>
<p class="nb">Higher confidence → bigger $z$ → <b>wider</b>. Bigger $n$ → <b>narrower</b>. $\alpha = 1 - \text{CL}$, split $\alpha/2$ per tail.</p>
</div>
<div class="card"><h3>CI for a mean, $\sigma$ unknown (t) <span class="ls">9.3</span></h3>
<p class="f">$\bar x \pm t_{\nu,\,\alpha/2}\,\dfrac{s}{\sqrt n}, \qquad \nu = n - 1, \qquad \dfrac{\alpha}{2} = \dfrac{1 - \text{CL}}{2}$</p>
@@t@@
<p class="nb">Use $t$ when only $s$ is known, especially $n \lt 30$. t-table: row $\nu$, column = one-tail area $\alpha/2$. As $\nu$ grows, $t \to z$.</p>
</div>
<div class="card"><h3>CI for a proportion <span class="ls">9.4</span></h3>
<table class="ft">
<tr><td class="k">estimate</td><td>$\hat p = \dfrac{x}{n}, \;\; \hat q = 1 - \hat p$</td><td class="k">check</td><td>$n\hat p\hat q \ge 10$</td></tr>
<tr><td class="k">margin of error</td><td>$E = z\sqrt{\dfrac{\hat p\,\hat q}{n}}$</td><td class="k">interval</td><td>$\hat p - E \lt p \lt \hat p + E$</td></tr></table>
@@prop_ci@@
<p class="nb">Given an interval: $\hat p$ = its <b>midpoint</b>, $E$ = <b>half its width</b>. The square-root part is the standard error of $\hat p$.</p>
</div>
<div class="card"><h3>Sample size <span class="ls">9.4 · 9.5</span></h3>
<p class="f">mean: $n = \dfrac{z^2\sigma^2}{E^2}$ &emsp;&emsp; proportion: $n = \dfrac{z^2\,\hat p\,(1 - \hat p)}{E^2}$</p>
@@samplesize@@
<p class="nb">Both come from solving $E = z \times \text{SE}$ for $n$. No estimate of $\hat p$? Use <b>0.5</b> (largest $n$). Always round <b>up</b>. Higher confidence or smaller $E$ → larger $n$; $E$ is squared, so it matters most.</p>
</div>
<div class="card"><h3>Chebyshev's theorem <span class="ls">9.6</span></h3>
<p class="f">at least $\;1 - \dfrac{1}{k^2}\;$ of <b>any</b> data set lies within $k$ SDs of the mean</p>
<p class="f">$k = \dfrac{x - \mu}{\sigma}, \qquad k \gt 1$</p>
@@cheb@@
<p class="nb">Answers are <b>lower bounds</b> — say "at least". $k = 2$ → 75%, $k = 3$ → 88.9%. Use the empirical rule only when the data are normal.</p>
</div>
</div>

<!-- ======================================================= 10 -->
<h2 class="ch"><span class="num">10</span>Hypothesis testing — one sample</h2>
<div class="cols">
<div class="card"><h3>Hypotheses &amp; tails <span class="ls">10.1 · 10.3</span></h3>
<table class="ft c"><tr><th>wording</th><th><span class="b">H₀</span> (equality)</th><th><span class="o">Hₐ</span> (strict)</th><th>test</th></tr>
<tr><td class="k">"is different from", "is not"</td><td>$=$</td><td>$\ne$</td><td>two-tailed</td></tr>
<tr><td class="k">"at least", "no less than"</td><td>$\ge$</td><td>$\lt$</td><td>left-tailed</td></tr>
<tr><td class="k">"at most", "no more than"</td><td>$\le$</td><td>$\gt$</td><td>right-tailed</td></tr></table>
@@tails@@
<p class="nb">Hypotheses are about <b>parameters</b> ($\mu$, $p$), never $\bar x$ or $\hat p$. Only two decisions: reject H₀, or fail to reject H₀ (never "accept"). $\alpha = 1 - c$.</p>
</div>
<div class="card"><h3>Type I &amp; Type II errors, power <span class="ls">10.2</span></h3>
<table class="ft c"><tr><th>decision ↓ &nbsp; truth →</th><th>H₀ true</th><th>H₀ false</th></tr>
<tr><td class="k">reject H₀</td><td class="r"><b>Type I</b> (false alarm) · $\alpha$</td><td class="g">correct · power $= 1 - \beta$</td></tr>
<tr><td class="k">fail to reject H₀</td><td class="g">correct · $1 - \alpha$</td><td class="o"><b>Type II</b> (missed) · $\beta$</td></tr></table>
@@errors@@
<p class="nb">Type I = false positive, Type II = false negative. Which one is worse depends on the real-world consequences.</p>
</div>
<div class="card"><h3>One-sample test statistics <span class="ls">10.4 · 10.5 · 10.7</span></h3>
<p class="f">$\text{test statistic} = \dfrac{\text{sample value} - \text{value claimed by H}_0}{\text{standard error}}$</p>
<table class="ft">
<tr><td class="k">mean, $\sigma$ known or $n \ge 30$</td><td>$z = \dfrac{\bar x - \mu_0}{\sigma/\sqrt n}$ &nbsp; (use $s$ if $\sigma$ unknown)</td></tr>
<tr><td class="k">mean, $\sigma$ unknown, $n \lt 30$</td><td>$t = \dfrac{\bar x - \mu_0}{s/\sqrt n}$, &nbsp; df $= n - 1$</td></tr>
<tr><td class="k">proportion</td><td>$z = \dfrac{\hat p - p_0}{\sqrt{p_0 q_0 / n}}$ &nbsp; ($p_0$ from H₀ in the SE)</td></tr></table>
@@decision@@
<table class="ft c"><tr><th>$\alpha$</th><th>0.10</th><th>0.05</th><th>0.01</th></tr>
<tr><td class="k">two-tailed $z$</td><td>±1.645</td><td>±1.96</td><td>±2.576</td></tr>
<tr><td class="k">one-tailed $z$</td><td>1.28</td><td>1.645</td><td>2.33</td></tr></table>
</div>
<div class="card"><h3>p-value method <span class="ls">10.6</span></h3>
@@pvalue@@
<p class="nb">p-value = probability, <b>if H₀ is true</b>, of a result at least as extreme as the one observed. <b>p &lt; α → reject H₀</b>; p ≥ α → fail to reject. Always gives the same decision as the critical-value method.</p>
<p class="nb"><b>Every test, 5 steps:</b> ① write H₀/Hₐ → ② pick α, tails, critical value → ③ compute the statistic → ④ compare (or p-value vs α) → ⑤ conclude in words.</p>
</div>
</div>

<!-- ======================================================= 11 -->
<h2 class="ch"><span class="num">11</span>Hypothesis testing — two samples</h2>
<div class="cols">
<div class="card"><h3>Difference of two means (independent) <span class="ls">11.1</span></h3>
<p class="f">$t\ (\text{or } z) = \dfrac{(\bar x_1 - \bar x_2) - (\mu_1 - \mu_2)}{\sqrt{\dfrac{s_1^2}{n_1} + \dfrac{s_2^2}{n_2}}}$ &emsp; Welch: $\text{df} = \dfrac{\left(\frac{s_1^2}{n_1} + \frac{s_2^2}{n_2}\right)^2}{\frac{(s_1^2/n_1)^2}{n_1 - 1} + \frac{(s_2^2/n_2)^2}{n_2 - 1}}$</p>
@@se_triangle@@
<p class="nb">H₀: $\mu_1 = \mu_2$ (difference 0). Small samples → $t$ with Welch df; large → $z$. $SE_{\text{diff}} = \sqrt{SE_1^2 + SE_2^2}$: two sources of chance, so bigger than either.</p>
</div>
<div class="card"><h3>Cohen's d — effect size <span class="ls">11.2</span></h3>
<p class="f">$d = \dfrac{|\bar x_1 - \bar x_2|}{s_p}, \qquad s_p = \sqrt{\dfrac{(n_1 - 1)s_1^2 + (n_2 - 1)s_2^2}{n_1 + n_2 - 2}}$</p>
@@cohen@@
<p class="nb">Equal sample sizes: $s_p = \sqrt{(s_1^2 + s_2^2)/2}$. The test asks <b>whether</b> there is a difference (÷ SE, shrinks with $n$); $d$ asks <b>how big</b> (÷ SD, doesn't). Significant ≠ big.</p>
</div>
<div class="card"><h3>Two proportions <span class="ls">11.3</span></h3>
<p class="f">$\hat p_1 = \dfrac{x_1}{n_1},\;\; \hat p_2 = \dfrac{x_2}{n_2},\;\; \bar p = \dfrac{x_1 + x_2}{n_1 + n_2}, \qquad z = \dfrac{(\hat p_1 - \hat p_2) - 0}{\sqrt{\bar p(1 - \bar p)\left(\frac{1}{n_1} + \frac{1}{n_2}\right)}}$</p>
@@two_prop@@
<p class="nb">Pool because H₀ says the rates are equal without saying what they equal. "Fail to reject" = no significant difference found, not "proven equal".</p>
</div>
<div class="card"><h3>Matched / paired samples <span class="ls">11.4</span></h3>
<p class="f">$\bar x_d = \dfrac{\sum x_d}{n}, \;\; s_d = \sqrt{\dfrac{\sum (x_d - \bar x_d)^2}{n - 1}}, \;\; t = \dfrac{\bar x_d - \mu_d}{s_d/\sqrt n}, \;\; \text{CI: } \bar x_d \pm t\dfrac{s_d}{\sqrt n}$</p>
@@paired@@
<p class="nb">Pairing removes person-to-person variation → smaller SE → real effects easier to detect. Match Hₐ to the claim ("reduces" → $\mu_d \lt 0$ when $d$ = after − before).</p>
</div>
</div>

<!-- ======================================================= 12 -->
<h2 class="ch"><span class="num">12</span>The chi-square distribution</h2>
<div class="cols">
<div class="card"><h3>The chi-square distribution <span class="ls">12.1</span></h3>
<p class="f">$\chi^2_k = Z_1^2 + Z_2^2 + \dots + Z_k^2 \quad (Z_i \text{ independent standard normal})$</p>
<p class="f">$f(x) = \dfrac{x^{k/2 - 1}\,e^{-x/2}}{2^{k/2}\,\Gamma\!\left(\frac{k}{2}\right)}, \quad x > 0 \qquad \mu = k, \quad \sigma^2 = 2k, \quad \sigma = \sqrt{2k}$</p>
<p class="f">df $= 4$: $\;f(x) = \dfrac{x\,e^{-x/2}}{4}, \qquad P(\chi^2 > x) = e^{-x/2}\left(1 + \dfrac{x}{2}\right)$</p>
@@chidist@@
<p class="nb">$k$ = df. $\Gamma(n) = (n - 1)!$ for whole numbers, $\Gamma\!\left(\tfrac12\right) = \sqrt\pi$. Only $x > 0$ because it is a sum of squares, and it averages $k$ when H₀ is true. In practice read areas from the χ² table.</p>
</div>
<div class="card"><h3>Goodness of fit <span class="ls">12.1</span></h3>
<p class="f">$E = n\,p, \qquad \chi^2 = \sum \dfrac{(O - E)^2}{E}, \qquad \text{df} = k - 1 \;\;(k = \text{categories})$</p>
@@gof@@
<p class="nb">Always <b>right-tailed</b>: large $\chi^2$ → the data don't fit the claimed distribution → reject H₀.</p>
</div>
<div class="card"><h3>Test of one variance / SD <span class="ls">12.2</span></h3>
<p class="f">$\chi^2 = \dfrac{(n - 1)\,s^2}{\sigma_0^2}, \qquad \text{df} = n - 1$</p>
@@chisq@@
<p class="nb">If H₀ is true, $s^2/\sigma_0^2 \approx 1$ so $\chi^2 \approx$ df. Tables list <b>right-tail</b> areas: for a left-tailed test look up $1 - \alpha$ and reject only if $\chi^2$ is <b>below</b> it.</p>
</div>
<div class="card"><h3>Test of independence (contingency table) <span class="ls">12.3</span></h3>
<p class="f">$E = \dfrac{\text{row total} \times \text{column total}}{\text{grand total}}, \qquad \chi^2 = \displaystyle\sum_{\text{all cells}} \dfrac{(O - E)^2}{E}$</p>
<p class="f">$\text{df} = (r - 1)(c - 1)$, &nbsp; $r$ = rows, $c$ = columns (totals not counted)</p>
@@indep@@
<p class="nb">Under independence every row has the same split as the whole table. Large $\chi^2$ → reject independence → the variables are related.</p>
</div>
</div>

<!-- ======================================================= 13 -->
<h2 class="ch"><span class="num">13</span>Regression and correlation</h2>
<div class="cols">
<div class="card"><h3>Least-squares line <span class="ls">13.1</span></h3>
<p class="f">$\hat y = mx + b, \qquad m = \dfrac{n\sum xy - \sum x \sum y}{n\sum x^2 - \left(\sum x\right)^2}, \qquad b = \dfrac{\sum y - m\sum x}{n}$</p>
@@lsq@@
<p class="nb">Table columns $x, y, xy, x^2$ (and $y^2$ for $r$). Don't round $m$ before computing $b$. Excel: <code>SLOPE</code>, <code>INTERCEPT</code>.</p>
</div>
<div class="card"><h3>Covariance <span class="ls">13.3</span></h3>
<p class="f">$\text{cov}(x, y) = \dfrac{\sum (x - \bar x)(y - \bar y)}{n - 1}$ &emsp; (population: ÷ $N$)</p>
@@cov@@
<p class="nb">The <b>sign</b> gives the direction; the size depends on the units. Each deviation column sums to 0 — a handy check.</p>
</div>
<div class="card"><h3>Correlation coefficient $r$ <span class="ls">13.2 · 13.4</span></h3>
<p class="f">$r = \dfrac{\text{cov}(x, y)}{s_x\,s_y} = \dfrac{n\sum xy - \sum x\sum y}{\sqrt{\left[n\sum x^2 - (\sum x)^2\right]\left[n\sum y^2 - (\sum y)^2\right]}}$</p>
@@corr@@
<p class="nb">$-1 \le r \le 1$. Sign = direction, size = strength of the <b>linear</b> link. $r \approx 0$ can still hide a curved relation. Example data: $r = 8.5 / (2.55 \times 3.39) \approx 0.983$. Correlation is not causation.</p>
</div>
</div>

<!-- ======================================================= summary -->
<h2 class="ch"><span class="num">★</span>Which formula do I need?</h2>
<div class="full"><h3>Estimating (confidence intervals) and testing (hypothesis tests)</h3>
<table class="ft">
<tr><th>situation</th><th>confidence interval</th><th>test statistic</th><th>distribution / df</th><th>lesson</th></tr>
<tr><td class="k">one mean, $\sigma$ known (or $n \ge 30$)</td><td>$\bar x \pm z\dfrac{\sigma}{\sqrt n}$</td><td>$z = \dfrac{\bar x - \mu_0}{\sigma/\sqrt n}$</td><td>normal</td><td>9.1 · 10.4</td></tr>
<tr><td class="k">one mean, $\sigma$ unknown, $n \lt 30$</td><td>$\bar x \pm t\dfrac{s}{\sqrt n}$</td><td>$t = \dfrac{\bar x - \mu_0}{s/\sqrt n}$</td><td>$t$, df $= n - 1$</td><td>9.3 · 10.5</td></tr>
<tr><td class="k">one proportion</td><td>$\hat p \pm z\sqrt{\dfrac{\hat p\hat q}{n}}$</td><td>$z = \dfrac{\hat p - p_0}{\sqrt{p_0q_0/n}}$</td><td>normal ($n\hat p\hat q \ge 10$)</td><td>9.4 · 10.7</td></tr>
<tr><td class="k">two independent means</td><td>$(\bar x_1 - \bar x_2) \pm t\sqrt{\frac{s_1^2}{n_1} + \frac{s_2^2}{n_2}}$</td><td>$\dfrac{\bar x_1 - \bar x_2}{\sqrt{s_1^2/n_1 + s_2^2/n_2}}$</td><td>$t$ (Welch df) or $z$</td><td>11.1</td></tr>
<tr><td class="k">two proportions</td><td>—</td><td>$\dfrac{\hat p_1 - \hat p_2}{\sqrt{\bar p(1-\bar p)(\frac1{n_1} + \frac1{n_2})}}$</td><td>normal, pooled $\bar p$</td><td>11.3</td></tr>
<tr><td class="k">paired (before / after)</td><td>$\bar x_d \pm t\dfrac{s_d}{\sqrt n}$</td><td>$t = \dfrac{\bar x_d - \mu_d}{s_d/\sqrt n}$</td><td>$t$, df $= n_{\text{pairs}} - 1$</td><td>11.4</td></tr>
<tr><td class="k">one variance or SD</td><td>—</td><td>$\chi^2 = \dfrac{(n-1)s^2}{\sigma_0^2}$</td><td>$\chi^2$, df $= n - 1$</td><td>12.2</td></tr>
<tr><td class="k">counts vs a claimed split</td><td>—</td><td>$\chi^2 = \sum\dfrac{(O-E)^2}{E}$, $E = np$</td><td>$\chi^2$, df $= k - 1$, right tail</td><td>12.1</td></tr>
<tr><td class="k">two categorical variables</td><td>—</td><td>$\chi^2$ with $E = \dfrac{\text{row}\times\text{col}}{\text{grand}}$</td><td>$\chi^2$, df $= (r-1)(c-1)$</td><td>12.3</td></tr>
<tr><td class="k">how big is a difference?</td><td colspan="3">Cohen's $d = |\bar x_1 - \bar x_2| / s_p$ &nbsp;— 0.2 small · 0.5 medium · 0.8 large</td><td>11.2</td></tr>
<tr><td class="k">planning a study</td><td colspan="3">$n = z^2\sigma^2/E^2$ (mean) &nbsp;·&nbsp; $n = z^2\hat p(1-\hat p)/E^2$ (proportion, $\hat p = 0.5$ if unknown) — round up</td><td>9.5</td></tr></table>
</div>
BODY

# Keep each card title (which may contain maths) in one flex item, apart from its lesson numbers.
$BODY =~ s{<h3>(.*?) <span class="ls">}{<h3><span class="tt">$1</span> <span class="ls">}g;
# Insert the sketches.
my %used;
$BODY =~ s{\@\@(\w+)\@\@}{ my $f = __PACKAGE__->can("ill_$1") or die "no sketch ill_$1\n"; $used{$1}++; $f->() }ge;

my $MARKERS = '<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>'
  . join('', map { my ($id, $c) = @$_; qq{<marker id="$id" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="$c"/></marker>} }
         (['ah', $C{ink}], ['ahb', $C{blue}], ['aho', $C{orange}], ['ahg', $C{green}], ['ahm', $C{muted}]))
  . '</defs></svg>';

my $HTML = <<'HEAD' . "<style>\n$CSS</style>\n</head>\n<body>\n$MARKERS\n<div class=\"wrap\">\n$BODY\n</div>\n</body>\n</html>\n";
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Statistics Formula Sheet</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/katex.min.css">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/katex.min.js"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.11/dist/contrib/auto-render.min.js"
  onload="renderMathInElement(document.body, {delimiters: [{left: '$$', right: '$$', display: true}, {left: '$', right: '$', display: false}], ignoredClasses: ['ill'], throwOnError: false, strict: false})"></script>
HEAD

my $html_file = "$OUT/formula_sheet.html";
open my $fh, '>:utf8', $html_file or die "$html_file: $!"; print $fh $HTML; close $fh;
printf "wrote %s (%d sketches, %d KB)\n", $html_file, scalar(keys %used), (-s $html_file) / 1024;

# ---------------------------------------------------------------- print to PDF
sub winpath { my $p = shift; $p =~ s{^/([a-zA-Z])/}{\U$1\E:/}; $p =~ s{^/cygdrive/([a-zA-Z])/}{\U$1\E:/}; $p }
sub fileurl { my $p = winpath(shift); $p =~ s/ /%20/g; "file:///$p" }
if (-x $CHROME) {
  mkdir $WORK;
  my $pdf = "$OUT/formula_sheet.pdf"; unlink $pdf;
  my @cmd = ($CHROME, '--headless=new', '--disable-gpu', '--no-pdf-header-footer', '--generate-pdf-document-outline',
    '--virtual-time-budget=20000', '--run-all-compositor-stages-before-draw',
    '--user-data-dir=' . winpath("$WORK/chrome-profile"), '--print-to-pdf=' . winpath($pdf), fileurl($html_file));
  system(@cmd) == 0 or warn "chrome failed\n";
  printf "wrote %s (%s)\n", $pdf, -s $pdf ? sprintf('%d KB', (-s $pdf) / 1024) : 'MISSING';
} else {
  warn "Chrome not found at $CHROME (set CHROME to its path) - skipped the PDF\n";
}
