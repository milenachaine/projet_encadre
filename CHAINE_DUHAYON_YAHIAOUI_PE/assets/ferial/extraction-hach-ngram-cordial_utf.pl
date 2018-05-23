#!/usr/bin/perl
#----------------------------------
# Ouverture des fichiers en lecture
#----------------------------------
open (FICTAG, $ARGV[0]) or die ("probleme sur ouverture de la sortie CORDIAL...");
open (FICPOS, $ARGV[1]) or die ("probleme sur ouverture du fichier des patrons...");
#----------------------------------------------------
# On stocke les patrons dans une table de hachage
#----------------------------------------------------
my %listedespatrons;
my @liste = ();
print "Lecture du fichier de POS\n";
while (my $lignepos = <FICPOS>) {
    chomp($lignepos);
    my @patron = split(/\#/, $lignepos);
	#------------------------------------------------------------------------------------------
	# @liste gardera en mémoire le nombre de POS dont est composé chaque patron syntaxique
    push(@liste, $#patron+1);
	#------------------------------------------------------------------------------------------
	$lignepos =~ s/#/ /g;
	#-----------------------------------------------------------------------------------------------------------------
	# Attention, on stocke des tableaux comme valeurs, donc initialiser ces valeurs à () et non "" !
	# Sinon le script stockera la totalité des suites reconnues (soit plus de 10 000) comme valeur de chaque clé !
    $listedespatrons{$lignepos} = ();
	#-----------------------------------------------------------------------------------------------------------------


}
#------------------------------------------------------------------------------------------------------------------------
# Suppression des doublons de @patron : on obtient des valeurs uniques qui serviront à générer des n-grammes de POS
my %listengramstemp  = map { $_, 1 } @liste;
my @listedesngrams = keys %listengramstemp;


#------------------------------------------------------------------------------------------------------------------------
close(FICPOS);
#---------------------------
# Initialisation des listes
#--------------------------
my @malignesegmentee = ();
my @listedetokens = ();
my @listedelemmes = ();
my @listedepos = ();
#-------------------------------------------
# Lecture du fichier de tags ligne par ligne
#-------------------------------------------
print "Lecture du fichier a analyser\n";
while (my $ligne = <FICTAG>) {
    #-------------------------------------------------------------------------------------
    # On ne s'occupe pas des lignes qui ne respectent pas la modèle mot tab mot tab mot
    #-------------------------------------------------------------------------------------
    #if ($ligne =~ /^[^\t]+\t[^\t]+\t[^\t]+$/) {
    if (($ligne=~/^[^\t]+\t[^\t]+\t[^\t]+$/) and ($ligne !~/PCTFORTE/)){
    	
	#-------------------------------------------
	# Suppression du caractère de saut de ligne
	chomp($ligne);
	#-------------------------------------------
	# Remplissage des listes
	@malignesegmentee = split(/\t/, $ligne);
	push(@listedetokens, $malignesegmentee[0]);
	push(@listedelemmes, $malignesegmentee[1]);
	push(@listedepos, $malignesegmentee[2]);
	#-------------------------------------------
	
    }

}
close(FICTAG);
#--------------------------------------------------------------------------------------
# Génération de n-grammes de POS (en fonction du nombre de POS dans les patrons)
# et recherche si chaque n-gramme généré correspond à un patron de %listedespatrons
#--------------------------------------------------------------------------------------
print "Recherche des patrons syntaxiques\n";
foreach my $n (@listedesngrams) {
	$n = $n-1;
	my $j = 0;	
	until ($j+$n > $#listedepos) {
		my $ngram = join(" ", @listedepos[$j .. $j+$n]);
		
		#-----------------------------------------------------------------
		# Si la suite de POS est reconnue comme clé de %listedespatrons
		# on stocke les tokens correspondants en valeur du hash
		if (exists $listedespatrons{$ngram}) {
			my $motsreconnus = join(" ", @listedetokens[$j .. $j+$n]);
			push(@{$listedespatrons{$ngram}},$motsreconnus);
		#-----------------------------------------------------------------
#			$listedespatrons{$ngram} .= "$motsreconnus\n";

			
		}
		$j++;
	}
}
#-------------------------------------------------
# Impression des résultats de l'extraction
#-------------------------------------------------
my $dump = "";
#-------------------------------------------------
# Parcours de la table de hachage
print "Ecriture des resultats\n";
while ( ($key, $value) = each(%listedespatrons) ) {
    $dump .= "------------------------\n";
    $dump .= "$key\n-------------------------\n";

  
	#--------------------------------------------------------------
	# Parcours du tableau contenant les suites de mots reconnues
	# qui correspondent au patron syntaxique (la clé)
   	foreach my $term (@$value) {
		$dump .= $term;
#		$dump = $dump . $term;
#		$dump .= $value;
		$dump .= "\n";

		
	#--------------------------------------------------------------
	}
	$dump .= "\n\n\n";
	
}
#-------------------------------------------------

open(OUT, ">:encoding(utf8)", "resultat.txt");

print OUT $dump;
close(OUT);
exit;