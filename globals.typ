#import "@preview/modpattern:0.1.0": *

#let colors = (
  dark-green: cmyk(100%, 0%, 100%, 30%),
  light-green: cmyk(100%, 0%, 100%, 30%).lighten(95%),
  lime-green: cmyk(30%, 0%, 60%, 0%),
  lime-green-light: cmyk(30%, 0%, 60%, 0%).lighten(80%),
)

#let tilings = (
  stripe: modpattern((6pt, 6pt))[
    #place(line(start: (.2pt, .2pt), angle: -45deg, stroke: (paint: colors.light-green, cap: "round")))
  ],
)
