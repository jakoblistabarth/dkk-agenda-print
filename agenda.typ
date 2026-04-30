#import "globals.typ": *
#import "components.typ": *
#import "utils.typ": *

#set document(author: "Jakob Listabarth", title: "74. Deutscher Kartographie Kongress 2026", date: datetime.today())
#set page(
  margin: (top: 2cm, rest: 1.5cm),
  header: {
    image("links/dgfk-logo-small.svg", height: 1.5em)
  },
  footer: context {
    set text(size: .8em)
    [DGfK, Stand: #custom-date-format(document.date, lang: "de")]
    h(1fr)
    counter(page).display("1 von 1", both: true)
  },
)
#set text(font: "Source Sans 3", lang: "de")

#show heading: set text(fill: colors.dark-green)
#show heading: set par(leading: .4em)

#show heading.where(level: 1): set block(above: 1.75em)
#show heading.where(level: 1): set text(weight: "light", size: 1.5em)
#show heading.where(level: 2): set block(above: .75em, below: 0em)
#show heading.where(level: 3): set text(weight: 400, size: 1.3em)
#show heading.where(level: 4): set text(weight: 600)
#show heading.where(level: 4): set block(below: 0.45em)


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

#block(width: 35em)[
  Der 74. Deutsche Kartographie Kongress der DGfK findet vom 27. bis 29. Mai 2026 an der Technischen Universität Dresden statt. Das Programm umfasst Keynotes, Vorträge und Workshops sowie Exkursionen und Rahmenprogramm.

  Die Kongresstage werden mit zwei Keynote-Vorträgen namhafter Referenten eröffnet:

  - *Jochen Topf* spricht unter dem Titel _"Wir setzen alles auf eine Karte! -- Kartographie und Technik bei OpenStreetMap"_ über Chancen, Entwicklungen und Bedeutung freier Geodaten.
  - *Dr. Rolf Böhm* widmet sich in seiner Keynote _"Manuelles Kartenzeichnen 2026"_ den Grundlagen, Qualitäten und dem Selbstverständnis kartographischer Arbeit zwischen Tradition und Innovation.
]

= Übersicht

#table(
  columns: 4,
  rows: 3,
  stroke: none,
  align: center + horizon,
  gutter: 1pt,
  inset: 1em,
  fill: (x, y) => if (x > 0 and y > 0 and not (x == 3 and y == 3)) { colors.light-green } else { none },
  table.header([], [*Mittwoch, 27. Mai*], [*Donnerstag, 27. Mai*], [*Freitag, 29. Mai*]),
  [Vormittag],
  [Workshops],
  table.cell(rowspan: 2, fill: colors.dark-green, text(fill: white, weight: "black")[Keynote und Vorträge]),
  table.cell(fill: colors.dark-green, text(fill: white, weight: "black")[Keynote und Vorträge]),
  [Nachmittag], [Mitgliederversammlung der DGfK], [Exkursionen und Rahmenprogramm],
  [Abend], [Kartograph*innen-#sym.wj;Treff], [Gemeinsames Abendessen], [],
)

= Komplettes Programm

#(
  schedule-items
    .pairs()
    .map(
      ((date, sessions)) => {
        heading(level: 2, date)
        v(1em)
        grid(
          columns: (1fr, 1fr), gutter: 1.25em,
          ..sessions.map(d => {
            let items = d.at("agenda-items", default: ())
            let isSessionWithItems = items.len() > 0
            let hasTrack = "track" in d.acf and d.acf.track != false
            let hasParallelSessions = (
              sessions.filter(parallel-Item => d.date-time-start == parallel-Item.date-time-start).len() > 1
            )
            grid.cell(
              inset: (top: if isSessionWithItems { 2.25em } else { 0em }),
              colspan: if (hasTrack and hasParallelSessions == true) { 1 } else { 2 },
              if (isSessionWithItems) {
                heading(level: 3, d.title.rendered)
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
    .join(linebreak())
)
