#let agenda-item = d => rect(
  width: 100%,
  stroke: .5pt + green,
  radius: 1em,
  inset: 1em,
  {
    let (date, start-time) = d.acf.start_time.split(" ")
    let (year, month, day) = date.split("-")
    let end-time = d.acf.end_time.slice(11)

    heading(level: 3, d.title.rendered)
    [#start-time#sym.dash.en#end-time]
    linebreak()
    let speaker = d.acf.at("speaker", default: ())
    if (speaker != false) { speaker.map(s => s.post_title).join(" · ") }
  },
)
