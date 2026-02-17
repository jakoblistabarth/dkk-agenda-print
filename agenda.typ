#import "components.typ": *

#set document(author: "Jakob Listabarth", title: "Programm 74. DKK 2026")
#set text(font: "Source Sans 3", lang: "de")

#let agenda = json("agenda.json").sorted(key: it => {
  let start = it.acf.start_time
  let (year, month, day, hour, minute) = start.split(regex("[- :]")).map(s => int(s))
  let date-time-start = datetime(year: year, month: month, day: day, hour: hour, minute: minute, second: 0)
  return date-time-start
})

#let agenda-by-type = agenda.fold(
  agenda.map(d => (d._embedded.at("acf:term").at(0).name, ())).dedup(key: it => it.at(0)).to-dict(),
  (acc, d) => {
    let type = d._embedded.at("acf:term").at(0).name
    acc.at(type).push(d)
    return acc
  },
)

#show heading.where(level: 2): set block(above: .5em, below: 0em)

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

= Vorträge nach Session

#stack(dir: ttb, spacing: 1em, ..agenda-by-type.at("Vortrag").map(d => agenda-item(d)))

= Workshops

#stack(dir: ttb, spacing: 1em, ..agenda-by-type.at("Workshop").map(d => agenda-item(d)))
