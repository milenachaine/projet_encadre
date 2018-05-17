#!/usr/bin/perl
# Extraction des patrons morphosyntaxiques dans les étiquetages produits avec Cordial
# Données : fichier d'entrée passé dans le logiciel cordial.
#  commande : perl BAO3 new_3208.cnr


use utf8;
binmode STDOUT, ":utf8";

#---------LECTURE DU FICHIER -------------------------------

open (FICHIER, "<:encoding(utf8)", $ARGV[0]);
my $chaine="";

# Boucle principale
while (my $ligne=<FICHIER>)
{

    $ligne=~s/\r//g;
    chomp $ligne;

#---------Récupération du POS et du TOKEN -------------------------------

    if (($ligne=~/^([^\t]+)\t[^\t]+\t([^\t]+)$/) and ($ligne!~/PONCT_FORT/))
    {


        my $f=$1;
        my $c=$2;
        $f=~s/ /%/g;


        $chaine = $chaine . $c ."_".$f." ";
    }

    else
    {
        open (TERM, "<:encoding(utf8)", $ARGV[1]);
        while ($terme=<TERM>)
        {
            chomp($terme);
            $terme=~s/([^ ]+)/$1_\[\^ \]+/g;

        while ($chaine=~/($terme)/g)
        {

            my $correspondance=$1;
            $correspondance=~s/[A-Z]+_//g;
            $correspondance=~s/%/ /g;
            print $correspondance,"\n";

        }


        }
        close(TERM);
        $chaine="";
    }

}

close FICHIER;
# sort | uniq -c | sort -r
