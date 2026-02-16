#import "components.typ": *

#set document(author: "Jakob Listabarth", title: "Programm 74. DKK 2026")
#set text(font: "Source Sans 3", lang: "de")

#let agenda = json("agenda.json").sorted(key: it => {
  let start = it.acf.start_time
  let (year, month, day, hour, minute) = start.split(regex("[- :]")).map(s => int(s))
  let date-time-start = datetime(year: year, month: month, day: day, hour: hour, minute: minute, second: 0)
  return date-time-start
})

// #panic(agenda.map(d => (d._embedded.at("acf:term").at(0).name, none)).dedup(key: it => it.at(0)).to-dict())

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

= Workshops

// #panic(..agenda-by-type.at("Workshop"))

#stack(dir: ttb, spacing: 1em, ..agenda-by-type.at("Workshop").map(d => agenda-item(d)))

= Vorträge

#stack(dir: ttb, spacing: 1em, ..agenda-by-type.at("Vortrag").map(d => agenda-item(d)))
