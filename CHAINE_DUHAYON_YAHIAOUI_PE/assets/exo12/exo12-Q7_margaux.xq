<corpus>
{
for $rss in doc("3244")//article
for $element in $rss/element
let $next := $element/following-sibling::element[1]
where $element/data[1] = "NOM" and $next/data[1] = "ADJ"
return <PATRON-NOM-ADJ>{$element,$next}</PATRON-NOM-ADJ>
}
</corpus>