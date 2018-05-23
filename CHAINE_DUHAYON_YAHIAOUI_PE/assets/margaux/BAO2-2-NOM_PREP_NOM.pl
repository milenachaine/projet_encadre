open(FILE,"$ARGV[0]");

my @lignes=<FILE>;
close(FILE);
while (my $ligne=shift(@lignes)) {
    chomp $ligne;
    my $sequence="";
    my $longueur=0;

# RECHERCHE DU NOM #
    if ( $ligne =~ /<element><data type=\"type\">NOM<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
		my $forme=$1;
		$sequence.=$forme;
		$longueur=1;

# RECHERCHE DU PRP #
		my $nextligne=$lignes[1]; 
  		if ( $nextligne =~ /<element><data type=\"type\">PRP<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
  			my $forme=$1;
  			$sequence.=" ".$forme;
  			$longueur=2;


# RECHERCHE DU NOM #
  			my $nextligne1=$lignes[3]; 
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