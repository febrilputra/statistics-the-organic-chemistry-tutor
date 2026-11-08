#!/usr/bin/perl
# Draws the Lesson 9.4 figures as hand-built SVGs in the chapter's figure style,
# then renders each one to a 2x PNG with headless Google Chrome:
#   proportion_z_lookup          finding z for 95% (curves + z-table excerpt)
#   proportion_interval_anatomy  the laptop interval, p-hat +/- E
#   proportion_working_backwards the Texas interval, midpoint and half-width
# Usage: perl make_proportion_figures.pl   (outputs are written beside this script)
# Set CHROME to the chrome.exe path if Chrome is not in the default location.
use strict; use warnings; use utf8;
use POSIX qw(erf);
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);

my $OUT = dirname(abs_path(__FILE__));
my $CHROME = $ENV{CHROME} // 'C:/Program Files/Google/Chrome/Application/chrome.exe';
my @made;
my ($BLUE, $ORANGE, $GREEN, $INK, $MUTED, $MID, $TAIL, $TAILTXT, $GRID) =
   ('#0072B2', '#D55E00', '#009E73', '#222222', '#555555', '#BFD3E6', '#E8B4B4', '#C0392B', '#E6E6E6');

sub f1 { sprintf '%.1f', $_[0] }
sub text { my ($x,$y,$s,%o)=@_; $s=~s{&}{&amp;}g; $s=~s{<}{&lt;}g; $s=~s{>}{&gt;}g; my $size=$o{size}//13; my $fill=$o{fill}//$INK; my $anc=$o{anchor}//'middle';
  my $w=$o{bold}?' font-weight="bold"':''; my $st=$o{italic}?' font-style="italic"':'';
  return '<text x="'.f1($x).'" y="'.f1($y).qq{" font-size="$size" fill="$fill" text-anchor="$anc"$w$st>$s</text>\n}; }
sub line { my ($x1,$y1,$x2,$y2,$c,$w,$extra)=@_; $extra//='';
  return '<line x1="'.f1($x1).'" y1="'.f1($y1).'" x2="'.f1($x2).'" y2="'.f1($y2).qq{" stroke="$c" stroke-width="$w" fill="none"$extra/>\n}; }
sub rect { my ($x,$y,$w,$h,%o)=@_; my $fill=$o{fill}//'none'; my $st=$o{stroke}?qq{ stroke="$o{stroke}" stroke-width="}.($o{sw}//1).'"':'';
  my $rx=$o{rx}?qq{ rx="$o{rx}"}:''; return '<rect x="'.f1($x).'" y="'.f1($y).'" width="'.f1($w).'" height="'.f1($h).qq{" fill="$fill"$st$rx/>\n}; }
sub circle { my ($x,$y,$r,$c)=@_; return '<circle cx="'.f1($x).'" cy="'.f1($y).qq{" r="$r" stroke="none" fill="$c"/>\n}; }
# Double-headed arrow along a horizontal line.
sub harrow { my ($x1,$x2,$y,$c)=@_; my $h=7;
  return line($x1,$y,$x2,$y,$c,1.5)
   .'<polygon points="'.join(' ',map{f1($_)}($x1,$y,$x1+$h,$y-4,$x1+$h,$y+4)).qq{" fill="$c"/>\n}
   .'<polygon points="'.join(' ',map{f1($_)}($x2,$y,$x2-$h,$y-4,$x2-$h,$y+4)).qq{" fill="$c"/>\n}; }
sub svg { my ($w,$h,$body)=@_;
  return qq{<svg xmlns="http://www.w3.org/2000/svg" width="$w" height="$h" viewBox="0 0 $w $h" font-family="Helvetica, Arial, sans-serif">\n}
   .qq{<rect width="100%" height="100%" fill="#ffffff"/>\n}.$body."</svg>\n"; }
sub save { my ($name,$s)=@_; open my $fh,'>:encoding(UTF-8)',"$OUT/$name" or die $!; print $fh $s; close $fh; print "wrote $name\n";
  my ($w,$h) = $s =~ /<svg[^>]* width="(\d+)" height="(\d+)"/; push @made, [$name,$w,$h]; }

sub pdf { my $z=shift; exp(-$z*$z/2)/sqrt(2*3.14159265358979) }
sub cdf { my $z=shift; 0.5*(1+erf($z/sqrt(2))) }

# ---------- Figure 1: finding z for 95% ----------
{
  my ($W,$H)=(1000,450); my $b='';
  $b.=text(500,32,'Finding z for a 95% confidence level',size=>20,bold=>1);
  $b.=text(500,54,'Look up the area to the LEFT of +z in the z-table: (1 + CL)/2 = (1 + 0.95)/2 = 0.975.',fill=>$MUTED);

  my $zc=1.96; my $base=330; my $peak=170; my $sc=$peak/pdf(0);
  my $curve = sub { # panel x-origin, width, region-colour callback
    my ($x0,$pw,$colour)=@_; my $out=''; my $X=sub{$x0+($_[0]+3.5)/7*$pw};
    # shaded regions, filled as polygons per segment
    my @seg; my $prev; for(my $i=0;$i<=700;$i++){ my $z=-3.5+$i*0.01; $z=-$zc if abs($z+$zc)<0.005; $z=$zc if abs($z-$zc)<0.005;
      my $c=$colour->($z); if(!defined $prev || $prev ne $c){ push @seg,[$c,[]]; push @{$seg[-1][1]},$seg[-2][1][-1] if @seg>1 } push @{$seg[-1][1]},$z; $prev=$c; }
    for my $s (@seg){ my ($c,$zs)=@$s; my @p=(f1($X->($zs->[0])).','.f1($base));
      push @p, map{ f1($X->($_)).','.f1($base-pdf($_)*$sc) } @$zs; push @p, f1($X->($zs->[-1])).','.f1($base);
      $out.='<polygon points="'.join(' ',@p).qq{" fill="$c" stroke="none"/>\n}; }
    $out.='<polyline points="'.join(' ',map{ my $z=-3.5+$_*0.025; f1($X->($z)).','.f1($base-pdf($z)*$sc) }0..280).qq{" stroke="$BLUE" stroke-width="2.5" fill="none"/>\n};
    $out.=line($x0,$base,$x0+$pw,$base,$MUTED,1.3);
    for my $t (-$zc,0,$zc){ $out.=line($X->($t),$base,$X->($t),$base+5,$MUTED,1); }
    $out.=line($X->($_),$base,$X->($_),$base-pdf($_)*$sc,$MUTED,1) for (-$zc,$zc);
    $out.=text($X->(-$zc),$base+20,'−1.96',size=>12,fill=>$MUTED).text($X->(0),$base+20,'0',size=>12,fill=>$MUTED).text($X->($zc),$base+20,'+1.96',size=>12,fill=>$MUTED);
    return ($out,$X);
  };

  # Panel 1: middle 95%, two tails
  my ($o,$X)=$curve->(40,280,sub{ abs($_[0])<=$zc ? $MID : $TAIL });
  $b.=text(180,110,'1. The middle 95% is between −z and +z',size=>14,bold=>1);
  $b.=$o.text($X->(0),$base-55,'95%',size=>20,bold=>1);
  $b.=text($X->(-2.75),$base-50,'2.5%',size=>13,fill=>$TAILTXT,bold=>1).text($X->(2.75),$base-50,'2.5%',size=>13,fill=>$TAILTXT,bold=>1);
  $b.=text(180,$base+48,'The other 5% is split between the two tails.',size=>12.5,fill=>$MUTED);

  # Panel 2: area to the left of +z
  ($o,$X)=$curve->(360,280,sub{ $_[0]<=$zc ? $MID : $TAIL });
  $b.=text(500,110,'2. The z-table wants the area to the LEFT',size=>14,bold=>1);
  $b.=$o.text($X->(-0.2),$base-55,'0.975',size=>20,bold=>1);
  $b.=text($X->(2.75),$base-50,'0.025',size=>13,fill=>$TAILTXT,bold=>1);
  $b.=text(500,$base+48,'0.025 (left tail) + 0.95 (middle) = 0.975',size=>12.5,fill=>$MUTED);

  # Panel 3: z-table excerpt
  $b.=text(830,110,'3. Find 0.975 inside the table',size=>14,bold=>1);
  my @cols=(0.04,0.05,0.06,0.07,0.08); my @rows=(1.8,1.9,2.0);
  my ($tx,$ty,$cw,$rh)=(690,140,50,34); my $hw=40;
  $b.=rect($tx,$ty,$hw+$cw*@cols,$rh*(@rows+1),fill=>'#ffffff',stroke=>$MUTED,sw=>1);
  $b.=rect($tx+$hw+$cw*2,$ty,$cw,$rh*(@rows+1),fill=>'#FBE3D3');          # column .06
  $b.=rect($tx,$ty+$rh*2,$hw+$cw*@cols,$rh,fill=>'#FBE3D3');              # row 1.9
  $b.=rect($tx+$hw+$cw*2,$ty+$rh*2,$cw,$rh,fill=>'#ffffff',stroke=>$ORANGE,sw=>2.5);
  $b.=line($tx,$ty+$rh,$tx+$hw+$cw*@cols,$ty+$rh,$MUTED,1).line($tx+$hw,$ty,$tx+$hw,$ty+$rh*(@rows+1),$MUTED,1);
  $b.=text($tx+$hw/2,$ty+22,'z',size=>13,bold=>1,italic=>1);
  for my $j (0..$#cols){ $b.=text($tx+$hw+$cw*$j+$cw/2,$ty+22,sprintf('.%02d',$cols[$j]*100),size=>12.5,bold=>1,fill=>$j==2?$ORANGE:$INK); }
  for my $i (0..$#rows){ my $y=$ty+$rh*($i+1)+22;
    $b.=text($tx+$hw/2,$y,sprintf('%.1f',$rows[$i]),size=>12.5,bold=>1,fill=>$i==1?$ORANGE:$INK);
    for my $j (0..$#cols){ my $v=sprintf('%.4f',cdf($rows[$i]+$cols[$j])); $v=~s/^0//;
      $b.=text($tx+$hw+$cw*$j+$cw/2,$y,$v,size=>12.5,fill=>($i==1&&$j==2)?$ORANGE:$MUTED,bold=>($i==1&&$j==2)); } }
  my $by=$ty+$rh*4;
  $b.=text(830,$by+28,'row 1.9  +  column 0.06',size=>13,fill=>$MUTED);
  $b.=text(830,$by+62,'z = 1.96',size=>24,bold=>1,fill=>$ORANGE);

  $b.=text(500,428,'Other levels work the same way: 90% → left area 0.95 → z = 1.645,  99% → left area 0.995 → z = 2.575.',fill=>$MUTED);
  save('proportion_z_lookup.svg',svg($W,$H,$b));
}

# ---------- Figure 2: anatomy of the laptop interval ----------
{
  my ($W,$H)=(1000,360); my $b='';
  my ($ph,$E)=(0.73,0.0308); my ($lo,$hi)=($ph-$E,$ph+$E);
  my ($a0,$a1,$x0,$x1)=(0.68,0.78,110,890); my $X=sub{$x0+($_[0]-$a0)/($a1-$a0)*($x1-$x0)};
  $b.=text(500,32,'Building the laptop confidence interval',size=>20,bold=>1);
  $b.=text(500,54,'Start at p̂ and go out one margin of error E in each direction.',fill=>$MUTED);
  my $y=175;
  $b.=harrow($X->($lo),$X->($ph)-3,118,$MUTED).harrow($X->($ph)+3,$X->($hi),118,$MUTED);
  $b.=text(($X->($lo)+$X->($ph))/2,107,"E = $E",size=>13,bold=>1).text(($X->($ph)+$X->($hi))/2,107,"E = $E",size=>13,bold=>1);
  $b.=line($X->($_),128,$X->($_),$y-14,$GRID,1.3,' stroke-dasharray="4 3"') for ($lo,$ph,$hi);
  $b.=line($X->($lo),$y,$X->($hi),$y,$BLUE,6).line($X->($lo),$y-13,$X->($lo),$y+13,$BLUE,3).line($X->($hi),$y-13,$X->($hi),$y+13,$BLUE,3);
  $b.=circle($X->($ph),$y,8,$ORANGE);
  $b.=text($X->($lo),$y+36,'p̂ − E',size=>14,bold=>1,fill=>$BLUE).text($X->($lo),$y+55,'0.73 − 0.0308 = 0.6992',size=>12.5,fill=>$BLUE);
  $b.=text($X->($ph),$y+36,'p̂',size=>14,bold=>1,fill=>$ORANGE).text($X->($ph),$y+55,'584 / 800 = 0.73',size=>12.5,fill=>$ORANGE);
  $b.=text($X->($hi),$y+36,'p̂ + E',size=>14,bold=>1,fill=>$BLUE).text($X->($hi),$y+55,'0.73 + 0.0308 = 0.7608',size=>12.5,fill=>$BLUE);
  my $ay=268; $b.=line($x0,$ay,$x1,$ay,$MUTED,1.3);
  for my $k (0..10){ my $v=$a0+$k*0.01; my $len=$k%2?3:5; $b.=line($X->($v),$ay,$X->($v),$ay+$len,$MUTED,1);
    $b.=text($X->($v),$ay+19,sprintf('%.2f',$v),size=>12,fill=>$MUTED) unless $k%2; }
  $b.=text(500,$ay+42,'population proportion p  (fraction of ALL students at the university who own a laptop)',fill=>$MUTED);
  $b.=text(500,342,'95% confidence interval: 0.6992 < p < 0.7608, i.e. about 69.9% to 76.1% of all students.',bold=>1);
  save('proportion_interval_anatomy.svg',svg($W,$H,$b));
}

# ---------- Figure 3: working backwards (Texas) ----------
{
  my ($W,$H)=(1000,400); my $b='';
  my ($lo,$hi)=(0.62383,0.67217); my $ph=($lo+$hi)/2; my $E=($hi-$lo)/2;
  my ($a0,$a1,$x0,$x1)=(0.615,0.680,110,890); my $X=sub{$x0+($_[0]-$a0)/($a1-$a0)*($x1-$x0)};
  $b.=text(500,32,'Working backwards from a confidence interval',size=>20,bold=>1);
  $b.=text(500,54,'Every interval is (p̂ − E, p̂ + E), so p̂ is the midpoint and E is half the width.',fill=>$MUTED);
  my $y=180;
  $b.=harrow($X->($lo),$X->($ph)-3,122,$MUTED).harrow($X->($ph)+3,$X->($hi),122,$MUTED);
  $b.=text(($X->($lo)+$X->($ph))/2,111,'E',size=>14,bold=>1).text(($X->($ph)+$X->($hi))/2,111,'E',size=>14,bold=>1);
  $b.=line($X->($_),132,$X->($_),$y-14,$GRID,1.3,' stroke-dasharray="4 3"') for ($lo,$ph,$hi);
  $b.=line($X->($lo),$y,$X->($hi),$y,$GREEN,6).line($X->($lo),$y-13,$X->($lo),$y+13,$GREEN,3).line($X->($hi),$y-13,$X->($hi),$y+13,$GREEN,3);
  $b.=circle($X->($ph),$y,8,$ORANGE);
  $b.=text($X->($lo),$y+36,'lower = 0.62383',size=>13.5,bold=>1,fill=>$GREEN);
  $b.=text($X->($hi),$y+36,'upper = 0.67217',size=>13.5,bold=>1,fill=>$GREEN);
  $b.=text($X->($ph),$y+36,'p̂ = midpoint',size=>13.5,bold=>1,fill=>$ORANGE);
  # full-width bracket
  my $by=$y+62; $b.=line($X->($lo),$by-6,$X->($lo),$by,$MUTED,1.3).line($X->($hi),$by-6,$X->($hi),$by,$MUTED,1.3).line($X->($lo),$by,$X->($hi),$by,$MUTED,1.3);
  $b.=text($X->($ph),$by+19,'full width = 0.67217 − 0.62383 = 0.04834 = 2E',size=>12.5,fill=>$MUTED);
  my $ay=300; $b.=line($x0,$ay,$x1,$ay,$MUTED,1.3);
  for my $k (0..13){ my $v=0.615+$k*0.005; my $major=(abs($v*100-int($v*100+0.5))<1e-9); $b.=line($X->($v),$ay,$X->($v),$ay+($major?5:3),$MUTED,1);
    $b.=text($X->($v),$ay+19,sprintf('%.2f',$v),size=>12,fill=>$MUTED) if $major; }
  $b.=text(500,$ay+42,'population proportion p  (fraction of Texans who own a house)',fill=>$MUTED);
  $b.=text(340,380,sprintf(q{p̂ = (0.62383 + 0.67217) / 2 = %.3f},$ph),size=>14,bold=>1,fill=>$ORANGE).text(700,380,sprintf(q{E = 0.04834 / 2 = %.5f},$E),size=>14,bold=>1);
  save('proportion_working_backwards.svg',svg($W,$H,$b));
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
