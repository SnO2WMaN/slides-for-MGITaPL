#import "template.typ": *
#import "zoo.typ": zoo-arithmetic, zoo-provability-logic

#let Pred = $serif("Pred")$
#let Sent = $serif("Sent")$
#let Pow(s) = $cal("P")(#s)$
#let True = $serif("True")$
#let False = $serif("False")$
#let setminus = $backslash$

#let mand = $op(text("and"))$
#let mor = $op(text("or"))$

#let box = $square.stroked$
#let dia = $diamond.stroked$
#let rhd = $triangle.r.stroked$

#let proves = $tack.r$
#let nproves = $tack.r.not$
#let models = $tack.rr$
#let nmodels = $tack.rr.not$
#let forces = $forces$
#let nforces = $not(forces)$

#let Bew = $op(frak("B"))$
#let Con = $bold(upright("Con"))$

// 証明可能性条件（Hilbert-Bernays-Löb）
#let D1 = $bold("D1")$
#let D2 = $bold("D2")$
#let D3 = $bold("D3")$

#let Axiom(A) = $upright(#A)$
#let AxiomK = $Axiom("K")$
#let AxiomT = $Axiom("T")$
#let Axiom4 = $Axiom("4")$
#let Axiom5 = $Axiom("5")$
#let AxiomB = $Axiom("B")$
#let AxiomD = $Axiom("D")$
#let AxiomP = $Axiom("P")$
#let AxiomL = $Axiom("L")$
#let AxiomM = $Axiom("M")$
#let AxiomDot2 = $Axiom(".2")$
#let AxiomDot3 = $Axiom(".3")$

#let Rule(R) = $upright((#R))$
#let RuleWL = $Rule("WL")$
#let RuleWR = $Rule("WL")$

// 様相論理・シークエント計算
#let Logic(L) = $bold(upright(#L))$
#let LogicGL = $Logic("GL")$
#let LogicD = Logic("D")
#let LogicS = Logic("S")
#let LogicA = Logic("A")
#let LogicGLAlpha(X) = $Logic("GL"_alpha) (#X)$
#let LogicGLBeta(X) = $Logic("GL"_beta) (#X)$

#let GentzenGL = $cal("G")_LogicGL$
#let GentzenWithCutGL = $GentzenGL + ("Cut")$

// 証明可能性論理
#let PL(T, U) = $upright("PL")_#T (#U)$

// Kripkeモデル
#let PropVer = $upright("Prop")$
#let rank = $upright("rank")$
#let height = $upright("hgt")$

// 体系・算術
#let CIC = $sans("CIC")$
#let ZFC = $sans("ZFC")$
#let Lean = $sans("Lean")$
#let LK = $bold(upright("LK"))$

#let Arith(A) = $sans(#A)$
#let PA = $Arith("PA")$
#let TA = $Arith("TA")$
#let R0 = $Arith("R"_0)$
#let ISigma1 = $upright(sans(I)) Sigma_1$
#let LOR = $cal(L)_"OR"$

// 算術化
#let Rep(S) = $sans("Rep")_(#S)$
#let godelize(x) = $lr(⌜ #x ⌝)$
#let num(x) = $overline(#x)$

#let And = $class("relation", \&)$

#let goedelTr = $cal("G")$
#let corsiTr = $cal("C")$

#show: slides-theme.with(
  config-info(
    title: [Mechanizing Gödel's Incompleteness Theorems and Provability Logic],
    subtitle: [定理証明支援系 Lean による不完全性定理・証明可能性論理の形式化について],
    author: [野口 真柊],
    date: [2026/10/07 @ SLACS 2026],
    url: "https://sno2wman.github.io/slides-for-MGITaPL-Lean4/main.pdf",
    institution: [
      神戸大学システム情報学研究科 M2
    ],
  ),
)

#title-slide()

#grid(
  columns: (1fr, auto),
  column-gutter: 12pt,
  inset: (x: 32pt),
  [
    - スライド: #link("https://sno2wman.github.io/slides-for-MGITaPL-Lean4/main.pdf")
    - プレプリント: #link("https://arxiv.org/abs/2609.13780")
  ],
  [
    #qr-code("https://sno2wman.github.io/slides-for-MGITaPL-Lean4/main.pdf", width: 180pt)
  ],
)

= はじめに

この発表では定理証明支援系Lean

#pagebreak()

= 定理証明支援系

== Leanについて

Lean 4は型理論としてCalculus of Inductive ($CIC$) を採用している．
原理上は#footnote[
  Lean 3では @Car19 が $ZFC + #text[「$omega$-個の到達不能基数が存在する」]$ の無矛盾性をモデルを作って示している．
  この結果を素直にこの結果をLean 4に持ってくることは出来ない（らしい）が，最近ようやく #link("https://github.com/leanprover/con-leche") などで取り組まれているように思える．
  もちろん今ある数学が全然 $ZFC$ でやってるわけねーだろという方にとっては一切この話は関係ない．
]普通に行われている数学が全部展開出来るだろうとされている．

== 余談: 定理証明支援系・Leanは信頼できるか？

最近のニュース: @Kum260726 はCollatz予想の反証をLean v4.32.1 で形式化した．

#leancode[
  ```lean
  -- `n` はCollatzの操作を何度行っても1にならない．
  def Diverges (n : Nat) : Prop := 0 < n ∧ ∀ k, iterate step k n ≠ 1

  -- そのような `n` が存在する．
  theorem exists_nonterminating_orbit : ∃ n, Diverges n :
  ```
]

もちろん#footnote[この講演が行われた当時は少なくとも]このような上手い話があるわけがなく，これはLeanの*ソフトウェアとしての*実装のバグに由来するものであった（詳しい解説は @dM260801）．

甚大な量のLeanによる形式証明のソースコードの中にこのような秘孔が混じっている可能性はある．
これに関しては @sect:perspesctive_software でも論ずる．

#pagebreak()

ひとくちに定理証明支援系を使うと言っても，次のことに目を向けるべきだと感じる #footnote[この基準は @Alwe260929 のツイートから拝借した．]．

#remark[定理証明支援系による正しさの公準][
  定理証明支援系が/の/で．．．
  1. 依拠している数学的基礎に問題や矛盾が無いか？*（論理学者として）*
  2. ソフトウェアとしての実装にバグが存在しないか？*（ソフトウェア開発者として）*
  3. 形式化したそのコードは命題を正しく形式化しているか？*（エンドユーザとして）*
]

= 1階述語論理および不完全性定理

== 言葉遣いについて

#remark[
  _formalize_ という語の意図を以下で使い分ける．

  / formalize (形式化): 数理論理学の技法として数学的議論を形式操作だと思って展開する．
  / mechanize (機械化): 定理証明支援系によって数学をプログラムによって実装する．

  我々がやったことの端的な説明：*数学の形式化の機械化*！
]

== 不完全性定理

次のGödelの不完全性定理の素朴なバージョンを機械化した．

#theorem(numbering: none)[Gödelの第1不完全性定理(G1)][
  $T$ がCobhamの最弱の算術 $R0$ を含み，$Delta_1$-定義可能 #footnote[$T$の公理を記述する論理式が $Delta_1$-論理式で記述出来る] で，$Sigma_1$-健全なら，$T$ から証明も反証も出来ない論理式が存在する．
]

#theorem(numbering: none)[Gödelの第2不完全性定理(G2)][
  $T$ が $ISigma1$ より強く無矛盾なら，$T$ の無矛盾性を表す文は証明できない．
]

