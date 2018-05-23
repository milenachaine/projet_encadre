<corpus> { for $art in doc("numéro_de_la_rubrique")//article 
for $elt in $art/element 
let $nextelt := $elt/following-sibling::element[1] 
let $nextelt2 := $nextelt/following-sibling::element[1] 
where $elt/data[1] = "NOM" and $nextelt/data[1] = "PRP" and $nextelt2/data[1] = "NOM" 
return <NOMPRPNOM>{$elt/data[2]/text(), " ", $nextelt/data[2]/text(), " ",$nextelt2/data[2]/text()}</NOMPRPNOM> 
} </corpus>