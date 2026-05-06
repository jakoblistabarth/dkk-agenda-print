#import "@preview/zebra:0.1.0": qrcode

#import "globals.typ": *
#import "components.typ": *
#import "utils.typ": *

#set document(author: "Jakob Listabarth", title: "74. Deutscher Kartographie Kongress 2026", date: datetime.today())
#set page(
  paper: "a5",
  margin: (top: 1.5cm, rest: .75cm),
  header: {
    image("links/dgfk-logo-small.svg", height: 1.5em)
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
#show heading.where(level: 3): set text(weight: 600)
#show heading.where(level: 3): set block(below: 0.45em)

#show link: it => underline(it)

#let agenda = parse-agenda("agenda.json")
#let schedule-items = extract-schedule-items(agenda)

#pad(top: 1em, bottom: 1em, {
  set text(fill: colors.dark-green)
  grid(
    align: right,
    gutter: .5em,
    text(weight: "black", size: 2.5em, "74. DKK"),
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
            let isSessionWithItems = items.len() > 0
            let hasParallelSession = (
              sessions.filter(parallel-item => d.date-time-start == parallel-item.date-time-start).len() > 1
            )
            grid.cell(
              inset: (top: if isSessionWithItems { 1em } else { 0em }),
              colspan: if (hasParallelSession == true) { 1 } else { 2 },
              if (isSessionWithItems) {
                heading(level: 2, d.title.rendered)
                d.date-time-start.display("[hour]:[minute]")
                sym.dash.en
                d.date-time-end.display("[hour]:[minute]")
                location-item(d.location)
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

#rect(fill: colors.light-green, radius: .5em, inset: 2em, width: 100%)[
  #set text(fill: colors.dark-green)
  *Whats-App-Community*\
  In der Whatsapp-Community zur 74. DKK erhalten Sie immer aktuelle Informationen zum Kongress, dem Rahmenprogramm und ggfs. kurzfristige Änderungen. Hier geht's zur Whatsapp-Gruppe:

  #qrcode(
    "https://chat.whatsapp.com/BJyEPJHogI9IaCZ4plJaOF",
    fill: colors.dark-green,
    height: 5em,
    background-fill: white,
    quiet-zone: 3,
  )
]