いくつかの条件は改良できる(後述)．

#leancode(links: (
  ("Foundation", "Foundation/FirstOrder/Incompleteness/First.lean"),
  ("Foundation", "Foundation/FirstOrder/Incompleteness/Second.lean"),
))[
  ```lean
  theorem incomplete (T : ArithmeticTheory) [T.Δ₁] [𝗥₀ ⪯ T] [T.SoundOnHierarchy 𝚺 1] : Incomplete T

  theorem consistent_unprovable [Consistent T] : T ⊬ T.consistent.val
  ```
]


== 論理式

論理式 (疑論理式) は否定標準形で扱う．`L` は言語，型 `ξ` を自由変数，束縛変数はde Bruijnインデックスによって自然数 `ℕ` で扱うこととする．

$ phi, psi ::= top | bot | R(arrow(v)) | not R(arrow(v)) | phi and psi | phi or psi | forall phi | exists phi $

#leancode(links: (("Foundation", "Foundation/FirstOrder/Syntax/Classical/Formula.lean"),))[
  ```lean
    inductive Semiformula (L : Language) (ξ : Type*) : ℕ → Type _ where
    |  verum : Semiformula L ξ n
    | falsum : Semiformula L ξ n
    |    rel : {arity : ℕ} → L.Rel arity → (Fin arity → Semiterm L ξ n) → Semiformula L ξ n
    |   nrel : {arity : ℕ} → L.Rel arity → (Fin arity → Semiterm L ξ n) → Semiformula L ξ n
    |    and : Semiformula L ξ n → Semiformula L ξ n → Semiformula L ξ n
    |     or : Semiformula L ξ n → Semiformula L ξ n → Semiformula L ξ n
    |    all : Semiformula L ξ (n + 1) → Semiformula L ξ n
    |    exs : Semiformula L ξ (n + 1) → Semiformula L ξ n
  ```
]

- `Formula L ξ` を `Semiformula L ξ 0` の略記（束縛変数無し）
- `Semisentence L 0` を `Semiformula L Empty n` の略記（自由変数無し）
- `Sentence L` を `Formula L Empty` の略記（自由・束縛変数無し）

#pagebreak()

算術の言語 $LOR$ を定めて，Leanのマクロによる糖衣構文を用意する．
例えばこんな感じで記述出来る．

== 証明体系

古典1階述語論理のTait流のシークエント計算体系 #LK を用意する．シークエントは多重集合として定義する．

#align(center)[
  #text(size: 0.9em)[
    #table(
      columns: 5,
      align: center + horizon,
      stroke: none,
      inset: 0.25em,
      prooftree(rule(name: `id`, $R(arrow(v)), not R(arrow(v)), Delta$)),
      prooftree(rule(name: `verum`, $top, Delta$)),
      prooftree(rule(name: [`wk` #footnote[$Gamma subset.eq Delta$]], $Gamma$, $Delta$)),
      prooftree(rule(name: [`ctr`], $Gamma, phi, phi$, $Gamma, phi$)),
      prooftree(rule(name: `cut`, $phi, Delta$, $not phi, Delta$, $Delta$)),

      prooftree(rule(name: `or`, $phi, psi, Delta$, $phi or psi, Delta$)),
      prooftree(rule(name: `and`, $phi, Delta$, $psi, Delta$, $phi and psi, Delta$)),
      prooftree(
        rule(
          name: [`all`#footnote[ここでは自由変数を $\&0, \&1, ...$ と表記する．また $phi^+, Gamma^+$ はそれぞれに含まれる自由変数をインクリメントしたもの]],
          $phi^+(\&0), Delta^+$,
          $forall phi, Delta$,
        ),
      ),
      prooftree(rule(name: `ex`, $phi(t), Delta$, $exists phi, Delta$)),
    )]
]


#leancode(links: (("Foundation", "Foundation/FirstOrder/LK/Basic.lean"),), size: 0.7em)[
  ```lean
  inductive LK.Derivation : LK.Sequent L → Type _
  | identity (r : L.Rel k) (v) : LK.Derivation ⦃.rel r v, .nrel r v⦄
  | verum : LK.Derivation ⦃⊤⦄
  | weakening : LK.Derivation Γ → LK.Derivation (Γ + ⦃φ⦄)
  | contraction : LK.Derivation (Γ + ⦃φ, φ⦄) → LK.Derivation (Γ + ⦃φ⦄)
  | cut : LK.Derivation (Γ + ⦃φ⦄) → LK.Derivation (Δ + ⦃∼φ⦄) → LK.Derivation (Γ + Δ)
  | or : LK.Derivation (Γ + ⦃φ, ψ⦄) → LK.Derivation (Γ + ⦃φ ⋎ ψ⦄)
  | and : LK.Derivation (Γ + ⦃φ⦄) → LK.Derivation (Γ + ⦃ψ⦄) → LK.Derivation (Γ + ⦃φ ⋏ ψ⦄)
  | all : LK.Derivation (Γ⁺ + ⦃φ.free⦄) → LK.Derivation (Γ + ⦃∀¹ φ⦄)
  | exs : LK.Derivation (Γ + ⦃φ/[t]⦄) → LK.Derivation (Γ + ⦃∃¹ φ⦄)
  ```
]

#pagebreak()

カット無しの証明図へ変換する具体的な計算手続きを定める #footnote[証明図の帰納法による愚直な証明は機械化において煩雑で面倒なので，@Avi01 @Avi04 による直観主義述語論理への還元および強制法的な議論による．]ことで，#LK ではカット除去定理を機械化出来る #footnote[ただしこれが現実的にLeanで計算可能なのかはわからない．]．

#leancode(links: (("Foundation", "Foundation/FirstOrder/LK/Hauptsatz.lean"),))[
  ```lean
  def hauptsatz {Γ : LK.Sequent L} : ⊢ᴸᴷ¹ Γ → {d : ⊢ᴸᴷ¹ Γ // LK.Derivation.IsCutFree d}
  ```
]

言語 $L$ の理論 $T$ を $L$-文の集合 `Set (Sentence L)` とする．

- $phi$ が $T$ から導出できることを $T proves phi$ と書く．
- $T$ を満たす任意のモデル $M$ で $phi$ も満たされるとき，$T models phi$ と書く．

カット除去定理からカノニカルモデルを作るなどの議論を行って，完全性定理を得る．

#leancode(links: (("Foundation", "Foundation/FirstOrder/LK/Completeness/CounterModel.lean"),))[
  ```lean
  theorem small_satisfiable_of_consistent : Consistent T → Satisfiable T

  theorem Proof.complete_iff : T ⊨ φ ↔ T ⊢ φ := ⟨fun h ↦ Proof.complete h, Proof.sound⟩
  ```
]

== 算術

以降，言語 #LOR (`ℒₒᵣ`) の理論を算術と呼ぶ．

== 算術的階層について

*ここについての扱いは現在改修中．*

現れる量化子が限定量化であるような論理式は $Delta_0$-論理式と呼ぶ．

*実用的な問題のため*，論理式が $Sigma_1$ や $Pi_1$ であるとは限定量化を途中に挟んでもよく，またBoolean結合で閉じているものとする．例えば以下も $Sigma_1$-論理式である．

$
  exists x, forall y < t, exists z. phi(x, y, z) and forall x < t. psi(x)
$

