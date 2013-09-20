#!/usr/local/bin/perl
use strict;
use URI::Fetch;
use HTML::TreeBuilder::XPath;

my $file = "./cache.csv";


# http://b.hatena.ne.jp/entry/http://d.hatena.ne.jp/santaro_y/20051022/p1
my $oodanna = {"naoya" => 1030, "umedamochio" => 697, "jkondo" => 690, "kanose" => 493, "finalvent" => 421, "miyagawa" => 333, "otsune" => 314, "laiso" => 311, "Hamachiya2" => 223, "lovelovedog" => 207, "gotanda6" => 201, "higepon" => 191, "netafull" => 190, "jazzanova" => 184, "ekken" => 183, "kurimax" => 181, "kmizusawa" => 180, "essa" => 179, "kowagari" => 179, "nekoprotocol" => 178, "ululun" => 178, "amiyoshida" => 177, "REV" => 171, "antipop" => 166, "chepooka" => 164, "kawasaki" => 164, "brazil" => 161, "wacky" => 155, "ieiri" => 152, "nobody" => 151, "R30" => 148, "another" => 145, "hugo-sb" => 140, "fladdict" => 139, "kanimaster" => 138, "KGV" => 135, "lsty" => 135, "sweetlove" => 134, "secondlife" => 129, "zonia" => 129, "yto" => 124, "wetfootdog" => 122, "kensuu" => 119, "nisemono_san" => 118, "gachapinfan" => 116, "sirouto2" => 116, "mind" => 115, "ykurihara" => 112, "hiromark" => 110, "TakahashiMasaki" => 106, "asobi" => 106, "happyicecream" => 106, "umeten" => 106, "stella_nf" => 105, "rAdio" => 104, "matakimika" => 102, "nopiko" => 100};

# “Ç‚ÝŽæ‚è
my $cache = &readCSV();
foreach my $id(keys(%$oodanna)){
	next if defined $cache->{$id};

	my @oodanna_no_okiniiri = &getFavorites($id);
	&writeCSV($id, $oodanna->{$id}, @oodanna_no_okiniiri);
}

foreach my $id(keys(%$oodanna)){
	my $dat = $cache->{$id};
	print '"'.$id.'"'.":{count:".$dat->{'count'}.",favorite:[\"", join('","', @{$dat->{favorite}})."\"]},\n";
}

sub writeCSV{
	open FILE, ">>$file" or die;
	print FILE join(",", @_)."\n";
	close(FILE);
}

sub readCSV{
	open FILE, $file or return;
	my @lines = <FILE>;
	close(FILE);

	my $dat = {};
	foreach(@lines){
		chomp;
		my ($id, $hifav, @fav) = split(/,/, $_);
		$dat->{$id} = {count => $hifav, favorite => \@fav};
	}
	$dat;
}

sub getFavorites{
	my $id = shift;
	my $res = URI::Fetch->fetch(sprintf 'http://b.hatena.ne.jp/%s/favorite', $id) or die URI::Fetch->errstr;

	my $tree = HTML::TreeBuilder::XPath->new;
	$tree->parse($res->content);
	$tree->eof;

	# /user1//user2//user3/
	my $favorites = $tree->findvalue('/html//div[@class="favoritelist"]//li/a[position()=1]/@href');
	$favorites=~m!/([^/]+)/!g;
}

