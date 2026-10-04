// スライドのテンプレート．
// touying 0.8.0 の university テーマ（Pol Dellaiera 作）を元に切り出したもの．

#import "@preview/cades:0.3.1": qr-code
#import "@preview/ctheorems:2.0.0": *
#import "@preview/curryst:0.6.0": prooftree, rule
#import "@preview/diagraph:0.3.7": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/numbly:0.1.0": numbly
#import "@preview/oxifmt:1.0.0": strfmt
#import "@preview/touying:0.8.0": *

#let _foreground = color.hsl(216deg, 100%, 0.98%)
#let theme-colors = (
  background: color.hsl(240deg, 31.18%, 98%),
  foreground: _foreground,
  secondary: oklch(_foreground).lighten(50%),
  accent: color.hsl(331.96deg, 80.7%, 55.29%),
)

// QR コードは背景を透明にし，文字色で描く．
#let qr-code = qr-code.with(
  color: theme-colors.foreground,
  background: rgb(0, 0, 0, 0),
)

// 定理環境．全ての環境で一つの通し番号 `theorem` を共有する．
#let thmplain(counter, supplement) = thm.with(
  supplement: supplement,
  counter: counter,
  base: none,
  fmt: thm-fmt-block.with(
    block-args: (
      breakable: false,
      radius: 0pt,
      inset: (left: 1em, top: 0.75em, bottom: 0.75em),
      stroke: (left: 0.25em + theme-colors.accent),
    ),
    name-fmt: x => [(#x)],
    title-fmt: strong,
    body-fmt: x => x,
    separator: [#h(0.1em):#h(0.2em)],
  ),
)
#let theorem = thmplain("theorem", "定理")
#let lemma = thmplain("theorem", "補題")
#let definition = thmplain("theorem", "定義")
#let proposition = thmplain("theorem", "命題")
#let corollary = thmplain("theorem", "系")
#let example = thmplain("theorem", "例").with(numbering: none)
#let fact = thmplain("theorem", "事実")
#let remark = thmplain("theorem", "注意")
#let problem = thmplain("theorem", "問題")
#let proof = thm.with(
  supplement: "証明",
  numbering: none,
  fmt: thm-fmt-block.with(
    block-args: (
      breakable: false,
      radius: 0.3em,
      inset: (top: 0em, left: 1.2em, right: 1.2em),
    ),
    name-fmt: emph,
    title-fmt: emph,
    body-fmt: proof-body-fmt,
    separator: [#h(0.1em):#h(0.2em)],
  ),
)
#let struct(body) = block(
  width: 100%,
  breakable: true,
  stroke: (left: (thickness: 1pt, paint: luma(230))),
  inset: (left: 12pt, top: 5pt, bottom: 8pt),
)[#body]

/// 通常のスライド．
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  align: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  if align != auto {
    self.store.align = align
  }
  // ヘッダー: 左にセクション（小さく）とスライドのタイトル，右にページ番号．
  // ヘッダー: accent の帯に，左にセクション（小さく）とスライドのタイトル，右にページ番号．
  let header(self) = {
    set std.align(top)
    let on-accent = self.colors.neutral-lightest
    let on-accent-secondary = on-accent.transparentize(30%)
    block(
      width: 100%,
      fill: gradient
        .linear(
          angle: 20deg,
          (color.hsl(250.24deg, 67.21%, 11.96%), 0%),
          (self.colors.accent, 100%),
        )
        .sharp(8),
      // ヘッダーはページ幅いっぱいに置かれるので，左右の inset で本文の左端に揃える．
      inset: (x: 2em, top: 1em, bottom: 1em),
      grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: (left + bottom, right + bottom),
        stack(
          dir: ttb,
          spacing: 1em,
          text(size: .75em, fill: on-accent-secondary, utils.call-or-display(self, self.store.header-section)),
          text(fill: on-accent, weight: "bold", size: 1.2em, utils.call-or-display(self, self.store.header-title)),
        ),
        text(fill: on-accent-secondary, utils.call-or-display(self, self.store.header-right)),
      ),
    )
  }
  let self = utils.merge-dicts(self, config-page(header: header, footer: none))
  let new-setting = body => {
    show: std.align.with(self.store.align)
    show: setting
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})

/// タイトルスライド．内容は `config-info` から取る．引数で直接渡してもよい．
#let title-slide(
  config: (:),
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em, header: none, footer: none),
    config,
  )
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  // BUAA-Slide (https://github.com/Lyrics2196/BUAA-Slide) のタイトルページを参考にした．
  // 上段はグラデーションの帯に白抜きのタイトル，下段は著者・所属・日付と QR コード．
  let body = {
    grid(
      rows: (2fr, 1fr),
      block(
        width: 100%,
        height: 100%,
        inset: (x: 3em, y: 2em),
        fill: gradient
          .linear(
            angle: 20deg,
            (color.hsl(250.24deg, 67.21%, 11.96%), 0%),
            (self.colors.accent, 75%),
            (color.hsl(250.24deg, 67.21%, 11.96%), 100%),
          )
          .sharp(15),
        {
          set text(fill: self.colors.neutral-lightest)
          if info.logo != none {
            place(left + top, info.logo)
          }
          std.align(right + bottom, {
            set par(leading: .25em)
            stack(
              dir: ttb,
              spacing: 2em,
              text(
                size: 3em,
                weight: 700,
                font: "Geist",
                fill: rgb("#ffffff"),
                tracking: -0.05em,
                info.title,
              ),
              ..if info.subtitle != none {
                (
                  text(
                    size: 1.125em,
                    weight: "bold",
                    font: "Shippori Antique B1",
                    fill: rgb("#fff"),
                    tracking: -0.1em,
                    info.subtitle,
                  ),
                )
              },
            )
          })
        },
      ),
      block(
        width: 100%,
        height: 100%,
        inset: (x: 3em, y: 1em),
        fill: self.colors.neutral-lightest,
        {
          set text(
            size: 1em,
            fill: self.colors.primary,
          )
          grid(
            columns: (1fr, auto),
            rows: 100%,
            column-gutter: 1em,
            std.align(left + horizon, {
              info.authors.join(", ")
              if info.institution != none {
                h(1.5em)
                "|"
                h(1.5em)
                info.institution
              }
              if info.contact != none {
                linebreak()
                text(size: .9em, info.contact)
              }
              if info.date != none {
                v(.8em, weak: true)
                text(size: .9em, utils.display-info-date(self))
              }
            }),
            // `config-info(url: ..)` があれば，そこへの QR コードを右端に置く．
            if info.at("url", default: none) != none {
              std.align(right + horizon, link(
                info.url,
                qr-code(info.url, height: 80%),
              ))
            },
          )
        },
      ),
    )
  }
  touying-slide(self: self, body)
})