一方で，帰納法のクラスなどを $Sigma_n$ や $Pi_n$ で制限するときは冠頭標準形に制限する．
$
  exists forall exists forall ... phi(x_1, x_2, ..., x_n, arrow(y))
$

冠頭標準形定理および採集原理などがあればこれらの区別は厳密にする必要はないが，機械化ではこのような細かい議論や定義も必要になる．

== 完全性定理の意義

$T proves phi$ であることを（特にLeanで機械化するには）実際に証明図を構成しなければならないが，それは人力では現実的ではない．

完全性定理を機械化することで以下の還元が使える．

$
  Lean proves \"T proves phi\" <==> Lean proves \"forall V, V models T ==> V models phi\"
$

意味論的な議論においては，例えば $T$ が十分に豊かな算術であるなら $T models V$ を満たす $V$ が良い代数的な構造になる．
Mathlibなどが提供する代数的な構造に対しての様々な補題やメタプログラミング，自動証明タクティクが利用出来る．
これを戻して $T proves phi$ を簡単に示せる．

#pagebreak()

算術 $T$ の任意のモデル $V$ を固定する．

#leancode[
  ```lean
    variable {V : Type*} [ORingStruc V] [V ⊧ₘ* T]
  ```
]

- `ORingStruc V`: $V$ が言語 $cal(L)_"OR"$ の構造であることを主張するtypeclass.
- `V ⊧ₘ* T`: $V$ が理論 $T$ を満たすことを主張するtypeclass.

$V$ 上で機械化を行う．関数は選択関数を用いて定義出来る．

#leancode[
  ```lean
    lemma sqrt_exists_unique (a : V) : ∃! x, x * x ≤ a ∧ a < (x + 1) * (x + 1)

    def sqrt (a : V) : V := Classical.choose! (sqrt_exists_unique a)
    prefix:75 "√" => sqrt

    lemma sqrt_mul_self (a : V) : √(a * a) = a
  ```
]

== メタ数学の算術化

形式体系を算術の中でさらに形式化する#footnote[Formalizing \[Formalizing \[Formalizing mathematics in formal system\] in Arithmetic\] in Lean]：*算術化・Bootstraping*．

- 論理式 $phi$ や導出木 $D$ に対して $V$ への割り当て $godelize(dot)$ を割り当てる（*Gödel数*）．
- 逆に $V$ の要素 $x$ が項，論理式，導出木のGödel数であるというメタの（Lean上の）述語 $upright("IsFormula")(x) : V mapsto 2$ などを考える．

メタの述語 $upright("IsFormula")(x)$ に対応する $LOR$-論理式 $sans("IsFormula")(godelize(phi))$ などを $Delta_0, Sigma_n, Pi_n$ の適当な階層で*ひたすら頑張って*構成していく．

$
  V models upright("IsFormula")(godelize(phi)) <==> T proves sans("IsFormula")(godelize(phi))
$

== $R0$ の表現定理


$R0$ では表現定理が成り立つ #footnote[もちろんRobinson算術 や $PA$ でも成り立つが，$R0$ は表現定理が成り立つよく知られている算術理論の中では最弱とされる．]．

#theorem[$R0$ の表現定理][
  $Sigma_1$-健全な $T supset.eq R0$ と，$S$ をr.e.集合とする．
  このとき，$LOR$-論理式 $Rep(S)(x)$ があって以下を満たす．
  $
    n in S <==> T proves Rep(S)(num(n))
  $
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Arithmetic/R0/Representation.lean"),))[
  ```lean
  noncomputable def codeOfREPred (p : ℕ → Prop) : ArithmeticSemisentence 1

  theorem rePred_weak_representation {p : ℕ → Prop} (hp : REPred p) {x : ℕ} :
      p x ↔ T ⊢ (codeOfREPred p)/[x]
  ```
]

== 第1不完全性定理

表現定理および算術化を用いて，Gödelの第1不完全性定理(G1)をまず形式化出来る．

#theorem[G1][
  $T$ がCobhamの最弱の算術 $R0$ を含み，$Delta_1$-定義可能で，$Sigma_1$-健全なら，$T$ から証明も反証も出来ない文が存在する．
]

#proof[
  $D := { godelize(phi) : #text[$phi$ は1変数論理式かつ $T proves not phi(godelize(phi))$] }$ を取ると，これはr.e.なので $theta(x)$ が存在して $n in D <==> T proves theta(num(n))$．以下の同値性が成立する．
  $
    T proves theta(godelize(theta)) <==> godelize(theta) in D <==> T proves not theta(godelize(theta))
  $
  ゆえに $T$ が完全なら無矛盾性に反する．
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Incompleteness/First.lean"),))[
  ```lean
  theorem incomplete (T : ArithmeticTheory) [T.Δ₁] [𝗥₀ ⪯ T] [T.SoundOnHierarchy 𝚺 1] : Incomplete T
  ```
]

ここで `Incomplete T` は `∃ φ, T ⊬ φ ∧ T ⊬ ∼φ` の略記．

== 証明可能性の抽象化

生の証明可能性述語を機械化で直接扱うと面倒なので，抽象化を導入する．

#definition[証明可能性][
  1変数述語 $Bew$ が *$T_0$ 上の $T$-証明可能性 である*とは， $D1: T proves sigma ==> T_0 proves Bew sigma$ を任意の文 $sigma$ で満たすこととする．
  追加条件として以下を満たすとき，*HBLである* #footnote[Hilbert-Bernays-Löb．] という．
  - $D2: T_0 proves Bew(sigma → tau) → (Bew sigma → Bew tau)$
  - $D3: T_0 proves Bew sigma → Bew(Bew sigma)$
]

#leancode(
  links: (("Foundation", "Foundation/FirstOrder/Incompleteness/ProvabilityAbstraction/Basic.lean"),),
)[
  ```lean
  structure Provability (T₀ : Theory L₀) (T : Theory L) where
    prov : Semisentence L₀ 1
    bew_def {σ : Sentence L} : T ⊢ σ → T₀ ⊢ prov/[⌜σ⌝]

  class HBL where
    D2 {σ τ : Sentence L} : T₀ ⊢ 𝔅 (σ 🡒 τ) 🡒 𝔅 σ 🡒 𝔅 τ
    D3 {σ : Sentence L} : T₀ ⊢ 𝔅 σ 🡒 𝔅 (𝔅 σ)
  ```
]

#pagebreak()

#definition[対角化可能性][
  *$T$ が対角化可能*とは，1変数述語 $theta$ を入力とし文 $upright("fixpoint")_theta$ を返す関数があって，それは以下を満たす．
  $
    T proves upright("fixpoint")_theta <-> theta(godelize(upright("fixpoint")_theta))
  $
]

#leancode(links: (
  ("Foundation", "Foundation/FirstOrder/Incompleteness/ProvabilityAbstraction/Basic.lean"),
  ("Foundation", "Foundation/FirstOrder/Arithmetic/Bootstrapping/FixedPoint.lean"),
))[
  ```lean
  class Diagonalization [L.ReferenceableBy L] (T : Theory L) where
    fixedpoint : Semisentence L 1 → Sentence L
    diag (θ) : T ⊢ fixedpoint θ 🡘 θ/[⌜fixedpoint θ⌝]

  theorem diagonal (θ : ArithmeticSemisentence 1) :
      T ⊢ fixedpoint θ 🡘 θ/[⌜fixedpoint θ⌝]
  ```
]

