<corpus>
{
for $rss in doc("3244")//article
for $element in $rss/element
let $next := $element/following-sibling::element[1]
let $nextN := $next/following-sibling::element[1]
where $element/data[1]="NOM" and $next/data[1]="PRP" and $nextN//data[1]="NOM"
return <PATRON-NOM-PRP-NOM>{$element,$next,$nextN}</PATRON-NOM-PRP-NOM>
}
</corpus>

