#import "globals.typ": *
#import "utils.typ": *

#let location-item = location => {
  let locationCode = if (location.code != none and location.code != "") {
    set text(size: .8em)
    box(stroke: .5pt, inset: .2em, baseline: .1em, radius: .2em, raw(location.code))
  } else { none }
  [ · #html-unescape(location.name) #locationCode]
}


#let agenda-item = d => rect(
  width: 100%,
  stroke: .5pt + green,
  radius: .25em,
  inset: .5em,
  fill: if (d.type.slug != "talk") { colors.light-green } else { white },
  {
    let (date, start-time) = d.acf.start_time.split(" ")
    let (year, month, day) = date.split("-")
    let end-time = d.acf.end_time.slice(11)
    let speaker = d.acf.at("speaker", default: ())
    let isNoTalk = d.type.slug != "talk"

    if (isNoTalk) {
      rect(
        outset: (top: .5em),
        inset: (x: .5em, top: 0em),
        stroke: 0pt,
        fill: colors.dark-green,
        radius: (bottom: .25em),
        text(
          fill: white,
          weight: 900,
          tracking: .1em,
          size: .7em,
          upper(d.type.name),
        ),
      )
    }
    heading(level: 4, html-unescape(d.title.rendered))
    [#start-time#sym.dash.en#end-time]
    if ("location" in d and d.type.slug in ("workshop", "social", "dgfk", "excursion")) { location-item(d.location) }
    if (speaker != false) {
      [ · ]
      box(inset: (x: .25em), image("links/group-line.svg", height: .8em)) + speaker.map(s => s.post_title).join(" · ")
    }
  },
)
