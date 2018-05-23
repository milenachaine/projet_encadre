#/usr/bin/perl
<<DOC;
BAO 1 Margaux Duhayon
Commande : perl BAO1.pl repertoire-a-parcourir rubrique


#------------------------ BAO1 ----------------------------------

#--------- Définition des variables et entête du fichier xml-------------------------------

my $rep="$ARGV[0]";
my $rubrique="$ARGV[1]";
my %dico= ();

$rep=~ s/[\/]$//; # le nom du répertoire ne doit pas se termine pas par un "/"

open my $sortie_txt,">:encoding(utf8)", "$rubrique.txt"; #sortie qui sera un fichier txt
open my $sortie_xml,">:encoding(utf8)", "$rubrique.xml"; # sortie qui sera un fichier xml
print $sortie_xml "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n"; #entête du futur fichier xml
print $sortie_xml "<PARCOURS>\n";
print $sortie_xml "<NOM>Duhayon Margaux</NOM>\n";
print $sortie_xml "<ABSTRACT>\n";


&parcoursarborescencefichiers($rep);    # on lance la récursion

print $sortie_xml "</ABSTRACT>\n";
print $sortie_xml "</PARCOURS>\n";

close $sortie_txt;
close $sortie_xml;

exit;

#----------------Ouverture des fichier ------------------------------

sub parcoursarborescencefichiers {
    my $path = shift(@_);
    opendir(DIR, $path) or die "can't open $path: $!\n";
    my @files = readdir(DIR);
    closedir(DIR);
    foreach my $file (@files) {
        next if $file =~ /^\.\.?$/;
        $file = $path."/".$file;
        if (-d $file) {
            print "<NOUVEAU REPERTOIRE> ==> ",$file,"\n";
            &parcoursarborescencefichiers($file);    #recurse!
            print "<FIN REPERTOIRE> ==> ",$file,"\n";
        }
        
        #---------------- Si c'est un fichier xml : récuperer le texte ------------------------------
        
        if (-f $file) {
            if($file =~ m/$rubrique.+\.xml$/) {
                
                print "<",$i++,"> ==> ",$file,"\n";
                
                open my $FILEIN, "<:encoding(utf-8)", $file;
                
                my $ensemble="";
                while (my $ligne=<$FILEIN>) {
                    chomp $ligne;
                    $ligne =~ s/\r//g;
                    $ensemble = $ensemble . $ligne ;
                }
                
                #----------------Chercher les balises titre et description ------------------------------
                
                while ($ensemble =~ m/<item>.*?<title>(.+?)<\/title>.*?<description>(.+?)<\/description>.*?<\/item>/g){
                    my $title = $1;
                    my $description = $2;
                    if (!exists $dico{$title})
                    {
                        $dico{$title} = 1;
                        my ($titre_propre, $description_propre) = &nettoyage($title, $description);
                        
                        #---------------- Impression du contenu dans des balises ------------------------------
                        
                        print $sortie_txt "$titre_propre.\n";
                        print $sortie_txt "$description_propre\n\n";
                        
                        print $sortie_xml "<item><titre>$titre_propre</titre><description>$description_propre</description></item>\n";
                        
                    }
                }
            }
        }
    }
}

#------------ Sous-programme de nettoyage -------------------

sub nettoyage {
    my $var1 = shift(@_); # @_: liste des arguemnts d'une procédure
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
    $var5 =~ s/\t+//g;
    $var6 =~ s/> +</></g;
    $var7 =~ s/<[^>]+?>//g;
    return $var1,$var2,$var3,$var4,$var5,$var6,$var7;
}