#pagebreak()

#definition[
  - 無矛盾性を表す文 $not Bew bot$：「矛盾は証明できない」を $upright("Con")_Bew$ とする．
  - $not Bew(dot.c)$ の不動点をGödel文 $upright("G")_Bew$ とする．
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Incompleteness/ProvabilityAbstraction/Basic.lean"),))[
  ```lean
  def con (𝔅 : Provability T₀ T) : Sentence L₀ := ∼𝔅 ⊥

  def gödel (𝔅 : Provability T₀ T) : Sentence L := fixedpoint T₀ “x. ¬!𝔅.prov x”

  lemma gödel_spec : T₀ ⊢ (gödel 𝔅) 🡘 ∼𝔅 (gödel 𝔅)
  ```
]

#pagebreak()

#lemma[Abstract G1, G2, Löb][
  $T$ が対角化可能で，$Bew$ はHBLを満たすとする．
  / G1: $T nproves upright("G")_Bew$
  / G2: $T nproves upright("Con")_Bew$
  / Löb: $T proves Bew sigma -> sigma$ なら $T proves sigma$
  / F-Löb: $T proves Bew (Bew sigma -> sigma) -> Bew sigma$
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Incompleteness/ProvabilityAbstraction/Basic.lean"),))[
  ```lean
  theorem unprovable_gödel : T ⊬ (gödel 𝔅)

  theorem con_unprovable [Consistent T] : T ⊬ 𝔅.con

  theorem löb_theorem (H : T ⊢ 𝔅 σ 🡒 σ) : T ⊢ σ

  theorem formalized_löb_theorem : T₀ ⊢ 𝔅 (𝔅 σ 🡒 σ) 🡒 𝔅 σ
  ```
]

== 第2不完全性定理

算術化を頑張るとHBLを満たす証明可能性を実際に構成に構成することができる．
- 今後この標準的な証明可能性は $box_T$ と書く．
また，対角可能性も実際満たす．
故に系として，第2不完全性定理やLöbの定理を機械化出来る．


#theorem[Gödelの第2不完全性定理][
  $T$ が $ISigma1$ より強く無矛盾なら，$T$ の無矛盾性を表す文 $not box_T bot$ は証明できない．
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Incompleteness/Second.lean"),))[
  ```lean
  theorem consistent_unprovable [Consistent T] : T ⊬ T.consistent.val
  ```
]

#pagebreak()

#theorem[Löbの定理][
  $T proves box_T sigma → sigma$ なら $T proves sigma$
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Incompleteness/Löb.lean"),))[
  ```lean
  theorem löb_theorem : T ⊢ provabilityPred T σ 🡒 σ → T ⊢ σ

  theorem formalized_löb_theorem :
      𝗜𝚺₁ ⊢ provabilityPred T (provabilityPred T σ 🡒 σ) 🡒 provabilityPred T σ
  ```
]

$T$ としてPeano算術 $PA$ を取ることが出来る．

== 抽象化の利点

== 不完全性定理やその他いろんな系

各詳細は @SN26 を読んでください（*いくつかは次の版で追加予定*）．

- Tarskiの真理定義不可能性定理．
- Churchの一階述語論理の決定不可能性．
- 「Gödel数が $n$ 以下の証明で証明できる」証明可能性述語について #footnote[この否定の不動点「Gödel数が $n$ 未満の証明では証明できない」は $NN$ 上で正しいし，実際に $n$ 未満の証明で証明できない．故に $n$ を途方もなく大きく取ればそれは正しいが現実的な証明を持たない命題とも言える．]．
- Ehrenfeucht-Mycielskiの加速定理．
- Craigのトリック．
- Friedman-–Goldfarb–-Harrington定理（FGH定理） #footnote[$ISigma1 + Con(T)$ 上では任意の $Sigma_1$-文は何らかの $sigma$ に対し $box_T sigma$ と同値．]．
- 第一不完全性定理が成立する理論のLindenbaum代数は全て同型．
- $upright("I")Sigma_n$: $n >= 1$ は有限公理化可能．
- $PA$ は有限公理化不能（Ryll-Nardzewskiの定理）．

== 算術理論の動物園

#align(center, zoo-arithmetic())

全部strictだがそこまで出来てない．．．#footnote[
  簡単な説明：
  - $ISigma1^+$ は今回の緩い $Sigma_1$ 論理式に対しての帰納法原理を追加した体系．
  - $upright("B"Sigma_1)$ は $Sigma_1$-論理式に対しての採集原理．
  - $upright("L"Sigma_1)$ は $Sigma_1$-論理式に対しての最小値原理．
]

= 証明可能性論理

== はじめに

証明可能性論理の簡単な説明・モチベーション #footnote[証明可能性論理の標準的な文献として @Boo94 @Smo85 @AB05 @Ver24．]
- 不完全性定理において中心的な役割を果たす証明可能性述語*「$phi$ は $T$ で証明できる」*を様相だと思おう．
- 証明可能性 $Bew$ をより様相論理的に扱う．

最重要の定理: *Solovayの算術的完全性定理．*


#proposition(numbering: none)[Solovayの算術的完全性定理(ラフ)][
  HBLな $Bew$ の挙動は様相命題論理 $LogicGL$ で完全に特徴づけられる．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/GL/Arithmetic.lean"),))[
  ```lean
  theorem arithmetical_completeness_iff [T.SoundOnHierarchy 𝚺 1] :
      𝐆𝐋 ⊢ A ↔ ∀ f : Realization α ℒₒᵣ, T ⊢ f T A

  theorem eq_provabilityLogic [T.SoundOnHierarchy 𝚺 1] : 𝐆𝐋 = T.provabilityLogic (α := α)
  ```
]


== 様相論理 $LogicGL$ の定義

論理式は $bot, ->, box$ を原始的な記号として導入し，あとは略記．

論理式の集合を論理と呼ぶ．

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/Formula.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/Logic.lean"),
  ),
)[
  ```lean
  inductive Formula (α : Type*) where
    | atom   : α → Formula α
    | falsum : Formula α
    | imp    : Formula α → Formula α → Formula α
    | box    : Formula α → Formula α
    deriving DecidableEq

  abbrev Logic (α : Type*) := Set (Formula α)
  ```
]

#pagebreak()

#let Nec = $Rule("Nec")$

#definition[
  論理 $LogicGL$ は古典命題論理に以下の公理と規則を足したもの．
  - 規則 $Nec : proves A ==> proves box A$
  - 公理 $AxiomK : box (A -> B) -> box A -> box B$
  - 公理 $Axiom4 : box A -> box box A$
  - 公理 $AxiomL : box (box A -> A) -> box A$
]

証明可能性 $Bew$ のHBLおよびF-Loebと以下で対応する．
- 規則 $Nec$ が #D1
- 公理 $AxiomK$ が #D2
- 公理 $Axiom4$ が #D3
- 公理 $AxiomL$ が F-Loeb

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/Logic.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/GL/Basic.lean"),
  ),
)[
  ```lean
  inductive Logic.normalOf (𝔸 : Set (Formula α)) : Logic α
    | axm {A}        : A ∈ 𝔸 → normalOf 𝔸 A
    | mdp {A B}      : normalOf 𝔸 (A 🡒 B) → normalOf 𝔸 A → normalOf 𝔸 B
    | nec {A}        : normalOf 𝔸 A → normalOf 𝔸 (□A)
    | verum          : normalOf 𝔸 Axioms.Verum
    | implyK {A B}   : normalOf 𝔸 (Axioms.ImplyK A B)
    | implyS {A B C} : normalOf 𝔸 (Axioms.ImplyS A B C)
    | ...
    | dne {A}        : normalOf 𝔸 (Axioms.DNE A)
    | axiomK {A B}   : normalOf 𝔸 (□(A 🡒 B) 🡒 □A 🡒 □B)

  abbrev Logic.GL {α : Type*} : Logic α :=
    normalOf ({□A 🡒 □□A | A} ∪ {□(□A 🡒 A) 🡒 □A | A})
  ```
]

