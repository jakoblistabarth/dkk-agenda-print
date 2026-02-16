#let agenda-item = d => rect(
  width: 100%,
  stroke: .5pt + green,
  radius: 1em,
  inset: 1em,
  {
    let (date, start-time) = d.acf.start_time.split(" ")
    let (year, month, day) = date.split("-")
    let end-time = d.acf.end_time.slice(11)

    [#day.#month.#year, #start-time#sym.dash.en#end-time]
    linebreak()
    heading(level: 2, d.title.rendered)
    linebreak()
    d.acf.speaker.map(s => s.post_title).join(" · ")
    linebreak()
    if ("session" in d.acf and d.acf.session != false) { d.acf.session.post_title }
  },
)
