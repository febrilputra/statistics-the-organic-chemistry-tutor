#!/usr/bin/perl
# Draws the Lesson 9.5 "logic behind the formulas" figures as hand-built SVGs in the
# chapter's figure style, then renders each one to a 2x PNG with headless Google Chrome:
#   sample_size_wobble      simulated surveys: p-hat scatters around p, n = 100 vs n = 400
#   sample_size_zero_one    yes/no answers coded 0/1, so p(1 - p) is their variance
#   sample_size_drivers     n against confidence level, margin of error and p-hat
#   sample_size_worst_case  p(1 - p) = 0.25 - (p - 0.5)^2, and the real E if p turns out 0.8
# Usage: perl make_sample_size_logic_figures.pl   (outputs are written beside this script)
# Set CHROME to the chrome.exe path if Chrome is not in the default location.
use strict; use warnings; use utf8;
use POSIX qw(erf ceil);
use File::Basename qw(dirname);
use File::Spec;
use Cwd qw(abs_path);

my $OUT = dirname(abs_path(__FILE__));
my $CHROME = $ENV{CHROME} // 'C:/Program Files/Google/Chrome/Application/chrome.exe';
my @made;
my ($BLUE, $ORANGE, $GREEN, $INK, $MUTED, $MID, $TAIL, $TAILTXT, $GRID) =
   ('#0072B2', '#D55E00', '#009E73', '#222222', '#555555', '#BFD3E6', '#E8B4B4', '#C0392B', '#E6E6E6');

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
sub circle { my ($x,$y,$r,$c,$op)=@_; my $o=defined $op?qq{ fill-opacity="$op"}:'';
  return '<circle cx="'.f1($x).'" cy="'.f1($y).qq{" r="$r" stroke="none" fill="$c"$o/>\n}; }
sub polyline { my ($pts,$c,$w)=@_;
  return '<polyline points="'.join(' ',map{ f1($_->[0]).','.f1($_->[1]) }@$pts).qq{" stroke="$c" stroke-width="$w" fill="none" stroke-linejoin="round"/>\n}; }
sub polygon { my ($pts,$fill,$op)=@_; my $o=defined $op?qq{ fill-opacity="$op"}:'';
  return '<polygon points="'.join(' ',map{ f1($_->[0]).','.f1($_->[1]) }@$pts).qq{" fill="$fill" stroke="none"$o/>\n}; }
# Double-headed arrow along a horizontal line.
sub harrow { my ($x1,$x2,$y,$c)=@_; my $h=7;
  return line($x1,$y,$x2,$y,$c,1.5)
   .polygon([[$x1,$y],[$x1+$h,$y-4],[$x1+$h,$y+4]],$c)
   .polygon([[$x2,$y],[$x2-$h,$y-4],[$x2-$h,$y+4]],$c); }
sub svg { my ($w,$h,$body)=@_;
  return qq{<svg xmlns="http://www.w3.org/2000/svg" width="$w" height="$h" viewBox="0 0 $w $h" font-family="Helvetica, Arial, sans-serif">\n}
   .qq{<rect width="100%" height="100%" fill="#ffffff"/>\n}.$body."</svg>\n"; }
sub save { my ($name,$s)=@_; open my $fh,'>:encoding(UTF-8)',"$OUT/$name" or die $!; print $fh $s; close $fh; print "wrote $name\n";
  my ($w,$h) = $s =~ /<svg[^>]* width="(\d+)" height="(\d+)"/; push @made, [$name,$w,$h]; }

sub pdf { my $z=shift; exp(-$z*$z/2)/sqrt(2*3.14159265358979) }
sub cdf { my $z=shift; 0.5*(1+erf($z/sqrt(2))) }
sub zcrit { my $cl=shift; my $target=(1+$cl)/2; my ($lo,$hi)=(0,6);   # z with area (1+CL)/2 to its left
  for (1..60) { my $m=($lo+$hi)/2; if (cdf($m)<$target) { $lo=$m } else { $hi=$m } } return ($lo+$hi)/2; }
sub nsize { my ($z,$p,$E)=@_; $z*$z*$p*(1-$p)/($E*$E) }

# Plot frame: grid, axes, ticks and labels. Returns x/y mapping closures and the SVG.
sub axes { my %a=@_;
  my ($x0,$y0,$w,$h)=@a{qw(x y w h)}; my ($xa,$xb,$ya,$yb)=@a{qw(xmin xmax ymin ymax)};
  my $X=sub{ $x0+($_[0]-$xa)/($xb-$xa)*$w }; my $Y=sub{ $y0+$h-($_[0]-$ya)/($yb-$ya)*$h };
  my ($xf,$yf)=($a{xfmt}//sub{$_[0]}, $a{yfmt}//sub{$_[0]}); my $s='';
  for my $t (@{$a{yticks}||[]}) { $s.=line($x0,$Y->($t),$x0+$w,$Y->($t),$GRID,1) unless $t==$ya;
    $s.=line($x0-5,$Y->($t),$x0,$Y->($t),$MUTED,1.2).text($x0-9,$Y->($t)+4,$yf->($t),anchor=>'end',fill=>$MUTED,size=>12); }
  for my $t (@{$a{xticks}||[]}) { $s.=line($X->($t),$y0+$h,$X->($t),$y0+$h+5,$MUTED,1.2).text($X->($t),$y0+$h+20,$xf->($t),fill=>$MUTED,size=>12); }
  $s.=line($x0,$y0+$h,$x0+$w,$y0+$h,$MUTED,1.3).line($x0,$y0,$x0,$y0+$h,$MUTED,1.3);
  $s.=text($x0+$w/2,$y0+$h+42,$a{xlabel},fill=>$MUTED) if $a{xlabel};
  $s.=vtext($x0-52,$y0+$h/2,$a{ylabel}) if $a{ylabel};
  $s.=text($x0+$w/2,$y0-16,$a{title},size=>15,bold=>1) if $a{title};
  return ($X,$Y,$s); }

# ---------- Figure 1: every sample wobbles; 4x the people halves E ----------
{
  my ($W,$H)=(1000,580); my $b='';
  $b.=text(500,32,'Every sample gives a different p̂',size=>20,bold=>1);
  $b.=text(500,54,'Each dot is one simulated survey with true p = 0.5. The p̂ values pile up in a bell curve; 95% of them land within E = 1.96 × SE of p.',fill=>$MUTED);
  my ($xa,$xb,$L,$R)=(0,1,140,760); my $X=sub{ $L+($_[0]-$xa)/($xb-$xa)*($R-$L) };
  my $axisY=490;
  for (my $t=$xa; $t<=$xb+1e-9; $t+=0.1) { $b.=line($X->($t),84,$X->($t),$axisY,$GRID,1) }
  $b.=dashed($X->(0.5),84,$X->(0.5),$axisY,$MUTED,1.3);
  $b.=text($X->(0.5),78,'true p = 0.5',fill=>$MUTED,bold=>1);
  srand(7);
  for my $row ([100,215,55],[400,425,110]) {          # n, baseline y, peak height (proportional to 1/SE)
    my ($n,$base,$peak)=@$row; my $se=sqrt(0.25/$n); my $E=1.96*$se;
    my $d=sub{ $base-pdf(($_[0]-0.5)/$se)/pdf(0)*$peak };
    my $region=sub{ my ($from,$to)=@_; my @p=([$X->($from),$base]);
      for (my $t=$from; $t<$to; $t+=0.001) { push @p,[$X->($t),$d->($t)] } push @p,[$X->($to),$d->($to)],[$X->($to),$base]; \@p };
    $b.=polygon($region->($xa,0.5-$E),$TAIL).polygon($region->(0.5+$E,$xb),$TAIL).polygon($region->(0.5-$E,0.5+$E),$MID);
    $b.=polyline([map{ my $t=$xa+$_*0.001; [$X->($t),$d->($t)] }0..1000],$BLUE,2.5);
    $b.=line($L,$base,$R,$base,$MUTED,1);
    $b.=dashed($X->($_),$base,$X->($_),$d->($_),$MUTED,1.2) for (0.5-$E,0.5+$E);
    my $ay=$base-$peak-14; $b.=harrow($X->(0.5),$X->(0.5+$E),$ay,$INK);
    $b.=text($X->(0.5+$E)+8,$ay+4,sprintf('E = %.3f',$E),anchor=>'start',bold=>1);
    my $in=0;
    for (1..40) { my $k=0; for (1..$n) { $k++ if rand()<0.5 } my $ph=$k/$n; my $ok=abs($ph-0.5)<=$E+1e-12; $in++ if $ok;
      $b.=circle($X->($ph),$base+14+rand(18),4,$ok?$BLUE:$TAILTXT,0.8); }
    $b.=text(20,$base-30,"n = $n",anchor=>'start',size=>17,bold=>1);
    $b.=text(785,$base-78,sprintf('SE = √(0.25 / %d) = %.3f',$n,$se),anchor=>'start');
    $b.=text(785,$base-56,sprintf('E = 1.96 × SE = %.3f',$E),anchor=>'start',bold=>1);
    $b.=text(785,$base-34,"$in of 40 surveys within E",anchor=>'start',fill=>$BLUE);
    $b.=text(785,$base-14,'(red dots fall outside)',anchor=>'start',fill=>$TAILTXT,size=>12) if $in<40;
  }
  $b.=line($L,$axisY,$R,$axisY,$MUTED,1.3);
  for (my $t=$xa; $t<=$xb+1e-9; $t+=0.1) { $b.=line($X->($t),$axisY,$X->($t),$axisY+5,$MUTED,1.2).text($X->($t),$axisY+20,sprintf('%.1f',$t),fill=>$MUTED,size=>12) }
  $b.=text(($L+$R)/2,$axisY+44,'sample proportion p̂',fill=>$MUTED);
  $b.=text(500,566,'4 × the people (100 → 400) halves the margin of error (0.098 → 0.049), because SE shrinks like 1/√n.',bold=>1,fill=>$ORANGE);
  save('sample_size_wobble.svg',svg($W,$H,$b));
}

# ---------- Figure 2: yes/no answers as 0s and 1s ----------
{
  my ($W,$H)=(1160,540); my $b='';
  $b.=text(580,32,'Why p(1 − p) plays the role of σ²',size=>20,bold=>1);
  $b.=text(580,54,'Code yes = 1 and no = 0. Then p̂ is just the average of the 0s and 1s, and their variance is E[X²] − (E[X])² = p − p² = p(1 − p).',fill=>$MUTED);
  my %zeros=(1.0=>[], 0.8=>[3,9,12,16], 0.5=>[1,2,5,7,8,10,13,14,17,19], 0.2=>[grep{ !/^(2|7|11|15)$/ }0..19]);
  for my $col ([1.0,'everyone says yes',160],[0.8,'mostly yes',440],[0.5,'split 50/50',720],[0.2,'mostly no',1000]) {
    my ($p,$tag,$cx)=@$col; my %z=map{$_=>1}@{$zeros{$p}};
    $b.=text($cx,92,sprintf('p = %.1f',$p),size=>16,bold=>1).text($cx,110,$tag,fill=>$MUTED);
    for my $i (0..19) { my $x=$cx-128+($i%10)*26; my $y=124+int($i/10)*26;
      if ($z{$i}) { $b.=rect($x,$y,22,22,fill=>'#EEEEEE',stroke=>'#BBBBBB',rx=>4).text($x+11,$y+16,'0',size=>14,bold=>1,fill=>$MUTED) }
      else        { $b.=rect($x,$y,22,22,fill=>$BLUE,rx=>4).text($x+11,$y+16,'1',size=>14,bold=>1,fill=>'#ffffff') } }
    my $v=$p*(1-$p);
    $b.=text($cx,200,sprintf('E[X] = p = %.1f',$p));
    $b.=text($cx,220,sprintf('E[X²] = %.1f   (1² = 1, 0² = 0)',$p));
    $b.=text($cx,244,sprintf('σ² = %.1f − %s = %s',$p,($p==1?'1.0²':sprintf('%.2f',$p*$p)),($v==0?'0':sprintf('%.2f',$v))),size=>15,bold=>1,fill=>$ORANGE);
    # sampling distribution of p-hat for n = 100, on the full 0-1 scale
    my $base=430; my $X=sub{ $cx-120+$_[0]*240 };
    for my $i (0..10) { my $t=$i/10; my $major=$i%2==0;
      $b.=line($X->($t),$base,$X->($t),$base+($major?5:3),$MUTED,1.2);
      $b.=text($X->($t),$base+20,sprintf('%.1f',$t),fill=>$MUTED,size=>12) if $major; }
    $b.=line($cx-120,$base,$cx+120,$base,$MUTED,1.3);
    if ($p==1) {
      my $x=$X->(1.0); $b.=line($x,$base,$x,$base-112,$BLUE,4).polygon([[$x,$base-126],[$x-7,$base-110],[$x+7,$base-110]],$BLUE);
      $b.=text($x-22,$base-96,'every survey:',anchor=>'end',fill=>$BLUE).text($x-22,$base-78,'p̂ = 1 exactly',anchor=>'end',fill=>$BLUE,bold=>1);
      $b.=text($cx,$base+48,'SE = 0',size=>15,bold=>1).text($cx,$base+68,'no uncertainty at all',fill=>$MUTED);
    } else {
      my $se=sqrt($v/100); my $peak=4.5/$se; my $d=sub{ $base-pdf(($_[0]-$p)/$se)/pdf(0)*$peak };
      my @pts=map{ my $t=$_*0.002; [$X->($t),$d->($t)] }0..500;
      $b.=polygon([[$X->(0),$base],@pts,[$X->(1),$base]],$MID).polyline(\@pts,$BLUE,2.5);
      $b.=dashed($X->($p),$base,$X->($p),$base-$peak-8,$MUTED,1.2);
      $b.=text($cx,$base+48,sprintf('SE = √(%.2f / 100) = %.2f',$v,$se),size=>15,bold=>1);
      $b.=text($cx,$base+68,$p==0.5?'the widest spread possible':$p==0.2?'same spread as p = 0.8':'narrower: answers are less mixed',fill=>$MUTED);
    }
    # the 20 individual answers above, stacked two wide at the only values they can take: 0 and 1
    my $nz=scalar @{$zeros{$p}};
    my $stack=sub{ my ($xv,$k,$fill,$stroke)=@_; my $s='';
      for my $j (0..$k-1) { my $x=$X->($xv)+($j%2?4.5:-4.5); my $y=$base-5-int($j/2)*9;
        $s.='<circle cx="'.f1($x).'" cy="'.f1($y).qq{" r="4" fill="$fill" stroke="$stroke" stroke-width="1"/>\n}; } $s };
    $b.=$stack->(0,$nz,'#E0E0E0','#8A8A8A').$stack->(1,20-$nz,$BLUE,'#ffffff');
  }
  $b.=text(580,284,'Below: the dots at 0 and 1 are the 20 single answers; the curve is where their average p̂ lands across many surveys of n = 100.',fill=>$MUTED,italic=>1);
  save('sample_size_zero_one.svg',svg($W,$H,$b));
}

# ---------- Figure 3: what drives n ----------
{
  my ($W,$H)=(1000,420); my $b='';
  $b.=text(500,32,'What drives the sample size',size=>20,bold=>1);
  $b.=text(500,54,'n = z² p̂(1 − p̂) / E². Unless varied: 95% confidence (z = 1.96), E = 0.05 and p̂ = 0.5. Each n is rounded up.',fill=>$MUTED);
  my %fr=(y=>110,w=>210,h=>210);
  # A: confidence level
  { my ($X,$Y,$s)=axes(%fr,x=>90,xmin=>0.80,xmax=>0.99,ymin=>0,ymax=>800,xticks=>[0.80,0.85,0.90,0.95,0.99],yticks=>[0,200,400,600,800],
      xfmt=>sub{ sprintf '%d%%',$_[0]*100+0.5 },xlabel=>'confidence level',ylabel=>'sample size n',title=>'Higher confidence');
    $b.=$s.polyline([map{ my $c=0.80+$_*0.0019; [$X->($c),$Y->(nsize(zcrit($c),0.5,0.05))] }0..100],$BLUE,2.5);
    for my $c (0.90,0.95,0.99) { my $z=zcrit($c); my $n=ceil(nsize($z,0.5,0.05)); my ($x,$y)=($X->($c),$Y->($n));
      $b.=circle($x,$y,5,$ORANGE).text($x-8,$y-9,sprintf('z = %.3f → %d',$z,$n),anchor=>'end',fill=>$ORANGE,size=>12,bold=>1); }
    $b.=text(195,395,'z ↑  →  n ↑',size=>15,bold=>1); }
  # B: margin of error
  { my ($X,$Y,$s)=axes(%fr,x=>420,xmin=>0.02,xmax=>0.10,ymin=>0,ymax=>2500,xticks=>[0.02,0.04,0.06,0.08,0.10],yticks=>[0,500,1000,1500,2000,2500],
      xfmt=>sub{ sprintf '%.2f',$_[0] },xlabel=>'margin of error E',ylabel=>'sample size n',title=>'Smaller margin of error');
    $b.=$s.polyline([map{ my $e=0.02+$_*0.0008; [$X->($e),$Y->(nsize(1.96,0.5,$e))] }0..100],$BLUE,2.5);
    for my $e (0.025,0.05) { my $n=ceil(nsize(1.96,0.5,$e)); my ($x,$y)=($X->($e),$Y->($n));
      $b.=circle($x,$y,5,$ORANGE).text($x+9,$y-8,"E = $e → $n",anchor=>'start',fill=>$ORANGE,size=>12,bold=>1); }
    $b.=text($X->(0.075),$Y->(1250),'E ÷ 2  →  n × 4',fill=>$ORANGE,bold=>1);
    $b.=text(525,395,'E ↓  →  n ↑↑ (squared)',size=>15,bold=>1); }
  # C: p-hat
  { my ($X,$Y,$s)=axes(%fr,x=>750,xmin=>0,xmax=>1,ymin=>0,ymax=>450,xticks=>[0,0.2,0.4,0.6,0.8,1],yticks=>[0,100,200,300,400],
      xlabel=>'p̂',ylabel=>'sample size n',title=>'p̂ closer to 0.5');
    $b.=$s.polyline([map{ my $p=$_/100; [$X->($p),$Y->(nsize(1.96,$p,0.05))] }0..100],$BLUE,2.5);
    for my $p (0.5,0.8) { my $n=ceil(nsize(1.96,$p,0.05)); my ($x,$y)=($X->($p),$Y->($n)); $b.=circle($x,$y,5,$ORANGE);
      $b.=$p==0.5 ? text($x,$y-12,"p̂ = 0.5 → $n",fill=>$ORANGE,size=>12,bold=>1) : text($x-10,$y+20,"p̂ = 0.8 → $n",anchor=>'end',fill=>$ORANGE,size=>12,bold=>1); }
    $b.=text(855,395,'p̂ → 0.5  →  n ↑',size=>15,bold=>1); }
  save('sample_size_drivers.svg',svg($W,$H,$b));
}

# ---------- Figure 4: why p-hat = 0.5 is the safe choice ----------
{
  my ($W,$H)=(1000,440); my $b='';
  $b.=text(500,32,'Why p̂ = 0.5 is the safe choice',size=>20,bold=>1);
  $b.=text(500,54,'p̂(1 − p̂) = 0.25 − (p̂ − 0.5)². The gap is a square, so it is never negative and the product never tops 0.25.',fill=>$MUTED);
  # left: the product under its 0.25 ceiling
  { my ($X,$Y,$s)=axes(x=>90,y=>105,w=>340,h=>230,xmin=>0,xmax=>1,ymin=>0,ymax=>0.30,xticks=>[0,0.2,0.4,0.5,0.6,0.8,1],yticks=>[0,0.1,0.2,0.25,0.3],
      xlabel=>'p̂',ylabel=>'p̂(1 − p̂)',title=>'The product sits under a ceiling of 0.25');
    my @c=map{ my $p=$_/200; [$X->($p),$Y->($p*(1-$p))] }0..200;
    $b.=$s.polygon([@c,[$X->(1),$Y->(0.25)],[$X->(0),$Y->(0.25)]],$TAIL,0.7);
    $b.=dashed($X->(0),$Y->(0.25),$X->(1),$Y->(0.25),$ORANGE,1.8).polyline(\@c,$GREEN,2.8);
    $b.=text($X->(0.03),$Y->(0.232),'gap =',anchor=>'start',fill=>$TAILTXT,size=>12,bold=>1)
       .text($X->(0.03),$Y->(0.212),'(p̂ − 0.5)²',anchor=>'start',fill=>$TAILTXT,size=>12,bold=>1);
    $b.=circle($X->(0.5),$Y->(0.25),6,$ORANGE).text($X->(0.5),$Y->(0.25)-12,'max 0.25 at p̂ = 0.5',fill=>$ORANGE,bold=>1);
    my ($x,$y1,$y2)=($X->(0.8),$Y->(0.16),$Y->(0.25));
    $b.=line($x,$y1,$x,$y2,$TAILTXT,2.5).line($x-5,$y2,$x+5,$y2,$TAILTXT,2.5).circle($x,$y1,5,$BLUE);
    $b.=text($x+10,$y2+16,'gap = 0.09',anchor=>'start',fill=>$TAILTXT,size=>12,bold=>1).text($x+10,$y2+32,'= (0.8 − 0.5)²',anchor=>'start',fill=>$TAILTXT,size=>12);
    $b.=text($x-10,$y1+18,'0.8 × 0.2 = 0.16',anchor=>'end',fill=>$BLUE,size=>12,bold=>1);
    $b.=text(260,415,'At p̂ = 0.8:  0.16 = 0.25 − 0.09',size=>14,bold=>1); }
  # right: plan with 0.5, the real E can only come out smaller
  { my $n=ceil(nsize(1.96,0.5,0.05));
    my ($X,$Y,$s)=axes(x=>610,y=>105,w=>340,h=>230,xmin=>0,xmax=>1,ymin=>0,ymax=>0.06,xticks=>[0,0.2,0.4,0.5,0.6,0.8,1],yticks=>[0,0.01,0.02,0.03,0.04,0.05,0.06],
      xfmt=>sub{$_[0]},xlabel=>'true p',ylabel=>'real margin of error E',title=>"Real E once you survey n = $n");
    $b.=$s.dashed($X->(0),$Y->(0.05),$X->(1),$Y->(0.05),$ORANGE,1.8);
    $b.=text($X->(1),$Y->(0.05)-8,'planned E = 0.05',anchor=>'end',fill=>$ORANGE,bold=>1);
    $b.=polyline([map{ my $p=$_/200; [$X->($p),$Y->(1.96*sqrt($p*(1-$p)/$n))] }0..200],$BLUE,2.8);
    my $e8=1.96*sqrt(0.16/$n);
    $b.=circle($X->(0.5),$Y->(1.96*sqrt(0.25/$n)),6,$ORANGE).circle($X->(0.8),$Y->($e8),6,$BLUE);
    $b.=text($X->(0.8)-8,$Y->($e8)+24,sprintf('true p = 0.8 → E ≈ %.3f',$e8),anchor=>'end',fill=>$BLUE,bold=>1);
    $b.=text(780,415,sprintf('Planned for 0.5; if p is really 0.8, E ≈ %.3f < 0.05',$e8),size=>14,bold=>1); }
  save('sample_size_worst_case.svg',svg($W,$H,$b));
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
