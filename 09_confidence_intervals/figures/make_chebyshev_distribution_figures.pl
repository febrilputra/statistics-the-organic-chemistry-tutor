#!/usr/bin/perl
# Draws the Lesson 9.6 figures that test Chebyshev's bound on well-known distributions,
# as hand-built SVGs in the chapter's figure style, then renders each to a 2x PNG with
# headless Google Chrome:
#   chebyshev_distributions  six shapes, all rescaled to mean 0 and SD 1, with the share inside +/-2 SD
#   chebyshev_coverage_by_k  share within k SDs against k for the same six, above the 1 - 1/k^2 floor
# Every distribution is scaled so that sigma = 1, so the x axis reads directly in SDs from the mean.
# Usage: perl make_chebyshev_distribution_figures.pl   (outputs are written beside this script)
# Set CHROME to the chrome.exe path if Chrome is not in the default location.
use strict; use warnings; use utf8;
use POSIX qw(erf);
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);
binmode STDOUT, ':encoding(UTF-8)';

my $OUT = dirname(abs_path(__FILE__));
my $CHROME = $ENV{CHROME} // 'C:/Program Files/Google/Chrome/Application/chrome.exe';
my @made;
my ($BLUE, $ORANGE, $GREEN, $INK, $MUTED, $MID, $TAIL, $TAILTXT, $GRID) =
   ('#0072B2', '#D55E00', '#009E73', '#222222', '#555555', '#BFD3E6', '#E8B4B4', '#C0392B', '#E6E6E6');
my $PI = 3.14159265358979;

