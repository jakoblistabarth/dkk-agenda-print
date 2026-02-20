#import "components.typ": *
#import "utils.typ": *

#set document(author: "Jakob Listabarth", title: "Programm 74. DKK 2026", date: datetime.today())
#set page(margin: 1cm, footer: {
  set text(size: .8em)
  context [DGfK, Stand: #custom-date-format(document.date, lang: "de")]
})
#set text(font: "Source Sans 3", lang: "de")

#show title: set text(fill: cmyk(100%, 0%, 100%, 30%), size: 1.5em, weight: 300)
#show heading.where(level: 2): set block(above: .5em, below: 0em)
#show heading: set text(fill: cmyk(100%, 0%, 100%, 30%))

#let agenda = parse-data("agenda.json")
#let schedule-items = extract-schedule-items(agenda)

#title()

Die DKK 2026 findet von 27.--29. Mai 2026 an der Technischen Universität Dresden statt. Das Programm umfasst Keynotes, Vorträge und Workshops sowie Exkursionen und Rahmenprogramm.

#table(
  columns: 4,
  rows: 3,
  stroke: none,
  align: center + horizon,
  table.header([], [Mittwoch, 27.5.2026], [Donnerstag, 27.5.2026], [Freitag, 29.5.2026]),
  [Vormittag], [Workshops], [Keynote und Vorträge], [Keynote und Vorträge],
  [Nachmittag], [Keynote und Vorträge], [Keynote und Vorträge], [Exkursionen und Rahmenprogramm],
  [Abend], [Kartograph*innen-Treff], [Gemeinsames Abendessen], [],
)

#(
  schedule-items
    .pairs()
    .map(
      ((date, sessions)) => {
        heading(level: 2, date)
        v(1em)
        grid(
          columns: (1fr, 1fr), row-gutter: 3em, column-gutter: 1em,
          ..sessions.map(d => {
            let items = d.at("agenda-items", default: ())
            let hasTrack = "track" in d.acf and d.acf.track != false
            let hasParallelSessions = (
              sessions.filter(parallel-Item => d.date-time-start == parallel-Item.date-time-start).len() > 1
            )
            grid.cell(
              colspan: if (hasTrack and hasParallelSessions == true) { 1 } else { 2 },
              {
                d.acf.at("track", default: none)
                heading(level: 3, d.title.rendered)
                d.date-time-start.display("[hour]:[minute]")
                sym.dash.en
                d.date-time-end.display("[hour]:[minute]")
                stack(dir: ttb, spacing: 1em, ..items.map(i => agenda-item(i)))
              },
            )
          })
        )
      },
    )
    .join(linebreak())
)



// = Vorträge nach Session
// #stack(dir: ttb, spacing: 1em, ..get-agenda-by-type(agenda, "Vortrag").map(d => agenda-item(d)))

= Workshops

#stack(dir: ttb, spacing: 1em, ..get-agenda-by-type(agenda, "Workshop").map(d => agenda-item(d)))

= Rahmenprogramm / Netzwerken

#stack(dir: ttb, spacing: 1em, ..get-agenda-by-type(agenda, "Soziales / Networking").map(d => agenda-item(d)))
