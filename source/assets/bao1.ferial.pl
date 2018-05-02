#/usr/bin/perl
<<DOC;
JANVIER 2018
 usage : perl parcours-arborescence-fichiers repertoire-a-parcourir rubrique
 Par exemple : perl parcours-arborescence-fichiers-2018.pl 2017 3208
 Le programme prend en entrée le nom du répertoire contenant les fichiers à traiter et le "nom" de la rubrique à traiter
DOC
#-----------------------------------------------------------
my $rep="$ARGV[0]";
my $rubrique="$ARGV[1]";
my %redondant= ();
$rep=~ s/[\/]$//; # on s'assure que le nom du répertoire ne se termine pas par un "/"
my $DUMPFULL1="";

open my $sortie_txt,">:encoding(utf8)", "$rubrique.txt"; 
open my $sortie_xml,">:encoding(utf8)", "$rubrique.xml";
print $sortie_xml "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
print $sortie_xml "<PARCOURS>\n";
print $sortie_xml "<NOM>Ferial YAHIAOUI</NOM>\n";
print $sortie_xml "<ABSTRACT>\n";

#----------------------------------------
&parcoursarborescencefichiers($rep);    # on lance la récursion.... et elle se terminera après examen de toute l'arborescence
#----------------------------------------
print $sortie_xml "</ABSTRACT>\n";
print $sortie_xml "</PARCOURS>\n";

close $sortie_txt; 
close $sortie_xml; 

exit;
#----------------------------------------------
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
            &parcoursarborescencefichiers($file);   #recurse!
            print "<FIN REPERTOIRE> ==> ",$file,"\n";
        }
        if (-f $file) {
            if($file =~ m/$rubrique.+\.xml$/) {

                print "<",$i++,"> ==> ",$file,"\n"; 
               
                open my $FILEIN, "<:encoding(utf-8)", $file;
                #open(FILEOUT, ">>:encoding(utf8)", "sortie_$rubrique.txt");
                my $ensemble="";
                while (my $ligne=<$FILEIN>) {
                    chomp $ligne;
                    $ligne =~ s/\r//g;
                    $ensemble = $ensemble . $ligne ;
                }
                while ($ensemble =~ m/<item>.*?<title>(.+?)<\/title>.*?<description>(.+?)<\/description>.*?<\/item>/g){
                    my $title = $1; #mettre dans un fichier
                    my $description = $2;#mettre dans un fichier locaux temporaires
                    if (!exists $redondant{$title})
                        {
                        $redondant{$title} = 1;
                        my ($titre_propre, $description_propre) = &nettoyage($title, $description);
                        print $sortie_txt "$titre_propre.\n";
                        print $sortie_txt "$description_propre\n\n";
                        print $sortie_xml "<item><titre>$titre_propre</titre><description>$description_propre</description></item>\n";
                        }
                }

            }
            
        }
    }
}
#----------------------------------------------

sub nettoyage {
    my $var1 = shift(@_);
    my $var2 = shift(@_);
    my $var3 = shift(@_);
    my $var4 = shift(@_);
    my $var5 = shift(@_);
    my $var6 = shift(@_);
    my $var7 = shift(@_);

    $var1 =~s/&lt;.+?&gt;//g; # nettoyage à compléter...
    $var2 =~s/&lt;.+?&gt;//g; # nettoyage à compléter...
    $var3 =~ s/&#38;#39;/'/g;
    $var4 =~ s/&#039;/'/g;
    $var5 =~ s/\t+//gs; 
    $var6 =~ s/> +</></g;
    $var7 =~ s/<[^>]+?>//g;
    return $var1,$var2,$var3,$var4,$var5,$var6,$var7;
}