== Kripke意味論

実用上はフレームのみを考えることは殆どないので，モデルだけを考えたほうが実装がスッキリする．

#definition[Kripkeモデル][
  非空集合 $W$ とその上の2項関係 $prec : W times W -> 2$，付値関数 $V : W times PropVer -> 2$ の組 $chevron.l W, prec, V chevron.r$ をKripkeモデルという．強制関係(Forces)を以下で定める．

  - $x forces p <==> x V p$．
  - $x forces box A <==> forall y, x prec y -> y forces A$．
]

Leanでは，型 `κ` 上の構造として定義する．#footnote[universeを自由にすることが出来ることは完全性定理などでそれなりに問題になるが，無視する．]

#pagebreak()

Leanでは次のように定義する．

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Kripke/Basic.lean"),))[
  ```lean
  structure Model (κ : Type*) [Nonempty κ] (α : Type*) where
    Rel' : κ → κ → Prop
    Val' : κ → α → Prop

  abbrev World (_ : Model κ α) := κ

  abbrev Rel {M : Model κ α} : M.World → M.World → Prop := M.Rel'
  scoped infix:60 " ≺ " => Rel

  abbrev Val {M : Model κ α} : M.World → α → Prop := M.Val'

  def Forces (M : Model κ α) (x : M.World) : Formula α → Prop
    | #a    => M x a
    | ⊥     => False
    | A 🡒 B => Forces M x A → Forces M x B
    | □A    => ∀ y, x ≺ y → Forces M y A

  scoped notation:55 x:56 " ⊩[" M "] " A:56 => Forces M x A
  ```
]

#pagebreak()

#definition[
  - *$LogicGL$-モデル*とは $prec$ が推移的で逆整礎的：$x_1 prec x_2 prec dots prec x_n$ が有限の $n$ 回遷移しか出来ないとする．
    - 故に $LogicGL$-モデルには点 $x$ から最大何回遷移できるか：*ランク $rank(x)$* が定まる #footnote[技術的な面倒のため，Leanでの実装では有限モデルのみに対して定めている．]．
  - *有限 $LogicGL$-モデル*とは $W$ が有限で $prec$ が推移的で非反射的なモデルとする．
  - モデルが*根付き*とは根 $r_M$ があって任意の $x in M setminus {r_M}$ に対し $r_M prec x$．
    - 根付きモデルの高さとは $rank(r_M)$ とする．
]

#pagebreak()

Leanでは次のように定義する．

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/Kripke/Basic.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/Kripke/RootedModel.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/Kripke/Rank.lean"),
  ),
)[
  ```lean
  class IsGL (M : Model κ α) extends IsTrans _ M.Rel, IsConverseWellFounded _ M.Rel

  class IsFiniteGL (M : Model κ α) extends IsTrans _ M.Rel, Std.Irrefl M.Rel where
    [finite : Finite M.World]

  noncomputable def World.rank (x : M.World) : ℕ := cwfHeight (· ≺ ·) x

  structure RootedModel (κ : Type*) [Nonempty κ] (α : Type*) extends Model κ α where
    root : toModel.World
    root_rel : ∀ x, x ≠ root → root ≺ x

  noncomputable def RootedModel.height (M : RootedModel κ α) [Fintype M.World] [M.IsGL] : ℕ :=
    Model.World.rank (M := M.toModel) M.root
  ```
]



#pagebreak()

*余談:*

もちろん様相論理一般の議論ではモデルとフレームの区別は非常に重要なのだが，今回は一般論をしたいわけではないので無視する．

- あくまでも算術を分析するための道具として割り切って実装する．
- 定理証明支援系で何を実装して何を実装しないか．．．
- *道具としての様相論理！*

== 様相論理 $LogicGL$ のシークエント計算

@SV82 の $LogicGL$ のシークエント計算を機械化する．
Kripke意味論の完全性はこちらのほうがはるかに簡単に証明がスッキリする #footnote[$LogicGL$ は標準的な様相論理のカノニカルモデルの構成による証明は不可能．有限判例モデルを直接作るか，適当にモデルを同値で割って証明する．Hilbert流だと細かい部分の計算が煩雑になる．]．

#definition[
  *シークエント* $Gamma => Delta$ とは論理式の有限集合の組である．
  $LogicGL$ のシークエント計算 $GentzenGL$ は次の規則からなる．
  ただし (WL) と (WR) では $Gamma subset.eq Gamma'$，$Delta subset.eq Delta'$ とする．

  #align(center)[
    #text(size: 0.9em)[
      #grid(
        columns: 4,
        column-gutter: 2em,
        row-gutter: 1em,
        align: center + horizon,
        prooftree(rule(name: [(Ax)], $A => A$)),
        prooftree(rule(name: [($bot$L)], $bot =>$)),
        prooftree(rule(name: [(WL)], $Gamma => Delta$, $Gamma' => Delta$)),
        prooftree(rule(name: [(WR)], $Gamma => Delta$, $Gamma => Delta'$)),
        prooftree(rule(
          name: [($->$L)],
          $Gamma => A, Delta$,
          $B, Gamma => Delta$,
          $A -> B, Gamma => Delta$,
        )),
        prooftree(rule(name: [($->$R)], $A, Gamma => B, Delta$, $Gamma => A -> B, Delta$)),
        grid.cell(colspan: 2, prooftree(rule(
          name: [($box_LogicGL$)],
          $box A, Gamma, box Gamma => A$,
          $box Gamma => box A$,
        ))),
      )
    ]
  ]
]

#pagebreak()

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/Sequent.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/GL/Gentzen/Basic.lean"),
  ),
)[
  ```lean
  structure Sequent (α : Type*) where
    ant : FormulaFinset α
    suc : FormulaFinset α

  infix:50 " ⟹ " => Sequent.mk

  inductive Gentzen : Sequent α → Prop
    | axm (A) : Gentzen ({A} ⟹ {A})
    | botL : Gentzen ({⊥} ⟹ ∅)
    | wkL {Γ Γ' Δ} : Gentzen (Γ ⟹ Δ) → (_ : Γ ⊆ Γ' := by grind) → Gentzen (Γ' ⟹ Δ)
    | wkR {Γ Δ Δ'} : Gentzen (Γ ⟹ Δ) → (_ : Δ ⊆ Δ' := by grind) → Gentzen (Γ ⟹ Δ')
    | impL {Γ Δ A B} :
      Gentzen (Γ ⟹ insert A Δ) → Gentzen (insert B Γ ⟹ Δ) → Gentzen (insert (A 🡒 B) Γ ⟹ Δ)
    | impR {Γ Δ A B} : Gentzen (insert A Γ ⟹ insert B Δ) → Gentzen (Γ ⟹ insert (A 🡒 B) Δ)
    | boxGL {Γ A} : Gentzen (insert (□A) (Γ ∪ Γ.box) ⟹ {A}) → Gentzen (Γ.box ⟹ {□A})

  notation:45 "⊢ᴳ[𝐆𝐋] " S:50 => Gentzen S
  ```
]