/// セクションの区切りスライド．
#let new-section-slide(
  config: (:),
  level: 1,
  numbered: true,
  body,
) = touying-slide-wrapper(self => {
  let setting(level, numbered, body) = {
    set std.align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em, fill: self.colors.primary, weight: "bold")
    stack(
      dir: ttb,
      spacing: .65em,
      utils.display-current-heading(level: level, numbered: numbered),
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(
          height: 2pt,
          self.colors.primary,
          self.colors.primary-light,
        ),
      ),
    )
    body
  }
  touying-slide(
    self: self,
    config: config,
    setting: setting.with(level, numbered),
    body,
  )
})

/// 強調用のスライド．例: `#focus-slide[Wake up!]`
#let focus-slide(
  config: (:),
  background-color: none,
  background-img: none,
  body,
) = touying-slide-wrapper(self => {
  let background-color = if (
    background-img == none and background-color == none
  ) {
    rgb(self.colors.primary)
  } else {
    background-color
  }
  let args = (:)
  if background-color != none {
    args.fill = background-color
  }
  if background-img != none {
    args.background = {
      set image(fit: "stretch", width: 100%, height: 100%)
      background-img
    }
  }
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    // 2em: 以前は 1em を本文の `size: 2em` で拡大していた．
    config-page(margin: 2em, ..args),
    config,
  )
  touying-slide(
    self: self,
    setting: it => std.align(
      horizon,
      text(fill: self.colors.neutral-lightest, weight: "bold", size: 2em, it),
    ),
    body,
  )
})

/// 発表者ノートのパネル．見た目だけを決め，レイアウトは `touying-notes` に任せる．
#let notes(self: none, ..args) = touying-notes(
  self: self,
  header: self => pad(x: 32pt, y: 16pt, text(
    fill: self.colors.neutral-lightest,
    utils.display-current-heading(depth: self.slide-level),
  )),
  header-fill: self.colors.primary,
  fill: self.colors.neutral-lightest,
  ..args,
)

/// テーマ本体．`#show: slides-theme.with(..)` で使う．
#let slides-theme(
  aspect-ratio: "16-9",
  align: horizon,
  header-section: utils.display-current-heading(level: 1),
  header-title: utils.display-current-heading(level: 2, style: auto),
  header-right: self => context {
    text(
      font: "JuliaMono",
      utils.slide-counter.display() + "/" + utils.last-slide-number,
    )
  },
  ..args,
  body,
) = {
  show: thm-rules

  show: touying-slides.with(
    config-page(
      ..utils.page-args-from-aspect-ratio(aspect-ratio),
      header-ascent: 0em,
      footer-descent: 0em,
      margin: (top: 3.5em, bottom: 1.25em, x: 2em),
      fill: theme-colors.background,
    ),
    config-common(
      slide-fn: slide,
      notes-fn: notes,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(size: 25pt)
        show heading.where(level: 3): set text(fill: self.colors.primary)
        show heading.where(level: 4): set text(fill: self.colors.primary)

        body
      },
      alert: (self: none, it) => text(fill: self.colors.accent, it),
    ),
    config-colors(
      primary: theme-colors.foreground,
      secondary: theme-colors.secondary,
      tertiary: rgb("#b8f131"),
      accent: theme-colors.accent,
      neutral-lightest: theme-colors.background,
      neutral-darkest: theme-colors.foreground,
    ),
    config-store(
      align: align,
      header-section: header-section,
      header-title: header-title,
      header-right: header-right,
    ),
    ..args,
  )

  set text(font: "Shippori Antique", size: 18pt, fill: theme-colors.foreground)
  show strong: set text(fill: theme-colors.accent)
  // 数式内の日本語が OS 既定のフォントにならないよう，数式フォントの後ろに本文フォントを足す．
  show math.equation: set text(font: ("New Computer Modern Math", "Shippori Antique"))
  show raw: set text(font: "JuliaMono", size: 1em)
  show raw.where(block: true): set text(size: 0.9em)
  show link: set text(font: "JuliaMono", fill: theme-colors.accent)
  show footnote.entry: set text(size: .75em, fill: theme-colors.secondary)
  set footnote.entry(separator: line(length: 30%, stroke: .5pt + theme-colors.secondary))

  set heading(numbering: numbly("{1}.", default: "1.1"))
  set cite(form: "prose")

  show link: underline

  show bibliography: set text(lang: "en", size: 16pt)

  body
}
