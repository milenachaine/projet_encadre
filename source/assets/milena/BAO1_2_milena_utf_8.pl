#/usr/bin/perl

<<DOC;
Milena Chaîne - 2017-2018
commande : perl BAO1_2_milena.pl repertoire_a_parcourir numero_de_la_rubrique
description : ce programme parcourt un répertoire (fonction parcoursarborescencefichiers)
quand il trouve un fichier xml contenant le numéro de la rubrique, il le nettoie (fonction nettoyage)
il renvoie les titres et descriptions non étiquetés dans un fichier texte
ensuite, il extrait les titres et descriptions des articles et les étiquète (fonction etiquetage, utilise treetagger)
ce résultat étiqueté est envoyé vers un fichier xml (programme treetagger2xml-utf8.pl) sous le format :
<item number="[numéro de l'article]">
<titre><document><article>[titre étiqueté]</article></document></titre>
<description><document><article>[description étiquetée]</article></document></description></item>

données : le nom du répertoire contenant les fichiers à traiter, le numéro de rubrique à traiter
résultat : un fichier txt, un fichier xml, dans un répertoire nommé sortie
DOC

#-----------------------------------------------------------

my $test="Syntaxe : perl BAO1_2_milena.pl repertoire_a_parcourir numero_de_la_rubrique\n";

if (@ARGV!=2) {
  die $test;
}

#récupération des arguments
my ($rep, $rubrique) = @ARGV;
$rep=~ s/[\/]$//; #on s'assure que le nom du répertoire ne se termine pas par un "/"

#gestion de l'encodage
my $encodage = "utf-8";

my %liste= ();
my $filecompteur = 1;
my $itemcompteur = 0;


#création du répertoire de sortie
mkdir "sortie";
open($sortie_xml, ">>:encoding($encodage)", ".\/sortie\/$rubrique.xml")
  || die "Impossible d'ouvrir $sortie_xml";
open($sortie_txt, ">>:encoding($encodage)", ".\/sortie\/$rubrique.txt")
  || die "Impossible d'ouvrir $sortie_txt";

print $sortie_xml "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print $sortie_xml "<PARCOURS>\n";
print $sortie_xml "<NOM>Milena CHAINE</NOM>\n";
print $sortie_xml "<FILTRAGE>\n";

#-----------------------------------------------------------
&parcoursarborescencefichiers($rep); #on lance la récursion qui se terminera après examen de toute l'arborescence

#-----------------------------------------------------------
print $sortie_xml "</FILTRAGE>\n";
print $sortie_xml "</PARCOURS>\n";

close $sortie_txt;
close $sortie_xml;

exit;

#-----------------------------------------------------------
sub nettoyage {
  my $var1 = shift(@_); #@_: liste des arguments d'une procédure
  my $var2 = shift(@_);
  my $var3 = shift(@_);
  my $var4 = shift(@_);
  my $var5 = shift(@_);
  my $var6 = shift(@_);
  my $var7 = shift(@_);

  $var1 =~s/&lt;.+?&gt;//g;
  $var2 =~s/&lt;.+?&gt;//g;
  $var3 =~ s/&#38;#39;/'/g;
  $var4 =~ s/&#039;/'/g;
  $var5 =~ s/\t+//gs;
  $var6 =~ s/> +</></g;
  $var7 =~ s/<[^>]+?>//g;
  return $var1,$var2,$var3,$var4,$var5,$var6,$var7;
}