#pagebreak()

#theorem[#GentzenGL の完全性定理][
  $GentzenGL proves Gamma => Delta$ と任意の有限 $LogicGL$-モデル $M$ で $M models and.big Gamma -> or.big Delta$ であることは同値．
]

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/GL/Gentzen/Kripke.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/Kripke/Basic.lean"),
  ),
)[
  ```lean
  def Model.World.ForcesSequent (M : Model κ α) (x : M.World) (S : Sequent α) : Prop :=
    (∀ C ∈ S.ant, x ⊩ C) → ∃ D ∈ S.suc, x ⊩ D

  def Model.ValidateSequent (M : Model κ α) (S : Sequent α) : Prop := ∀ x : M.World, x ⊩ S

  lemma GL.Gentzen.iff_valid : ⊢ᴳ[𝐆𝐋] S ↔
      ∀ {κ : Type u} [Nonempty κ] (M : Kripke.Model κ α), [M.IsFiniteGL] → M ⊧ S
  ```
]

#pagebreak()

完全性定理から意味論的カット除去定理（カット許容）であることがすぐに従う．

#theorem[#GentzenGL のカット除去定理][
  カット規則は #GentzenGL で許容される．
  #align(center)[
    #prooftree(rule(
      name: [(Cut)],
      $Gamma_1 => Delta_1, A$,
      $A, Gamma_2 => Delta_2$,
      $Gamma_1, Gamma_2 => Delta_1, Delta_2$,
    ))
  ]
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/GL/Gentzen/Kripke.lean"),))[
  ```lean
  theorem GL.Gentzen.cut (h₁ : ⊢ᴳ[𝐆𝐋] Γ₁ ⟹ insert A Δ₁) (h₂ : ⊢ᴳ[𝐆𝐋] insert A Γ₂ ⟹ Δ₂) :
      ⊢ᴳ[𝐆𝐋] Γ₁ ∪ Γ₂ ⟹ Δ₁ ∪ Δ₂
  ```
]

#pagebreak()

あとは頑張ればHilbert流と対応することがわかる．故に次の同値が言える．

#theorem[
  以下同値．$A$ は論理式．
  1. $LogicGL proves A$
  2. $cal(G)_LogicGL proves => A$
  3. 任意の有限 $LogicGL$-モデルで $A$ は妥当．
  4. 任意の有限 $LogicGL$-モデルの根で $A$ は充足される．
  5. 任意の有限 $LogicGL$-木モデルの根で $A$ は充足される．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/GL/Basic.lean"),))[
  ```lean
  theorem Logic.GL.provability_TFAE : [
      𝐆𝐋 ⊢ A,
      ⊢ᴳ[𝐆𝐋] ∅ ⟹ {A},
      ∀ {κ : Type u} [Nonempty κ] (M : Model κ α), [M.IsFiniteGL] → M ⊧ A,
      ∀ {κ : Type u} [Nonempty κ] (M : RootedModel κ α), [M.IsFiniteGL] → M.root ⊩ A,
      ∀ {κ : Type u} [Nonempty κ] (M : RootedModel κ α), [M.IsFiniteGL] → [M.IsTree] →
        M.root ⊩ A
    ].TFAE
  ```
]

== 様相論理 $LogicGL$ のシークエント計算の余談: 構文論的カット除去

今回は我々の関心外であるためカット除去は意味論的に行ったが，構文論的なカット除去も可能である．

シークエントが有限集合ではなくリストや多重集合である場合の構文論的なカット除去は本当に帰納法が回っていたのか最近まで不明であった．（@GR12 で*3重帰納法*によって示される．）
@Bri16 が新しい方法を提案していて，それがうまくいくということは @GRS21 がRocqで検証している．

== 様相論理 $LogicGL$ のシークエント計算の余談: 自動証明

シークエントを集合で定義しているため，例えばweakeningやcontractionをどのタイミングで行うかは決定的ではなく，*（Leanにおいて）現実的に*証明探索は出来ない #footnote[多分多重集合であったとしてもLeanでは決定的に証明できないと思う．リストなら出来る気もするが，あまりにも面倒な実装になると思う．]．

例えば，@MPB23 はラベル付きシークエント計算体系をHOL/Lightで実装し， `GL_provable` のような論理式が $LogicGL$ で証明できるか判定するタクティクを定義している．

- ただし，このタクティクが必ず停止することはHOL/Lightの中では証明されていない．数学的に停止するというメタの保証 @Neg05 に依存して実装されている．（つまり実装が間違っていたら永遠に止まらないという可能性はある．）
- 一応我々はラベル付きシークエント計算も実装して停止性も機械化したが．．．

#pagebreak()

そもそも機械化の上では命題変数 $p, q$ として $p -> box q$ ではなく，メタの論理式変数 $A, B$ として $A -> box B$ は証明可能か？と要請されることがほとんどのため，これらのタクティクはそこまで役に立たなかった．

実用的には，Kripke意味論で一旦健全・完全性を使って証明出来る・出来ないを示せば良く，それでも別にある程度自動化できたりするので十分．

== 様相論理 $LogicGL$ のシークエント計算の余談: 補間定理と不動点定理

@SV82 ではさらにシークエント計算を使った応用として， $LogicGL$ のCraig補間定理と不動点補題を示している．
$LogicGL$ の導出木を手作りすれば補間と不動点は構成的に計算できる(Maeharaの方法) #footnote[ただし殆どの場合そんなことはしなくて完全性から作るので意義はない．] #footnote[@Gig26 もLeanで補間性定理などを示しているが，意味論的な制約により特殊なケースのみになっている．シークエント計算から一般に構成出来るというのはそれなりに利点に思える．]．

#theorem[$LogicGL$ のCraig補間性][
  $LogicGL proves A -> B$ ならば，論理式 $C$ で $LogicGL proves A -> C$ かつ $LogicGL proves C -> B$ であり，$C$ の命題変数がすべて $A$ と $B$ の両方に現れるものが存在する．
]

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/GL/CIP.lean"),
    ("Foundation", "Foundation/ProvabilityLogic/GL/Gentzen/Maehara.lean"),
  ),
)[
  ```lean
  theorem Logic.GL.CIP (h : 𝐆𝐋 ⊢ A 🡒 B) :
      ∃ C, 𝐆𝐋 ⊢ A 🡒 C ∧ 𝐆𝐋 ⊢ C 🡒 B ∧ C.atoms ⊆ A.atoms ∩ B.atoms
  ```
]

#pagebreak()

重要な系として，$LogicGL$ の補間定理から不動点定理も従う．

#definition[
  命題変数 $p$ が論理式 $A$ で *modalized* であるとは，$A$ に現れる $p$ がすべて $box$ のスコープの中にあることをいう．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Formula.lean"),))[
  ```lean
  def ModalizedIn (p : α) : Formula α → Prop
    | #a    => a ≠ p
    | ⊥     => True
    | A 🡒 B => A.ModalizedIn p ∧ B.ModalizedIn p
    | □_    => True
  ```
]

