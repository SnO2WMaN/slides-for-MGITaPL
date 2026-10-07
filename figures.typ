// スライド中の図．

#import "@preview/cetz:0.5.2": canvas, decorations, draw
#import "template.typ": fit-to-width

/// 高さ $h$ のモデル $M$ の点 $a$ の前に $k$ 個の点の鎖を挿入すると，高さ $h + k$ のモデル $M'$ になる様子．
#let figure-chain-insertion() = {
  let accent = rgb("#d6336c")
  let added = rgb("#2f9e44")
  let arrow-style = (mark: (end: ">", size: .2, fill: black), stroke: .6pt)

  fit-to-width({
    set text(12pt)
    canvas({
      import draw: *

      let pt(name, x, y, color: black) = circle((x, y), radius: .1, name: name, stroke: .7pt + color)
      let arr(a, b, color: black) = line(
        a + ".east",
        b + ".west",
        mark: (end: ">", size: .2, fill: color),
        stroke: .6pt + color,
      )
      // 頂点 `apex` から右に開く三角形で，残りのモデルを表す
      let rest(apex, width, half) = {
        let (x, y) = apex
        line((x, y), (x + width, y + half), (x + width, y - half), close: true, stroke: .7pt)
      }

      // 上: 高さ h のモデル M
      pt("m0", 0, 0)
      pt("m1", 1.3, 0)
      pt("ma", 2.6, 0, color: accent)
      content("ma.north", text(fill: accent, $a$), anchor: "south", padding: .12)
      pt("m3", 3.9, 0)
      arr("m0", "m1")
      arr("m1", "ma")
      arr("ma", "m3")
      line("m3.east", (4.25, 0), stroke: .6pt)
      rest((4.25, 0), 2.6, .9)
      content((7.4, 0), $M$)

      decorations.brace((6.85, -1.05), (-0.15, -1.05), stroke: .6pt)
      content((3.35, -1.7), $upright("hgt")(M) = h$)

      content((3.35, -2.45), text(size: 16pt, $arrow.b.double$))

      // 下: a の前に k 個の点の鎖を挿入したモデル M'
      let y = -4.0
      pt("n0", 0, y)
      pt("n1", 1.3, y)
      pt("k0", 2.6, y, color: added)
      content((3.55, y), text(fill: added, $dots.c$))
      pt("k1", 4.5, y, color: added)
      pt("na", 5.8, y, color: accent)
      content("na.north", text(fill: accent, $a$), anchor: "south", padding: .12)
      pt("n3", 7.1, y)
      arr("n0", "n1")
      arr("n1", "k0")
      line("k0.east", (3.15, y), mark: (end: ">", size: .2, fill: added), stroke: .6pt + added)
      line((3.95, y), "k1.west", mark: (end: ">", size: .2, fill: added), stroke: .6pt + added)
      arr("k1", "na")
      arr("na", "n3")
      line("n3.east", (7.45, y), stroke: .6pt)
      rest((7.45, y), 1.3, .55)
      content((9.2, y), $M'$)

      decorations.brace((2.45, y + .35), (4.65, y + .35), stroke: .6pt + added)
      content((3.55, y + 1.0), text(fill: added, $k$))

      decorations.brace((8.9, y - 1.05), (-0.15, y - 1.05), stroke: .6pt)
      content((4.4, y - 1.7), $upright("hgt")(M') = h + k$)
    })
  })
}
