#/usr/bin/perl

<<DOC;
usage : perl BAO2_extrac_etiq.pl Library numÃ©ro de la rubrique 
Par exemple : perl BAO2_extrac_etiq.pl Library 3208
Le programme prend en entrÃ©e le nom du rÃ©pertoire contenant les fichiers Ã  traiter et le numÃ©ro de la rubrique Ã  traiter
DOC

#-----------------------------------------------------------
my $rep="$ARGV[0]"; # recupÃ¨re le nom du rÃ©pertoire racine # assure que le nom du rÃ©pertoire ne se termine pas par un "/" 
my $rubrique = "$ARGV[1]";
my %dico=();

$rep=~ s/[\/]$//; 

$encodage = "utf-8";
my $compteurfile=1;
my $compteuritem=0;

my $output1=$rubrique.".xml";
my $output2=$rubrique.".txt";

if(!open (FILEOUT, ">:encoding($encodage)", $output1)) { die "Pb Ã  l'ouverture du fichier $output1" }; 
if(!open (FILEOUT2, ">:encoding($encodage)", $output2)) { die "Pb Ã  l'ouverture du fichier $output2" }; 

print FILEOUT "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print FILEOUT "<PARCOURS>\n";
print FILEOUT "<NOM>Ferial Yahiaoui</NOM>\n";
print FILEOUT "<FILTRAGE>\n";


#----------------------------------------
&parcoursarborescencefichiers($rep);  # lance la rÃ©cursion...elle se terminera aprÃ¨s examen de toute l'arborescence
#----------------------------------------


if(!open (FILEOUT, ">>:encoding($encodage)", $output1)) { die "Pb Ã  l'ouverture du fichier $output1" }; 

print FILEOUT "\n</FILTRAGE>\n";
print FILEOUT "</PARCOURS>\n";

close(FILEOUT); 

exit;
#----------------------------------------------
sub parcoursarborescencefichiers {
    my $path = shift(@_); # rÃ©cupÃ¨re le rÃ©pertoire
    opendir(DIR, $path) or die "can't open $path: $!\n"; # ouvre le rÃ©pertorie reÃ§u en argument, donc $path
    my @files = readdir(DIR); # lit le repertoire, readdir renvoit une liste, celle des documents Ã  l'intÃ©rieur de DIR, on les met dans un listes # ne traite pas./ et courant../ prÃ©cÃ©dent sinon, on se retrouve dans une boucle
    closedir(DIR);         
    foreach my $file (@files) { # la liste obtenue est relative au rÃ©pertoire ouvert
    next if $file =~ /^\.\.?$/; # next: passe au prochain Ã©lÃ©ment si l'actuel ne correspond pas Ã  celui chÃ©rchÃ©
    $file = $path."/".$file;  


    if (-d $file) { # vrai si l'objet est un rÃ©pertoire 
      print "<NOUVEAU REPERTOIRE> ==> ",$file,"\n";
      &parcoursarborescencefichiers($file); # recurse! 
      print "<FIN REPERTOIRE> ==> ",$file,"\n";
    }
    if (-f $file) { # vrai si l'objet est un fichier
      if($file =~/$rubrique.+\.xml$/) # point pris en compte Ã  la fin de la ligne (pour le titre)
      {
        print "<",$compteurfile++,"> ==> ",$file,"\n";  
        
        open (FIC, "<encoding($encodage)", $file);
        my $texte="";
        while (my $ligne = <FIC>){
          chomp $ligne;
          $ligne =~ s/\r//g;
          $texte = $texte . $ligne;

      }
      
      close FIC;
      
      $texte =~ s/>\s+</></g;
      
      while($texte=~ 
      m/<item>.*?<title>([^<]*?)<\/title>.*?<description>([^<]*?)<\/description>/g)
      { 
        
        my $titre = $1;
        my $description = $2;
        
        ($titre, $description) = &nettoyage($titre, $description);
        if(!(exists $dico {$titre})) 
        { 
          $dico{$titre} = 1;
          
          print FILEOUT2 "$titre.\n$description\n\n";
          
          
          $compteurItem++;
          
          my ($titre_etiq, $description_etiq) = &etiquetage($titre, $description);
          print FILEOUT "<item number=\"$compteurItem\">\n<titre>$titre_etiq</titre>\n<description>$description_etiq</description>\n</item>\n";
        
        }
  
      }   

      }
      
      
    
    }
}
sub nettoyage {

  # @_ c'est une liste
  # my $var1 = $_[0];

  my $var1 = shift(@_);   # shift supprime le premier Ã©lÃ©ment et le recupÃ¨re dans une variable
  my $var2 = shift(@_);

  # $description =~s/&lt;.+?&gt;//g;
    $var1 =~s/&lt;.+?&gt;//g;
    $var2 =~s/&lt;.+?&gt;//g;
    $var1 =~s/&amp;/et/g;
    $var2 =~s/&amp;/et/g;
    $var1=~s/\?\.$/\?/;
  
  return $var1,$var2;

}
#----------------------------------------------
sub etiquetage {

  my $var1 = shift(@_); # l'input est le titre et la description
  my $var2 = shift(@_);

  #-------------------titre
  
  open(OUT, ">:encoding(utf8)", "titre_tmp.txt"); 
  print OUT $var1;
  
  close OUT;

  
  system("perl tokenise-utf8.pl titre_tmp.txt | ./tree-tagger/bin/tree-tagger -lemma -token -no-unknown ./tree-tagger/lib/french-utf8.par > titre_tmp_etiq.txt");
  system("perl treetagger2xml-utf8.pl titre_tmp_etiq.txt utf8");
  local $/=undef;
  open (FIC, "<:encoding(utf8)", "titre_tmp_etiq.txt.xml");
  my $titre_retour=<FIC>;
  $titre_retour=~s/<\?xml version="1\.0" encoding="utf-8" standalone="no"\?>\n//;
  
  #------------------------------------------description
  
  open(OUT, ">:encoding(utf8)", "description_tmp.txt"); 
  print OUT $var2;

  
  close OUT;
  
  system("perl tokenise-utf8.pl description_tmp.txt | ./tree-tagger/bin/tree-tagger -lemma -token -no-unknown ./tree-tagger/lib/french-utf8.par > description_tmp_etiq.txt");
  system("perl treetagger2xml-utf8.pl description_tmp_etiq.txt utf8");
  $/=undef;
  open (FIC, "<:encoding(utf8)", "description_tmp_etiq.txt.xml");
  my $description_retour=<FIC>;
  $description_retour=~s/<\?xml version="1\.0" encoding="utf-8" standalone="no"\?>\n//;
  
  return $titre_retour, $description_retour;  
  

  
}
  
  
  
}