#theorem[$LogicGL$ の不動点定理 @SV82][
  $p$ が $A$ で modalized ならば，$p$ を含まず $A$ の命題変数のみからなる論理式 $D$ で
  $ LogicGL proves A[p := D] <-> D $
  を満たすものが存在する．
  さらに不動点は証明可能同値を除いて一意である：$LogicGL proves A[p := E] <-> E$ なる任意の論理式 $E$ について $LogicGL proves D <-> E$．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/GL/Fixedpoint.lean"),))[
  ```lean
  theorem Logic.GL.fixpoint_theorem (hpq : p ≠ q) (hA : A.ModalizedIn p) (hq : q ∉ A.atoms) :
      ∃ D, D.atoms ⊆ A.atoms.erase p ∧ 𝐆𝐋 ⊢ A⟦p ↦ D⟧ 🡘 D ∧
        ∀ E, 𝐆𝐋 ⊢ A⟦p ↦ E⟧ 🡘 E → 𝐆𝐋 ⊢ D 🡘 E
  ```
]

== 証明可能性論理

$LogicGL$ の $box$ と証明可能性 $Bew$ を結びつけよう．

#definition[
  $f$ を様相論理の命題変数から算術の文への写像とし*実現(realization)*と呼ぶ．
  $f$ による様相論理 $A$ の *$Bew$-解釈 $f_Bew (A)$* を以下で定める．
  - $f_Bew (p) = f(p)$
  - $f_Bew (bot) = bot$
  - $f_Bew (A -> B) = f_Bew (A) -> f_Bew (B)$
  - $f_Bew (box A) = Bew f_Bew(A)$
]

ただし今後は標準的な証明可能性述語 $box_T$ だけで議論するので $f_(box_T)(A)$ のみ考える．

#pagebreak()

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Arithmetic/Interpret.lean"),))[
  ```lean
  structure Realization (α : Type*) (L : Language) where
    val : α → Sentence L

  def interpret (f : Realization α L) (𝔅 : Provability T₀ T) : Formula α → Sentence L
    | #a    => f.val a
    | ⊥     => ⊥
    | A 🡒 B => A.interpret f 𝔅 🡒 B.interpret f 𝔅
    | □A    => 𝔅 (A.interpret f 𝔅)

  noncomputable abbrev standardInterpret (f : Realization α ℒₒᵣ)
      (T : ArithmeticTheory) [T.Δ₁] : Formula α → Sentence ℒₒᵣ :=
    interpret f T.standardProvability
  ```
]


#pagebreak()

#definition[
  算術 $T, U$ とする． *$U$ 上の $T$ の証明可能性論理 $PL(T, U)$* を
  $
    PL(T, U) := { #text[$A$ は様相論理式] | #text[ 任意の実現 $f$ に対し $U proves f_(box_T) (A)$ ] }
  $
  で定める．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Arithmetic/Interpret.lean"),))[
  ```lean
  def ArithmeticTheory.provabilityLogicRelativeTo
      (T U : ArithmeticTheory) [T.Δ₁] : Logic α :=
    { A | ∀ f : Realization α ℒₒᵣ, U ⊢ f T A }

  abbrev ArithmeticTheory.provabilityLogic (T : ArithmeticTheory) [T.Δ₁] :
      Logic α :=
    T.provabilityLogicRelativeTo T
  ```
]

== 算術的完全性定理

#theorem[Solovayの算術的完全性定理(@Sol76)][
  $PL(PA, PA) = LogicGL$．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/GL/Arithmetic.lean"),))[
  ```lean
  theorem arithmetical_completeness_iff [T.SoundOnHierarchy 𝚺 1] :
      𝐆𝐋 ⊢ A ↔ ∀ f : Realization α ℒₒᵣ, T ⊢ f T A

  theorem eq_provabilityLogic [T.SoundOnHierarchy 𝚺 1] : 𝐆𝐋 = T.provabilityLogic (α := α)
  ```
]

#proof[
  健全性 $<==$ はHBLとF-Löbより簡単にわかる．
  完全性 $==>$ が難しい．対偶をとり，反例 $LogicGL$-木モデルを算術の中に埋め込んで満たさない実現を構成する．
]

== 証明可能性論理の分類定理

$PL(T, U)$ の $T, U$ を動かすとどうなるかは @Bek90 によって完全に分類されている．

#definition[
  以下の論理を定める．$LogicGL + X$ は $X$ とのunionのMP/substの閉包（非正規拡大）．
  - $LogicGLAlpha(X) := LogicGL + { box^(n + 1) bot -> box^n bot : n in X}$．
  - $LogicGLBeta(X) := LogicGL + not and.big_(n in.not X) box^(n + 1) bot -> box^n bot$：ただし $X$ は補有限．
  - $LogicA := LogicGL + {not box^n bot : n in NN }$．
  - $LogicD := LogicGL + not box bot + box (A or B) -> box A or box B$．
  - $LogicS := LogicGL + box A -> A$．
]

#leancode(
  links: (
    ("Foundation", "Foundation/ProvabilityLogic/Logic.lean"),
  ),
)[
  ```lean
  abbrev Logic (α : Type*) := Set (Formula α)

  inductive Logic.sumQuasiNormal (L₁ L₂ : Logic α) : Logic α
    | mem₁ {A}    : A ∈ L₁ → sumQuasiNormal L₁ L₂ A
    | mem₂ {A}    : A ∈ L₂ → sumQuasiNormal L₁ L₂ A
    | mdp  {A B}  :
        sumQuasiNormal L₁ L₂ (A 🡒 B) → sumQuasiNormal L₁ L₂ A → sumQuasiNormal L₁ L₂ B
    | subst {A s} : sumQuasiNormal L₁ L₂ A → sumQuasiNormal L₁ L₂ (A⟦s⟧)

  infix:50 " +ᴸ " => Logic.sumQuasiNormal

  abbrev Logic.S {α : Type*} : Logic α := 𝐆𝐋 +ᴸ { □A 🡒 A | A }
  notation "𝐒" => Logic.S
  ```
]

#pagebreak()

#definition[
  論理式 $A$ のトレース $ tr(A) := \{ n in NN : #text[$r_M nforces A$ となる 高さ $n$ の有限根付きモデル $M$ が存在] \} $
  論理 $L$ のトレース $tr(L) := union.big_(A in L) tr(A)$．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Trace.lean"),))[
  ```lean
  def Formula.trace (A : Formula α) : Set ℕ :=
    {n | ∃ (κ : Type u) (_ : Nonempty κ) (M : RootedModel κ α)
            (_ : Fintype M.World) (_ : M.IsGL), M.height = n ∧ M.root ⊮ A}

  def Logic.trace (L : Logic α) : Set ℕ := ⋃ A ∈ L, A.trace
  ```
]

#pagebreak()

#definition[
  $T proves box_T^n bot$ となる最小の $n$ を *理論 $T$ の高さ $height(T)$* という．なければ $omega$．
]

#leancode(links: (("Foundation", "Foundation/FirstOrder/Incompleteness/ProvabilityAbstraction/Height.lean"),))[
  ```lean
  noncomputable def Provability.height (𝔅 : Provability T₀ T) : ENat := ENat.find (T ⊢ 𝔅^[·] ⊥)

  lemma height_eq_top_iff : 𝔅.height = ⊤ ↔ ∀ n, T ⊬ 𝔅^[n] ⊥

  noncomputable abbrev ArithmeticTheory.height (T : ArithmeticTheory) [T.Δ₁] : ℕ∞ :=
    T.standardProvability.height
  ```
]

#pagebreak()

