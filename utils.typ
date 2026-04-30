#import "@preview/datify:1.0.1": *

#let parse-date-time = string => {
  let (year, month, day, hour, minute) = string.split(regex("[- :]")).slice(0, 5).map(s => int(s))
  return datetime(year: year, month: month, day: day, hour: hour, minute: minute, second: 0)
}

#let html-unescape = s => {
  s.replace("&#8211;", sym.dash.en).replace("&#x2013;", sym.dash.en).replace("&#038;", "&")
}

#let parse-locations = file => (
  json(file).map(d => (str(d.id), (name: d.title.rendered, ..d.acf))).to-dict()
)

#let get-location-by-id = (locations, id) => locations.at(str(id), default: none)

#let parse-agenda = file => (
  json(file)
    .map(d => {
      let start = parse-date-time(d.acf.start_time)
      let end = parse-date-time(d.acf.end_time)
      let session = d._embedded.at("acf:post").find(d => d.type == "dkk_session")
      let hasSession = session != none
      let item-type = d._embedded.at("acf:term").find(d => d.taxonomy == "agenda_item_category")
      let locationPointer = if (hasSession) {
        d._embedded.at("acf:post").find(d => d.type == "dkk_session").acf.location
      } else {
        d.acf.location.ID
      }
      let locationId = if (type(locationPointer) == array) {
        locationPointer.at(0)
      } else {
        locationPointer
      }
      let location = get-location-by-id(parse-locations("locations.json"), locationId)
      (date-time-start: start, location: location, date-time-end: end, session: session, type: item-type, ..d)
    })
    .sorted(key: d => d.date-time-start)
)

// Get all agenda items that belong to a session with the given id
#let get-session-items-by-id = (agenda, id) => agenda.filter(d => (
  "session" in d.acf and d.acf.session != false and d.acf.session.ID == id
))

// Get all sessions from the agenda, with their associated agenda items
#let get-sessions = agenda => {
  return (
    agenda
      .filter(d => "session" in d and d.session != none)
      .map(d => (..d.at("session"), location: d.location))
      .dedup(key: it => it.id)
      .map(d => {
        return (
          ..d,
          date-time-start: parse-date-time(d.acf.start_time),
          date-time-end: parse-date-time(d.acf.end_time),
          agenda-items: get-session-items-by-id(agenda, d.id),
        )
      })
  )
}

#let extract-schedule-items = agenda => {
  let sessions = get-sessions(agenda)

  let agenda-items-without-session = agenda.filter(d => ("session" not in d.acf or d.acf.session == false))

  let schedule-items = (..sessions, ..agenda-items-without-session)

  let days = schedule-items
    .sorted(key: d => d.date-time-start)
    .map(d => d.date-time-start.display().slice(0, 10))
    .dedup()
    .map(d => {
      let (year, month, day) = d.split("-").map(s => int(s))
      return datetime(year: year, month: month, day: day)
    })

  let schedule-items-by-date = schedule-items.fold(
    days.map(d => (custom-date-format(d, lang: "de"), ())).to-dict(),
    (acc, s) => {
      acc.at(custom-date-format(s.date-time-start, lang: "de")).push(s)
      return acc
    },
  )
  return schedule-items-by-date
}

#let get-agenda-by-type = (agenda, name) => agenda.filter(d => d.type.name == name)


#let color-svg-icon = (icon, color) => {
  if (icon == none) { return none }

  let contents = read(icon)
  contents = contents.replace("currentColor", "white")
  return bytes(contents)
}
