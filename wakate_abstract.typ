#import "@preview/ctheorems:2.0.0": *
#import "@preview/curryst:0.5.0": prooftree, rule
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/cjk-spacer:0.2.0": cjk-spacer

#let title = "定理証明支援系による不完全性定理・証明可能性論理の形式化"

#set page(
  paper: "a4",
  header-ascent: 1.6em,
  footer-descent: 2em,
)
#set text(font: "Zen Old Mincho", lang: "ja")
#set document(title: title)

#show: cjk-spacer.with()
#show math.equation: set text(font: ("New Computer Modern Math", "Zen Old Mincho"))
#set par(justify: false, first-line-indent: (amount: 1em, all: true), leading: 0.8em)
#show heading: set text(font: "Shippori Antique B1")
#set heading(numbering: "1.")
#set math.equation(numbering: "(1)", supplement: none)

#align(center, grid(
  columns: 1,
  row-gutter: 1.5em,
  text(size: 1.4em, font: "Shippori Antique B1", title),
  text(size: 1em, font: "Shippori Antique B1", [野口真柊 (神戸大学システム情報学研究科 M2)]),
))

我々は定理証明支援系であるLeanを用いて，Gödelの第1および第2不完全性定理や，Solovayの算術的完全性定理といった証明可能性論理の形式化を行った @SN26．
本講演ではそもそも定理証明支援系やLeanがどのようなものかを紹介したのち，我々が形式化した成果について軽く概説して，最後に今後の展望について述べる．
本プロジェクトは東北大学の齋藤彰悟氏との共同研究である．

#bibliography("./references.yml", style: "elsevier-with-titles")
