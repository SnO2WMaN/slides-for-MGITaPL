// 算術理論・証明可能性論理の Zoo（理論・論理の強さの図）．
// Foundation の `lake exe zoo_arithmetic` / `lake exe zoo_provability_logic` の出力を元に，cetz で手置きした静的な図である．
// 矢印は包含の向き（弱い方から強い方）に引く．破線は包含 ⪯，実線は真の包含 ⪱，同値な理論は `=` で並べる．
// スライド本文のマクロ（`PA` など）と衝突しないよう，ラベル用の定義は関数の中に閉じ込めてある．

#import "template.typ": canvas, draw, fit-to-width

#let zoo-arrow(a, b, from: "east", to: "west", dash: none) = draw.line(
  a + "." + from,
  b + "." + to,
  mark: (end: ">", size: .26, fill: black),
  stroke: (thickness: .6pt, dash: dash),
)

#let zoo-node(id, x, y, label) = draw.content((x, y), name: id, padding: .14)[#label]

#let zoo-arithmetic() = {
  let Theory(T) = $upright(sans(#T))$
  let Con(T) = $sans("Con")(#T)$
  let Incon(T) = $not Con(#T)$
  let PA = $Theory("PA")$
  let ISigma(n) = $Theory(I)Sigma_#n$
  let IPi(n) = $Theory(I)Pi_#n$
  let LSigma(n) = $Theory(L)Sigma_#n$
  let LPi(n) = $Theory(L)Pi_#n$
  let BSigma(n) = $Theory(B)Sigma_#n$
  let BPi(n) = $Theory(B)Pi_#n$
  let IBroadSigma(n) = $Theory(I)Sigma^+_#n$

  fit-to-width({
    set text(12pt)
    canvas({
      let node = zoo-node
      let ssub(a, b, from: "east", to: "west") = zoo-arrow(a, b, from: from, to: to)
      let sub(a, b, from: "east", to: "west") = zoo-arrow(a, b, from: from, to: to, dash: "dashed")
      // 同値: 下のノード `a` と上のノード `b` を縦の二重線でつなぐ
      let eq(a, b) = for dx in (-0.05, 0.05) {
        draw.line((rel: (dx, 0), to: a + ".north"), (rel: (dx, 0), to: b + ".south"), stroke: .6pt)
      }

      // 弱い方から強い方へ（横一列）
      node("EQ", 0.4, 0, $Theory("EQ")$)
      node("R0", 1.9, 0, $Theory("R"_0)$)
      node("Q", 3.4, 0, $Theory("Q")$)
      node("PAm", 5.0, 0, $PA^-$)
      node("IOpen", 7.0, 0, $Theory("IOpen")$)
      node("IS0", 9.4, 0, ISigma(0))
      node("IS1", 16.4, 0, ISigma(1))
      node("BS2", 19.0, 0, BSigma(2))
      node("IS2", 21.6, 0, ISigma(2))
      node("PA", 24.0, 0, PA)
      node("PACon", 27.2, 0, $PA + Con(PA)$)
      node("TA", 31.6, 0, $Theory("TA")$)

      // IΣ0 と IΣ1 の間の二つの経路
      node("BS1", 12.9, 1.5, BSigma(1))
      node("IS0O", 11.8, -1.5, $ISigma(0) + Omega_1$)
      node("EA", 14.4, -1.5, $Theory("EA")$)

      // 分岐
      node("IS1Incon", 16.4, -2.0, $ISigma(1) + Incon(ISigma(1))$)
      node("IS1Con", 21.6, -2.6, $ISigma(1) + Con(ISigma(1))$)
      node("PAIncon", 24.0, 1.4, $PA + Incon(PA)$)
      node("PAConIncon", 28.2, 2.8, $PA + Con(PA) + Incon(PA + Con(PA))$)

      // 同値な理論（縦に積む）
      node("IS0p", 9.4, 1.2, IBroadSigma(0))
      node("BP0", 12.9, 2.7, BPi(0))
      node("IS1p", 16.4, 1.2, IBroadSigma(1))
      node("IP1", 16.4, 2.4, IPi(1))
      node("LS1", 16.4, 3.6, LSigma(1))
      node("LP1", 16.4, 4.8, LPi(1))
      node("BP1", 19.0, 1.2, BPi(1))
      node("IP2", 21.6, 1.2, IPi(2))
      node("LS2", 21.6, 2.4, LSigma(2))

      eq("IS0", "IS0p")
      eq("BS1", "BP0")
      eq("IS1", "IS1p")
      eq("IS1p", "IP1")
      eq("IP1", "LS1")
      eq("LS1", "LP1")
      eq("BS2", "BP1")
      eq("IS2", "IP2")
      eq("IP2", "LS2")

      sub("EQ", "R0")
      ssub("R0", "Q")
      ssub("Q", "PAm")
      sub("PAm", "IOpen")
      sub("IOpen", "IS0")
      sub("IS0", "BS1")
      sub("IS0", "IS0O")
      sub("IS0O", "EA")
      sub("EA", "IS1")
      sub("BS1", "IS1")
      sub("IS1", "BS2")
      sub("BS2", "IS2")
      sub("IS2", "PA")
      ssub("PA", "PACon")
      ssub("PACon", "TA")
      ssub("IS1", "IS1Incon", from: "south", to: "north")
      ssub("IS1", "IS1Con", from: "south-east", to: "west")
      ssub("IS1Con", "TA", from: "east", to: "south-west")
      ssub("PA", "PAIncon", from: "north", to: "south")
      ssub("PACon", "PAConIncon", from: "north", to: "south")
    })
  })
}

#let zoo-provability-logic() = {
  let Theory(T) = $upright(sans(#T))$
  let Logic(L) = $sans(#L)$
  let PL(T, U) = $upright("PL")(#T, #U)$
  let PA = $Theory("PA")$
  let TA = $Theory("TA")$
  let ISigma1 = $Theory(I)Sigma_1$
  let Con(T) = $upright("Con")_(#T)$
  let TCon(T) = $#T + upright("Con")_(#T)^omega$
  let TIncon(T) = $#T + not upright("Con")_(#T)$
  let Rfn(G, T) = $upright("Rfn")_(#T)(#G)$
  let TRfnSigma1(T) = $#T + Rfn(Sigma_1, #T)$

  fit-to-width({
    set text(12pt)
    canvas({
      let node = zoo-node
      let ssub(a, b, from: "east", to: "west") = zoo-arrow(a, b, from: from, to: to)
      // 同値: 下のノード `a` と上のノード `b` を縦の二重線でつなぐ
      let eq(a, b) = for dx in (-0.05, 0.05) {
        draw.line((rel: (dx, 0), to: a + ".north"), (rel: (dx, 0), to: b + ".south"), stroke: .6pt)
      }

      // 論理（横一列）
      node("GL", 1.5, 0, Logic("GL"))
      node("GLNotBot", 6.5, 0, $Logic("GL") + not square bot$)
      node("A", 12.5, 0, Logic("A"))
      node("D", 18.5, 0, Logic("D"))
      node("S", 24.0, 0, Logic("S"))
      node("GLBot", 6.5, -1.6, $Logic("GL") + square bot$)

      // 同値な証明可能性論理（縦に積む）
      node("PL-GL", 1.5, 1.2, PL(PA, PA))
      node("PL-GLNotBot", 6.5, 1.2, PL(PA, $PA + Con(PA)$))
      node("PL-A-1", 12.5, 1.2, PL(PA, TCon(PA)))
      node("PL-A-2", 12.5, 2.4, PL(ISigma1, TCon(ISigma1)))
      node("PL-D-1", 18.5, 1.2, PL(PA, TRfnSigma1(PA)))
      node("PL-D-2", 18.5, 2.4, PL(ISigma1, TRfnSigma1(ISigma1)))
      node("PL-S", 24.0, 1.2, PL(PA, TA))
      node("PL-GLBot-1", 6.5, -2.8, PL(PA, TIncon(PA)))
      node("PL-GLBot-2", 6.5, -4.0, PL(TIncon(PA), TIncon(PA)))

      eq("GL", "PL-GL")
      eq("GLNotBot", "PL-GLNotBot")
      eq("A", "PL-A-1")
      eq("PL-A-1", "PL-A-2")
      eq("D", "PL-D-1")
      eq("PL-D-1", "PL-D-2")
      eq("S", "PL-S")
      eq("PL-GLBot-1", "GLBot")
      eq("PL-GLBot-2", "PL-GLBot-1")

      ssub("GL", "GLNotBot")
      ssub("GL", "GLBot", from: "south-east", to: "west")
      ssub("GLNotBot", "A")
      ssub("A", "D")
      ssub("D", "S")
    })
  })
}
