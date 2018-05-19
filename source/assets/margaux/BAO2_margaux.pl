#/usr/bin/perl


my $rep="$ARGV[0]"; #recupere le nom du r�pertoire
my $rubrique="$ARGV[1]"; #filtrer

$rep =~ s/[\/]$//; #sino =~ s/[\/]$//;

my %dico=();
my $codage = "utf-8";
my $compteurfile=1;
my $compteurItem=0;

my $output1=$rubrique.".xml";
my $output2=$rubrique.".txt";

if (!open (FILEOUT,">:encoding($codage)",$output1)) { die "Problème à l'ouverture du fichier $output1"};
if (!open (FILEOUT2,">:encoding($codage)",$output2)) { die "Problème à l'ouverture du fichier $output2"};

print FILEOUT "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print FILEOUT "<PARCOURS>\n";
print FILEOUT "<NOM>Margaux Duhayon</NOM>\n";
print FILEOUT "<FILTRAGE>\n";



#----------------------------------------
&parcoursarborescencefichiers($rep);	# on lance la recursion.... et elle se terminera apres examen de toute l'arborescence
#----------------------------------------

if (!open (FILEOUT,">>:encoding($codage)",$output1)) { die "Problème à l'ouverture du fichier $output1"};
print FILEOUT "\n</FILTRAGE>\n";
print FILEOUT "</PARCOURS>\n";
close(FILEOUT);
exit;
#----------------------------------------------
sub parcoursarborescencefichiers {

    # open (XML, ">>:encoding(utf8), "lemonde.xml);

    my $path = shift(@_); #r�cup�re nom du rep
    opendir(DIR, $path) or die "can't open $path: $!\n"; # fonction qui permet d'ouvrir d'un r�pertiore � la mani�re de l'ouverture d'un fichier
    my @files = readdir(DIR); #lire rep , renvoir une liste
    closedir(DIR);
    foreach my $file (@files) {
		next if $file =~ /^\.\.?$/;
		$file = $path."/".$file;
		if (-d $file) { #vrai si objet est un rep
			print "<NOUVEAU REPERTOIRE> ==> ",$file,"\n";
			&parcoursarborescencefichiers($file);	#recurse!
			print "<FIN REPERTOIRE> ==> ",$file,"\n";
		}
		if (-f $file) { #faux si objet est rep

			if ($file =~/$rubrique.+\.xml$/){
            print "<",$compteurfile++,"> ==> ",$file,"\n";

            open(FIC, "<:encoding($codage)", $file);  #Ouverture du fichier passé en argument au script et association à un pointeur de fichier
            #open (FILEOUT1, ">>:encoding(utf-8)", "sortie_$rubrique.txt"); #> écrasement alors il faut mettre >>
            #open (FILEOUT2, ">>:encoding(utf-8)", "sortie_$rubrique.xml");
            my $ensemble="";
            while (my $ligne=<FIC>) { #sert à lire les lignes du fichier; on la déclare localement dans la boucle
                chomp $ligne;
                $ligne=~ s/\r//g;
        	      $ensemble = $ensemble . $ligne;

        }
                close FIC;

                $ensemble =~ s/>\s+</></g;

                #while ($ensemble =~ m/<item>.*?<title>(.+?)<\/title>.+?<description>(.+?)<\/description>.*?<\/item>/g) { #? s'arrête au premier </title, g pour global pour qu'il fasse tout le texte. ELVIRA: moi j´ai <item> *.+?...(un espace entre > et l´étoile).
                #m/<item>.*?<title>(.+?)<\/title>.*?<description>([^<]*?)<\/description>.*?<\/item>/g
                while ($ensemble =~ m/<item>.*?<title>(.+?)<\/title>.*?<description>(.+?)<\/description>.*?<\/item>/g) {

              		my $titre = $1;
              		my $description = $2;

                  my ($titre, $description) = &nettoyage ($titre, $description); #& veut dire éxecute

                  if (!(exists $dico{$title}))
                  {

                    $dico{$titre} = 1; #eviter les doublon, en donnant une clé au titre. Si il rencontre la même clé il prend rien



                    $compteurItem++;
                    my ($titre_etiq, $desc_etiq) = &etiquetage ($titre, $description);

                    print FILEOUT "<item number=\"$compteurItem\">\n<titre>$titre_etiq</titre>\n<description>$desc_etiq</description>\n</item>\n";
                    print FILEOUT2 "$titre\n$description\n\n";
                  }
              }

			      }
        }
    }
}

sub nettoyage {

	#my $var1 = $_[O]; #création de tableau
	  my $var1 = shift(@_); #shift récupère 1 ère valeur du tableau
    my $var2 = shift(@_);


    $var1=~s/&lt;.+?&gt;//g; # nettoyage � compl�ter...
    $var2=~s/&lt;.+?&gt;//g; # nettoyage � compl�ter...
    $var1.=".";
    $var1=~s/\?\.$/\?/;
    return $var1,$var2;
}

sub etiquetage
{
  my $var1 = shift(@_);
  my $var2 = shift(@_);
  open (OUT, ">:encoding(utf8)", "titre_tempo.txt");
  print OUT $var1;
  close OUT;
  system ("perl tokenise-utf8.pl titre_tempo.txt | ./treetagger/bin/tree-tagger -lemma -token -no-unknown ./treetagger/lib/french-utf8.par > titre_etiq_tempo.txt");
  system ("perl treetagger2xml-utf8.pl titre_etiq_tempo.txt utf8");
  $/=undef;
  open (FIC,"<:encoding(utf8)","titre_etiq_tempo.txt.xml");
  my $titre_retour=<FIC>;
  $titre_retour =~s/<\?xml version="1\.0" encoding="utf-8" standalone="no"\?>\r\n//;
  print $titre_retour;

  open (OUT, ">:encoding(utf8)", "desc_tempo.txt");
  print OUT $var2;
  close OUT;
  system ("perl tokenise-utf8.pl desc_tempo.txt | ./treetagger/bin/tree-tagger -lemma -token -no-unknown ./treetagger/lib/french-utf8.par > desc_etiq_tempo.txt");
  system ("perl treetagger2xml-utf8.pl desc_etiq_tempo.txt utf8");
  $/=undef;
  open (FIC,"<:encoding(utf8)", "desc_etiq_tempo.txt.xml");
  my $desc_retour=<FIC>;
  $desc_retour =~s/<\?xml version="1\.0" encoding="utf-8" standalone="no"\?>\n//;

  $/="\n";

  return $titre_retour, $desc_retour;
  #exit;
}
