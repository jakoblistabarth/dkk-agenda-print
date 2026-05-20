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
  stroke: .5pt + colors.dark-green,
  radius: .25em,
  inset: .5em,
  fill: if (d.type.slug in ("excursion", "dgfk", "workshop", "social")) { colors.lime-green-light } else if (
    d.type.slug == "keynote"
  ) {
    colors.light-green
  } else { white },
  {
    let (date, start-time) = d.acf.start_time.split(" ")
    let (year, month, day) = date.split("-")
    let end-time = d.acf.end_time.slice(11)
    let speaker = d.acf.at("speaker", default: ())
    let isNoTalk = d.type.slug != "talk"
    let icon = if (d.type.slug == "excursion") {
      "links/compass-line.svg"
    } else if (d.type.slug == "social") {
      "links/chat-smile-2-line.svg"
    } else if (d.type.slug == "workshop") {
      "links/pencil-ruler-line.svg"
    } else if (d.type.slug == "keynote") {
      "links/keynote-line.svg"
    }

    let icon-colored = color-svg-icon(icon, white)

    if (isNoTalk) {
      rect(
        outset: (top: .5em),
        inset: (x: .5em, top: 0em),
        stroke: 0pt,
        fill: colors.dark-green,
        radius: (bottom: .25em),
        {
          if (icon != none) { box(baseline: 0.1em, inset: (right: .2em), image(icon-colored, height: .7em)) }
          text(
            fill: white,
            weight: 900,
            tracking: .1em,
            size: .7em,
            upper(d.type.name),
          )
        },
      )
    }
    show heading: set block(above: .7em)
    heading(level: 3, html-unescape(d.title.rendered))
    set par(leading: .4em)
    {
      start-time + sym.dash.en + end-time
      if (
        // show location if exists for non-talk items
        "location" in d and d.location != none and d.type.slug != "talk"
      ) { location-item(d.location) }
      if (speaker != false and speaker.len() > 0) {
        let icon = if (speaker.len() > 1) { "links/group-line.svg" } else { "links/user-line.svg" }
        [ · ]
        (
          box(inset: (top: -1em, right: .05em), baseline: 0.1em, image(icon, height: .8em))
            + sym.space.nobreak
            + speaker.map(s => s.post_title.replace(" ", sym.space.nobreak)).join(" · ")
        )
      }
    }
  },
)
