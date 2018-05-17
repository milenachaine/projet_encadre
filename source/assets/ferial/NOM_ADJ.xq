<corpus> { for $art in doc("numéro_de_la_rubrique")//article 
for $elt in $art/element 
let $nextelt := $elt/following-sibling::element[1] where $elt/data[1] = "NOM" and $nextelt/data[1] = "ADJ"
return <NOMADJ>{$elt/data[3]/text(), " ", $nextelt/data[3]/text()}</NOMADJ> }
</corpus>