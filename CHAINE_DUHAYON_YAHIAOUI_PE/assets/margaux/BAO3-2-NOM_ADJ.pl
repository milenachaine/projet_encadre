open(FILE,"$ARGV[0]");

# Définition du tableau #
my @lignes=<FILE>;
close(FILE);

#Début de la boucle #
while (my $ligne=shift(@lignes)) {

    chomp $ligne;
    my $sequence="";
    my $longueur=0;

    # Recherche des NOMS #
    if ( $ligne =~ /<element><data type=\"type\">NOM<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
		my $forme=$1;
		$sequence.=$forme;
		$longueur=1;
		my $nextligne=$lignes[1]; 

    # Recherche des ADJECTIFS #
  		if ( $nextligne =~ /<element><data type=\"type\">ADJ<\/data><data type=\"lemma\">[^<]+<\/data><data type=\"string\">([^<]+)<\/data><\/element>/) {
  			my $forme=$1;
  			$sequence.=" ".$forme;
  			$longueur=2;
  		}
    }
    if ($longueur == 2) {
	    print $sequence,"\n";
    }
}