sub f1 { sprintf '%.1f', $_[0] }
sub esc { my $s=shift; $s=~s{&}{&amp;}g; $s=~s{<}{&lt;}g; $s=~s{>}{&gt;}g; $s }
sub text { my ($x,$y,$s,%o)=@_; $s=esc($s); my $size=$o{size}//13; my $fill=$o{fill}//$INK; my $anc=$o{anchor}//'middle';
  my $w=$o{bold}?' font-weight="bold"':''; my $st=$o{italic}?' font-style="italic"':'';
  return '<text x="'.f1($x).'" y="'.f1($y).qq{" font-size="$size" fill="$fill" text-anchor="$anc"$w$st>$s</text>\n}; }
sub vtext { my ($x,$y,$s,%o)=@_; $s=esc($s); my $size=$o{size}//13; my $fill=$o{fill}//$MUTED;
  return '<text x="0" y="0" transform="translate('.f1($x).','.f1($y).qq{) rotate(-90)" font-size="$size" fill="$fill" text-anchor="middle">$s</text>\n}; }
sub line { my ($x1,$y1,$x2,$y2,$c,$w,$extra)=@_; $extra//='';
  return '<line x1="'.f1($x1).'" y1="'.f1($y1).'" x2="'.f1($x2).'" y2="'.f1($y2).qq{" stroke="$c" stroke-width="$w" fill="none"$extra/>\n}; }
sub dashed { line(@_[0..5], ' stroke-dasharray="5 4"') }
sub rect { my ($x,$y,$w,$h,%o)=@_; my $fill=$o{fill}//'none'; my $st=$o{stroke}?qq{ stroke="$o{stroke}" stroke-width="}.($o{sw}//1).'"':'';
  my $rx=$o{rx}?qq{ rx="$o{rx}"}:''; return '<rect x="'.f1($x).'" y="'.f1($y).'" width="'.f1($w).'" height="'.f1($h).qq{" fill="$fill"$st$rx/>\n}; }
sub circle { my ($x,$y,$r,$c,%o)=@_; my $st=$o{stroke}?qq{ stroke="$o{stroke}" stroke-width="}.($o{sw}//2).'"':' stroke="none"';
  return '<circle cx="'.f1($x).'" cy="'.f1($y).qq{" r="$r"$st fill="$c"/>\n}; }
sub polyline { my ($pts,$c,$w,$extra)=@_; $extra//='';
  return '<polyline points="'.join(' ',map{ f1($_->[0]).','.f1($_->[1]) }@$pts).qq{" stroke="$c" stroke-width="$w" fill="none" stroke-linejoin="round"$extra/>\n}; }
sub polygon { my ($pts,$fill)=@_;
  return '<polygon points="'.join(' ',map{ f1($_->[0]).','.f1($_->[1]) }@$pts).qq{" fill="$fill" stroke="none"/>\n}; }
sub svg { my ($w,$h,$body)=@_;
  return qq{<svg xmlns="http://www.w3.org/2000/svg" width="$w" height="$h" viewBox="0 0 $w $h" font-family="Helvetica, Arial, sans-serif">\n}
   .qq{<rect width="100%" height="100%" fill="#ffffff"/>\n}.$body."</svg>\n"; }
sub save { my ($name,$s)=@_; open my $fh,'>:encoding(UTF-8)',"$OUT/$name" or die $!; print $fh $s; close $fh; print "wrote $name\n";
  my ($w,$h) = $s =~ /<svg[^>]* width="(\d+)" height="(\d+)"/; push @made, [$name,$w,$h]; }

sub phi { exp(-$_[0]**2/2)/sqrt(2*$PI) }
sub Phi { 0.5*(1+erf($_[0]/sqrt(2))) }

# ---------- The distributions, each rescaled to mean 0 and SD 1 ----------
# density: f(z); cover: P(|Z| < k) for k >= 1.
my ($BA, $BS) = (0.9, sqrt(1 - 0.81));          # bimodal: two bells at +/-0.9 with SD 0.436 (total SD 1)
my $R3 = sqrt(3);                                # uniform on [-sqrt3, sqrt3] has SD 1
my @dist = (
  { name=>'Normal', tag=>'bell-shaped', col=>$BLUE,
    pdf=>sub{ phi($_[0]) }, cover=>sub{ 2*Phi($_[0])-1 } },
  { name=>'Uniform', tag=>'flat, no tails at all', col=>$GREEN,
    pdf=>sub{ abs($_[0])<=$R3 ? 1/(2*$R3) : 0 }, cover=>sub{ my $c=$_[0]/$R3; $c>1?1:$c } },
  { name=>'Bimodal', tag=>'two humps', col=>'#CC79A7',
    pdf=>sub{ my $z=shift; 0.5*(phi(($z-$BA)/$BS)+phi(($z+$BA)/$BS))/$BS },
    cover=>sub{ my $k=shift; 0.5*(Phi(($k-$BA)/$BS)-Phi((-$k-$BA)/$BS)) + 0.5*(Phi(($k+$BA)/$BS)-Phi((-$k+$BA)/$BS)) } },
  { name=>'Exponential', tag=>'skewed right', col=>'#E69F00',       # rate 1: mean 1, SD 1, so z = x - 1 >= -1
    pdf=>sub{ $_[0]>=-1 ? exp(-($_[0]+1)) : 0 }, cover=>sub{ my $k=shift; 1-exp(-(1+$k)) - ($k<1 ? 1-exp(-(1-$k)) : 0) } },
  { name=>'Student t, 3 df', tag=>'heavy tails', col=>'#56B4E9',   # T/sqrt(3) has SD 1 and density 2/(pi(1+z^2)^2)
    pdf=>sub{ 2/($PI*(1+$_[0]**2)**2) }, cover=>sub{ my $k=shift; 2*(0.5+($k/(1+$k*$k)+atan2($k,1))/$PI)-1 } },
  { name=>'Worst case', tag=>'1/8 at −2σ, 3/4 at μ, 1/8 at +2σ', col=>$MUTED, discrete=>1,
    cover=>sub{ $_[0]>2 ? 1 : 0.75 } },
);
printf "%-16s  within 1.5 SD  within 2 SD  within 3 SD\n", '';
printf "%-16s  %11.4f  %11.4f  %11.4f\n", $_->{name}, $_->{cover}->(1.5), $_->{cover}->(2), $_->{cover}->(3) for @dist;
printf "%-16s  %11.4f  %11.4f  %11.4f\n", 'Chebyshev', map{ 1-1/$_**2 } 1.5, 2, 3;

# ---------- Figure 1: six shapes, the share inside +/-2 SD ----------
{
  my ($W,$H)=(1000,700); my $b='';
  $b.=text(500,32,'Chebyshev at k = 2 on six different shapes',size=>20,bold=>1);
  $b.=text(500,54,'Each distribution is rescaled to mean μ and SD σ. Chebyshev promises at least 1 − 1/2² = 75% inside μ ± 2σ, whatever the shape.',fill=>$MUTED);
  my $pw=260; my $ph=135;
  for my $i (0..$#dist) {
    my $d=$dist[$i]; my $x0=70+($i%3)*320; my $top=110+int($i/3)*300; my $base=$top+30+$ph;
    my $X=sub{ $x0+($_[0]+4)/8*$pw };
    $b.=text($x0+$pw/2,$top,$d->{name},size=>16,bold=>1).text($x0+$pw/2,$top+18,$d->{tag},fill=>$MUTED,size=>12);
    $b.=rect($X->(-2),$top+30,$X->(2)-$X->(-2),$ph,fill=>'#F4F8FB');
    if ($d->{discrete}) {
      my $sc=$ph*0.9/0.75;
      for my $pt ([-2,0.125,'1/8'],[0,0.75,'3/4'],[2,0.125,'1/8']) { my ($z,$pr,$lab)=@$pt; my $c=$z==0?$BLUE:$TAILTXT;
        $b.=line($X->($z),$base,$X->($z),$base-$pr*$sc,$c,3).circle($X->($z),$base-$pr*$sc,5,$c);
        $b.=text($X->($z)+($z==0?0:($z<0?-14:14)),$base-$pr*$sc-10,$lab,fill=>$c,bold=>1,size=>12); }
    } else {
      my @z=map{ -4+$_*0.002 } 0..4000; my $mx=0; for (@z) { my $v=$d->{pdf}->($_); $mx=$v if $v>$mx }
      my $sc=$ph*0.9/$mx; my $Yd=sub{ $base-$d->{pdf}->($_[0])*$sc };
      my $region=sub{ my ($a,$c,$fill)=@_; my @p=([$X->($a),$base]); push @p,map{[$X->($_),$Yd->($_)]} grep{ $_>=$a-1e-9 && $_<=$c+1e-9 } @z; push @p,[$X->($c),$base]; polygon(\@p,$fill) };
      $b.=$region->(-4,-2,$TAIL).$region->(2,4,$TAIL).$region->(-2,2,$MID);
      $b.=polyline([map{[$X->($_),$Yd->($_)]}@z],$d->{col},2.5);
    }
    $b.=dashed($X->($_),$top+30,$X->($_),$base,$MUTED,1.2) for (-2,2);
    $b.=line($x0,$base,$x0+$pw,$base,$MUTED,1.3);
    for my $t (-4..4) { my $lab=$t==0?'μ':$t>0?"+${t}σ":"−".(-$t)."σ";
      $b.=line($X->($t),$base,$X->($t),$base+4,$MUTED,1.2);
      $b.=text($X->($t),$base+18,$lab,fill=>abs($t)==2?$INK:$MUTED,size=>11,bold=>abs($t)==2) if $t%2==0; }
    # share inside +/-2 SD, as a bar against the 75% floor
    my $cv=$d->{cover}->(2); my $by=$base+40; my $bw=$pw;
    $b.=rect($x0,$by,$bw,12,fill=>'#EEEEEE',rx=>3).rect($x0,$by,$bw*$cv,12,fill=>$d->{col},rx=>3);
    $b.=line($x0+$bw*0.75,$by-5,$x0+$bw*0.75,$by+17,$ORANGE,2.5);
    my $pct = $cv>0.99995 ? '100%' : sprintf('%.1f%%',100*$cv);
    $b.=text($x0,$by+34,($d->{discrete}?"$pct strictly inside ±2σ":"$pct inside ±2σ"),anchor=>'start',bold=>1,size=>14);
    $b.=text($x0+$bw,$by+34,($d->{discrete}?'= the 75% floor':'≥ 75% ✓'),anchor=>'end',fill=>$ORANGE,bold=>1,size=>13);
  }
  $b.=line(370,675,394,675,$ORANGE,2.5).text(400,679,'orange tick = Chebyshev’s 75% floor',anchor=>'start',fill=>$MUTED,size=>12);
  $b.=rect(610,669,24,12,fill=>$MID).text(640,679,'inside ±2σ',anchor=>'start',fill=>$MUTED,size=>12);
  $b.=rect(720,669,24,12,fill=>$TAIL).text(750,679,'outside',anchor=>'start',fill=>$MUTED,size=>12);
  save('chebyshev_distributions.svg',svg($W,$H,$b));
}

# ---------- Figure 2: coverage against k ----------
{
  my ($W,$H)=(1000,450); my $b='';
  $b.=text(500,32,'Every shape stays on or above the Chebyshev floor',size=>20,bold=>1);
  $b.=text(500,54,'Share of the distribution within k SDs of the mean. The orange floor 1 − 1/k² holds for all of them; the worst case touches it at k = 2.',fill=>$MUTED);
  my ($x0,$y0,$w,$h)=(90,85,600,280); my ($ka,$kb)=(1,4);
  my $X=sub{ $x0+($_[0]-$ka)/($kb-$ka)*$w }; my $Y=sub{ $y0+$h-$_[0]*$h };
  for my $t (0,0.25,0.5,0.75,0.889,1) { $b.=line($x0,$Y->($t),$x0+$w,$Y->($t),$GRID,1) if $t>0;
    $b.=line($x0-5,$Y->($t),$x0,$Y->($t),$MUTED,1.2).text($x0-9,$Y->($t)+4,($t==0?'0%':sprintf('%g%%',100*$t)),anchor=>'end',fill=>$MUTED,size=>12); }
  for my $t (1,1.5,2,2.5,3,3.5,4) { $b.=line($X->($t),$y0+$h,$X->($t),$y0+$h+5,$MUTED,1.2).text($X->($t),$y0+$h+20,$t,fill=>$MUTED,size=>12); }
  $b.=line($x0,$y0+$h,$x0+$w,$y0+$h,$MUTED,1.3).line($x0,$y0,$x0,$y0+$h,$MUTED,1.3);
  $b.=text($x0+$w/2,$y0+$h+44,'k (number of SDs from the mean)',fill=>$MUTED).vtext($x0-58,$y0+$h/2,'share within k SDs');
  my @ks=map{ $ka+$_*0.005 } 0..600;
  $b.=polygon([[$X->($ka),$Y->(0)],(map{[$X->($_),$Y->(1-1/$_**2)]}@ks),[$X->($kb),$Y->(0)]],'#FBE3D6');
  for my $d (@dist) {
    if ($d->{discrete}) {
      $b.=line($X->(1),$Y->(0.75),$X->(2),$Y->(0.75),$d->{col},2.5,' stroke-dasharray="6 4"').line($X->(2),$Y->(1),$X->(4),$Y->(1),$d->{col},2.5,' stroke-dasharray="6 4"');
      $b.=circle($X->(2),$Y->(0.75),5.5,$d->{col}).circle($X->(2),$Y->(1),5,'#ffffff',stroke=>$d->{col});
    } else { $b.=polyline([map{[$X->($_),$Y->($d->{cover}->($_))]}@ks],$d->{col},2.5); }
  }
  $b.=polyline([map{[$X->($_),$Y->(1-1/$_**2)]}@ks],$ORANGE,3.5);
  $b.=text($X->(2)+10,$Y->(0.75)+20,'touches the floor at k = 2',anchor=>'start',fill=>$MUTED,size=>12,bold=>1);
  $b.=text($X->(3.05),$Y->(1-1/9)+24,'Chebyshev floor 1 − 1/k²',fill=>$ORANGE,bold=>1,anchor=>'start');
  # legend
  my $ly=105; $b.=text(730,$ly-8,'distribution',anchor=>'start',fill=>$MUTED,size=>12,bold=>1);
  for my $d (@dist) { $ly+=26;
    $b.=($d->{discrete} ? line(730,$ly-4,760,$ly-4,$d->{col},2.5,' stroke-dasharray="6 4"') : line(730,$ly-4,760,$ly-4,$d->{col},3));
    $b.=text(768,$ly,$d->{name}.($d->{discrete}?' (3 points)':''),anchor=>'start'); }
  $ly+=26; $b.=line(730,$ly-4,760,$ly-4,$ORANGE,3.5).text(768,$ly,'Chebyshev floor',anchor=>'start',fill=>$ORANGE,bold=>1);
  save('chebyshev_coverage_by_k.svg',svg($W,$H,$b));
}

# ---------- PNG copies at 2x, as used by the Markdown ----------
sub winpath { my $p = shift; $p =~ s{^/([a-zA-Z])/}{\U$1\E:/}; $p }   # Git Bash /c/... -> C:/...
if (-x $CHROME) {
  my $profile = (($ENV{TEMP} // File::Spec->tmpdir) =~ tr{\\}{/}r) . '/stats-figure-chrome';
  my $dir = winpath($OUT);
  for my $m (@made) {
    my ($name, $w, $h) = @$m; (my $png = $name) =~ s/\.svg$/.png/;
    unlink "$OUT/$png";
    (my $url = "file:///$dir/$name") =~ s/ /%20/g;
    system($CHROME, '--headless=new', '--disable-gpu', '--hide-scrollbars', '--force-device-scale-factor=2',
      "--window-size=$w,$h", "--user-data-dir=$profile", "--screenshot=$dir/$png", $url) == 0 or warn "chrome failed for $name\n";
    print -s "$OUT/$png" ? "wrote $png\n" : "FAILED $png\n";
  }
} else {
  warn "Chrome not found at $CHROME, so only the SVGs were written (set CHROME to render PNGs)\n";
}