#-----------------------------------------------------------
sub etiquetage {
  my $var1 = shift(@_);
  my $var2 = shift(@_);

  open($titre_txt, ">:encoding($encodage)", ".\/sortie\/titre.txt")
    || die "Impossible d'ouvrir $titre_txt";

  open($description_txt, ">:encoding($encodage)", ".\/sortie\/description.txt")
    || die "Impossible d'ouvrir $description_txt";

	print $titre_txt $var1;
	print $titre_txt "\n";
	print $description_txt $var2;
	print $description_txt "\n";

	close $titre_txt;
	close $description_txt;

	#traitement du titre
	system("perl tokenise-utf8.pl ./sortie/titre.txt | /Users/milena/Documents/Travail/M1TAL/PROJET_BAO/tree-tagger/bin/tree-tagger -token -lemma -no-unknown /Users/milena/Documents/Travail/M1TAL/PROJET_BAO/tree-tagger/lib/french-utf8.par > ./sortie/titre_etiquette.txt");
	system("perl treetagger2xml-utf8.pl ./sortie/titre_etiquette.txt utf8");

	#traitement de la description
	system("perl tokenise-utf8.pl ./sortie/description.txt | /Users/milena/Documents/Travail/M1TAL/PROJET_BAO/tree-tagger/bin/tree-tagger -token -lemma -no-unknown /Users/milena/Documents/Travail/M1TAL/PROJET_BAO/tree-tagger/lib/french-utf8.par > ./sortie/description_etiquette.txt");
	system("perl treetagger2xml-utf8.pl ./sortie/description_etiquette.txt utf8");

	local $/=undef; #pour pouvoir extraire le fichier xml en entier

	#création de la variable contenant toutes les balises titre
	open(TITRE, "<:encoding(utf8)","./sortie/titre_etiquette.txt.xml")
		|| die "Impossible d'ouvrir le fichier txt converti en xml";
	my $titre_etiquette=<TITRE>;
	$titre_etiquette =~s/<\?xml version="1\.0" encoding="utf-8" standalone="no"\?>\n//;
	close TITRE;

	#création de la variable contenant toutes les balises description
	open(DESC, "<:encoding(utf8)", "./sortie/description_etiquette.txt.xml")
		|| die "Impossible d'ouvrir le fichier txt converti en xml";
	my $description_etiquette=<DESC>;
	$description_etiquette =~s/<\?xml version="1\.0" encoding="utf-8" standalone="no"\?>\n//;
	close DESC;

	return $titre_etiquette, $description_etiquette;
}

#-----------------------------------------------------------
sub parcoursarborescencefichiers {
  my $path = shift(@_);
  opendir(DIR, $path)
    || die "Impossible d'ouvrir $path: $!\n";
  my @files = readdir(DIR);
  closedir(DIR);
  foreach my $file (@files) {

  	next if $file =~ /^\.\.?$/; #si $file est un fichier
  	$file = $path."/".$file;

  	#si $file est un répertoire
  	if (-d $file) {
  		print "<NOUVEAU REPERTOIRE> ==> ",$file,"\n";
  		&parcoursarborescencefichiers($file);	#récursivité : on va descendre dans l'arborescence et refaire la même opération
  		print "<FIN REPERTOIRE> ==> ",$file,"\n";
  	}

  	#si $file est un fichier
  	if (-f $file) {

  	  #si $file contient le nom de la rubrique
      if($file =~/$rubrique.+\.xml$/) {
        print "<",$filecompteur++,"> ==> ",$file,"\n";

        open (FICHIER, "<:encoding($encodage)", $file);
        my $ensemble="";

        #on récupère le contenu de chaque ligne
        while (my $ligne = <FICHIER>) {
          chomp $ligne;
          $ligne =~ s/\r//g;
          $ensemble = $ensemble . $ligne;
        }

        close FICHIER;

        #on récupère les titres et les descriptions
        while ($ensemble =~ m/<item>.*?<title>(.+?)<\/title>.*?<description>(.+?)<\/description>.*?<\/item>/g){
          my $titre = $1;
          my $description = $2;

          #s'ils n'ont pas déjà été traités
          if (!(exists $liste{$titre})) {
            $liste{$titre} = 1;

            #on nettoie le texte
            my ($titre_propre, $description_propre) = &nettoyage($titre, $description);

            #on étiquète le texte des titres et des descriptions avant de les réintégrer dans la sortie XML
            $itemcompteur++;
            my ($titre_etiquette, $description_etiquette) = &etiquetage($titre_propre, $description_propre);

            print $sortie_xml "<item number=\"$itemcompteur\">\n<titre>$titre_etiquette</titre>\n<description>$description_etiquette</description>\n</item>\n";
            print $sortie_txt "§ $titre\n$description\n\n";

          }
        }
      }
    }
  }
}