#theorem[@Bek90][
  $L := PL(T, U)$ について．
  1. $tr(L)$ が補無限なら $L = LogicGLAlpha(tr(L))$．
  2. $tr(L)$ が補有限かつ $LogicGL subset.eq.not S$ なら $L = LogicGLBeta(tr(L))$．
  3. $tr(L)$ が補有限かつ $LogicGL subset.eq S$ なら $L$ は $LogicGLAlpha(tr(L)), D union LogicGLBeta(tr(L)), LogicS union LogicGLBeta(tr(L))$ のいずれか．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Classification/General.lean"),))[
  ```lean
  theorem provabilityLogic_eq_A_or_eq_D_or_eq_S :
      letI L := T.provabilityLogicRelativeTo U (α := α);
      L.trace = .univ → L ⪯ 𝐒 → L = 𝐀 ∨ L = 𝐃 ∨ L = 𝐒

  theorem provabilityLogic_classification :
      letI L := T.provabilityLogicRelativeTo U (α := α);
      L = 𝐆𝐋α L.trace ∨
      ∃ hL : L.traceᶜ.Finite, L = 𝐆𝐋β _ hL ∨ L = 𝐃 ∩ 𝐆𝐋β _ hL ∨ L = 𝐒 ∩ 𝐆𝐋β _ hL
  ```
]

#pagebreak()

#theorem[@Bek90][
  真の算術の証明可能性論理 $L := PL(T, TA)$ について．
  1. $T$ が健全なら $L = LogicS$．
  2. $Sigma_1$-健全ではあるなら $L = LogicD$．
  3. $height(T) = omega$ なら $L = LogicA$．
  4. さもなくば，$L = LogicGLBeta(NN setminus \{height(T)\})$．
  のいずれか一つのみが成立する．
]

#leancode(links: (("Foundation", "Foundation/ProvabilityLogic/Classification/Truth.lean"),))[
  ```lean
  theorem provabilityLogic_TA_classification : [
      ℕ↓[ℒₒᵣ] ⊧* T ∧ T.provabilityLogicRelativeTo 𝗧𝗔 (α := α) = 𝐒,
      T.SoundOnHierarchy 𝚺 1 ∧ ¬ℕ↓[ℒₒᵣ] ⊧* T ∧ T.provabilityLogicRelativeTo 𝗧𝗔 (α := α) = 𝐃,
      ¬T.SoundOnHierarchy 𝚺 1 ∧ T.height = ⊤ ∧ T.provabilityLogicRelativeTo 𝗧𝗔 (α := α) = 𝐀,
      ∃ n : ℕ, T.height = n ∧ T.provabilityLogicRelativeTo 𝗧𝗔 (α := α) = 𝐆𝐋β {n}ᶜ (by simp)
    ].OAOO
  ```
]

== 証明可能性論理動物園

#align(center, zoo-provability-logic())

原理的には，それぞれの中間には $2^omega$ 個の相異な証明可能性述語がある（はず）．

= まとめと今後の展望と余談

== 山程の課題

== 今後の目標

== 余談: ソフトウェア開発としての数学の機械化 <sect:perspesctive_software>

#remark(numbering: none)[再掲][
  1. 依拠している数学的基礎に問題や矛盾が無いか？*（論理学者として）*
  2. ソフトウェアとしての実装にバグが存在しないか？*（ソフトウェア開発者として）*
  3. 形式化したそのコードは命題を正しく形式化しているか？*（エンドユーザとして）*
]

「定理証明支援系を開発する」という目的でなかったとしても，形式証明を書くという事業はソフトウェア開発の一種である．

#pagebreak()

OpenAI, Navier-Stokes方程式に関する形式化のコミットの例．

#pagebreak()

OpenAIやAnthoropicなどが提出したNS方程式やFLTの形式証明は問題があると個人的には思う．

/ 妥当性の問題: 本当に正しく主張を形式化出来てる？
  - 100k行の証明をどうやって一気に人間がレビューしろと？
  - この膨大なコードの中で定理証明支援系自体の実装のバグを踏んでいないとなぜ言える？
/ 重要度の問題: アドホックな補題や定義・議論が多すぎるのでは？
  - 1回しか使わない補題など，本当に切り出すべきか？
/ 再利用性の問題: 車輪の再発明では？
  - 難問にはそれなりにたくさんの道具が必要，それらを毎回毎回用意し直すのは無駄．
  - 適切にライブラリとして切り出せばコミュニティとしても嬉しいはず．しかし一切そのようなことが行われている気配はない #footnote[ただし現状ではMathlibはAI/LLMによるPRは受け付けていない．それでは困るので，最近ではTau Ceti Project #link("https://github.com/TauCetiProject/TauCeti") というAIの使用やレビューを受け付けている実験場も用意されている．]．

#pagebreak()

定理証明支援系・形式証明を
- 単なる自然言語による証明のより精緻な保証の執筆作業としてではなく，
- 数学をより高速かつ正確に生産するソフトウェア開発の視点を投げかける：*証明工学*

#pagebreak()

一般のソフトウェア開発にはあまりない面白い課題が多く眠っていると思う．

/ deformalization: 逆方向，つまり，既にある形式証明から逆に自然言語で書かれた読みやすい証明へと翻訳する．あるいは，そもそもこの形式証明が書かれた意図などを補題から抽出することで，新たな数学的理論の創出に繋がる可能性がある．
/ visualization: 定理や補題同士の繋がりの可視化や，そもそも数学的構造自体の可視化を自動で行えたら，それは形式証明を人力で読み書きする人間にも役立つだろう．
/ collaborating: 数学というかなり専門性や属人性の高い知識が要求される開発者をどのようにマネジメントしたりプロジェクトを進めるべきか？
/ architecture: もっと効率的・正確に形式証明を生成するような自動証明アーキテクチャはどのようなものだろうか？

もちろん古典的なソフトウェア工学的な知見だって大いに役立つだろう #footnote[ソフトウェア工学という学問が現代ないし現場のソフトウェア開発に果たしてどれだけ寄与したのか，あるいは単に机上の空論ではなかったのか？という批判はありますが．]．

== 余談: FFLにおけるAI/LLMの活用

Solovayの算術的完全性定理まではLLMは積極的に利用していなかった（2025年ごろ）．

積極的に利用し始めたのは証明可能性論理の分類定理を機械化するにあたって（2026年7月）．
技術的に面倒な部分があって停滞していたが，大きく加速した．

#pagebreak()

Kripkeモデルの幾何的な議論（*絵で書いたら自明じゃん*）をどうLeanでコードを書くべきか？が難しく（あるいはただ面倒な議論で）詰まっていた．

例：

モデル $M$ の適当な点 $a$ の前に $n <= omega$ 個の点を追加する．
このとき，新しいモデルの高さは有限個の追加ならせいぜい $height(M) + n$．

*機械化するとなると結構な議論になる．*

#pagebreak()

個人的には，来年(2027年)にはもうそれほど人力で形式証明を書かなくても良い時代が来るのかなとは思う．
- *便利なキーボードとしてのAI/LLM．*
- もちろん全体的な議論や実装の筋の良さ，みたいなものは人が評価するべきだとは思う．

== 参考文献

説明出来なかった機械化の技術的な詳細は @Sai24 にも記載がある（それほど実装の本筋は変わっていない）．

#show bibliography: set text(size: 0.75em)
#bibliography(title: none, "references.yml", style: "elsevier-harvard")
