for $item in collection("2017")/rss/channel/item
let $title := $item/title/text()
let $description := $item/description/text()
return ($title, $description)