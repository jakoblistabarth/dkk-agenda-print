#import "@preview/zebra:0.1.0": qrcode

#import "globals.typ": *
#import "components.typ": *
#import "utils.typ": *

#set document(author: "Jakob Listabarth", title: "74. Deutscher Kartographie Kongress 2026", date: datetime.today())
#set page(
  paper: "a5",
  margin: (top: 1.5cm, rest: .75cm),
  header: context {
    grid(
      columns: if here().page() == 1 { (1fr, 1fr) } else { (1fr, 1fr, 1fr) },
      align: if here().page() == 1 { (left, right) } else { (left, center, right) },
      image("links/dgfk-logo-small.svg", height: 1.5em),
      align(horizon, {
        set par(leading: .25em)
        stack(
          dir: ltr,
          spacing: .5em,
          align(right, text(size: .5em)[Mit freundlicher\ Unterstützung von]),
          image("links/Esri_Deutschland_Emblem_tag_ohne_1C.png", height: 2em),
          image("links/OCAD_Logo+_cmyk_carto_claim.pdf", height: 1.5em),
        )
      }),
      if here().page() > 1 {
        set text(fill: colors.dark-green)
        grid(
          align: right,
          gutter: .2em,
          text(weight: "black")[74. DKK],
          text(size: .75em)[Dresden 2026],
        )
      },
    )
  },
  footer: context {
    set text(size: .8em)
    [Stand: #custom-date-format(document.date, lang: "de")]
    h(1fr)
    counter(page).display("1 von 1", both: true)
  },
)
#set text(font: "Source Sans 3", lang: "de", size: 8pt)

#show heading: set text(fill: colors.dark-green)
#show heading: set par(leading: .4em)

#show heading.where(level: 1): set block(above: .5em, below: 0em)
#show heading.where(level: 2): set text(weight: 400, size: 1em)
#show heading.where(level: 2): set block(below: 0.5em)
#show heading.where(level: 3): set text(weight: 600)
#show heading.where(level: 3): set block(below: 0.45em)

#show link: it => underline(it)

#let agenda = parse-agenda("agenda.json")
#let schedule-items = extract-schedule-items(agenda)

#pad(top: 1em, {
  set text(fill: colors.dark-green)
  grid(
    align: right,
    gutter: .75em,
    text(weight: "black", size: 2.5em)[74. Deutscher Kartographie Kongress],
    text(size: 1.275em)[Dresden 2026],
  )
})

#(
  schedule-items
    .pairs()
    .map(
      ((date, sessions)) => {
        heading(level: 1, date)
        v(1em)
        grid(
          columns: (1fr, 1fr), gutter: 1em,
          ..sessions.map(d => {
            let items = d.at("agenda-items", default: ())
            let moderator-ref = d.acf.at("moderator", default: none)
            let moderator = if moderator-ref != none { get-speaker-by-id(agenda, moderator-ref) } else { none }
            let isSessionWithItems = items.len() > 0
            let hasParallelSession = (
              sessions.filter(parallel-item => d.date-time-start == parallel-item.date-time-start).len() > 1
            )
            grid.cell(
              inset: (top: if isSessionWithItems { 1em } else { 0em }),
              colspan: if (hasParallelSession == true) { 1 } else { 2 },
              if (isSessionWithItems) {
                heading(level: 2, d.title.rendered)
                set par(leading: .4em)
                d.date-time-start.display("[hour]:[minute]")
                sym.dash.en
                d.date-time-end.display("[hour]:[minute]")
                location-item(d.location)
                if moderator != none {
                  linebreak()
                  (
                    box(baseline: 0.1em, image("links/mic-line.svg", height: .8em))
                      + sym.space.nobreak
                      + moderator.post_title.replace(" ", sym.space.nobreak)
                  )
                }
                stack(dir: ttb, spacing: .5em, ..items.map(i => agenda-item((i))))
              } else {
                agenda-item(d)
              },
            )
          })
        )
      },
    )
    .join("")
)

#v(1fr)
#rect(fill: colors.light-green, radius: .5em, inset: 2em, width: 100%, grid(
  columns: (1fr, auto),
  gutter: 3em,
  [
    #set text(fill: colors.dark-green)
    *WhatsApp-Community*\
    In der WhatsApp-Community zum 74. Deutschen Kartographie Kongress erhalten Sie immer aktuelle Informationen zum Kongress, dem Rahmenprogramm und ggfs. kurzfristigen Änderungen. Scannen Sie den QR-Code mit Ihrem Smartphone, um der Community beizutreten.
  ],
  qrcode(
    "https://chat.whatsapp.com/BJyEPJHogI9IaCZ4plJaOF",
    fill: colors.dark-green,
    height: 5em,
    background-fill: white,
    quiet-zone: 3,
  ),
))
