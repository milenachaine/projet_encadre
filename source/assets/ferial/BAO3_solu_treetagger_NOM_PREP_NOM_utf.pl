open(FILE,"$ARGV[0]");
#--------------------------------------------
# le patron cherchÃ© ici est du type "NOM_PREP_NOM";

#--------------------------------------------
my @lignes=<FILE>;
close(FILE);
while (my $ligne=shift(@lignes)) {
    chomp $ligne;
    my $sequence="";
    my $longueur=0;

    if ( $ligne =~ /<element><data type=\"type\">NOM<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
		my $forme=$1;
		$sequence.=$forme;
		$longueur=1;

		my $nextligne=$lignes[1]; # saut de ligne dans nos fichiers XML
  		if ( $nextligne =~ /<element><data type=\"type\">PRP<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
  			my $forme=$1;
  			$sequence.=" ".$forme;
  			$longueur=2;

  			my $nextligne1=$lignes[3]; # saut de ligne dans nos fichiers XML
  			if ( $nextligne1 =~ /<element><data type=\"type\">NOM<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
  				my $forme=$1;
  				$sequence.=" ".$forme;
  				$longueur=3;
  			}
  		}
    }
    if ($longueur == 3) {
	  

    print $sequence,"\n";
     
    }
}