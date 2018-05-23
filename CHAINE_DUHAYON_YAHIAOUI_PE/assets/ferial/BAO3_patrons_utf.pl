#!/usr/bin/perl
# programme d'extraction de patrons
# sur sortie Coridal
#  commande : perl patron.pl new_3208.cnr
#----------------------------------------
use utf8;
binmode STDOUT, ":utf8";
my $chaine="";
open (FIC, "<:encoding(utf8)", $ARGV[0]);

while (my $ligne=<FIC>) { # on dit au programme : "chaque fois que tu lis une ligne"


	#------------------------------
	#lisant ce fichier ligne Ã  ligne, je veux voir la PartsOfSpeech et le TOKEN
	#sous cette forme : POS_FORME
	# On aura quelque chose du type : (pour code de la route) $chaine = "NOM_code  PREP_de  DET_la  NOM_route" 
	#------------------------------


	chomp $ligne; 
	$ligne=~s/\r//g; 

	#print $ligne;

	if (($ligne=~/^(.+?)\t.+?\t(.+?)$/) and ($ligne !~/PCTFORTE/)) { # on s'arrÃªte Ã  Ponct forte
	
	#if (($ligne=~/^[^\t](.+)\t[^\t](.+)\t[^\t](.+)$/) and ($ligne !~/PCTFORTE/)) {
		my $f=$1;
		#print $f, "\n";
		my $c=$2;
		#print $c, "\n";


		$f=~s/ /#/g; # supprimer les Ã©ventuels espaces dans un token 
		

	####################
	#$ligne=~/^([^\t]+)\t([^\t]+)\t([^\t]+)$/;
	#print "Voici la POS : $2\n";
	#print "Voici le token : $1\n";
	#print "return pour continuer ";
	####################

	$chaine = $chaine . $c."_".$f." ";
	#$chaine = $chaine . $c."_".$f." ";
	#print $chaine;
	####################
	# print $chaine;
	# $continu=<STDIN>; # lire ce qu'on a tapÃ© sur l'entrÃ©e standard
	####################

	}
	else {
		#print $chaine;
		#$continu=<STDIN>;
		open(TERM,$ARGV[1]);
		while (my $terme=<TERM>){ # tant que le fichier TERM n'est pas terminÃ©, lis moi ce fichier ligne Ã  ligne 
			# comment transformer : NOM ADJ
			# en 				  : NOM_([^ ]+) ADJ_([^ ]+)
			# pour ensuite chercher $terme dans $chaine 
			chomp($terme);
			#print "term : <",$terme,">\n";
			$terme=~s/([^ ]+)/$1_\[\^ \]+/g;
			#$terme=~s/([^ ]+)/$1_\[\^ \]+/g; # [^ ] = tout sauf un espace  dans patrons, match une suite de caractÃ¨res alph comme NCFS, vu qu'il y a des chiffres aussi dans le fichier cordial Ã  cÃ´tÃ© des patrons, donc tout sauf des blancs
			#print "terme chnge $terme\n";
			# Mais ici n'est pas une expression rÃ©guliÃ¨re car on a dÃ©spÃ©cialisÃ© 
			# pour s'assurer que ce qu'on va gÃ©nÃ©rer en sortie sera chaque caractÃ¨re un par un : [ puis, ^, puis ]
			# $terme=~s/([A-Z]+)/$1_\w\+/g;
			# ou $terme=~s/(\w+)/$1_\w\+/g;
			# print "TERME : ", $terme, "\n";
			while ($chaine=~/$terme/g){
				#print "OK\n";
				my $correspondance=$&;
				$correspondance=~s/[A-Z]+_//g;
				$correspondance=~s/#/ /g;
				print $correspondance, "\n";
				#$a=<STDIN>;
			}

		}
		close(TERM);
		$chaine=""; # On vide la chaine Ã  chaque fois qu'on arrive Ã  une ponctuation
	}


	} 

close (FIC);