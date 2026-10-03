#import "template.typ": *

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

#let FrameClass = $bb("F")$
#let HilbertSystem = $frak("H")$
#let Thm = $upright("Thm")$

#let proves = $tack.r$
#let nproves = $tack.r.not$
#let models = $tack.rr$
#let nmodels = $tack.rr.not$

#let Bew = $frak("B")$

#let Con = $bold(upright("Con"))$


#let Axiom(A) = $sans(upright(#A))$
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
#let RuleMP = $Rule("MP")$
#let RuleNec = $Rule("Nec")$
#let RuleLoeb = $Rule("Löb")$
#let RuleHenkin = $Rule("Henkin")$

#let Logic(L) = $bold(upright(#L))$
#let LogicK = $Logic("K")$
#let LogicF = $Logic("F")$
#let LogicWF = $Logic("WF")$
#let LogicVF = $Logic("VF")$

#let Arith(A) = $sans(#A)$
#let PA = $Arith("PA")$

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

#let CIC = $sans("CIC")$
#let ZFC = $sans("ZFC")$
#let Lean = $sans("Lean")$

型理論としてCalculus of Inductive ($CIC$) を採用している．

原理上は#footnote[
  Lean 3では @Car19 が $ZFC + #text[「$omega$-個の到達不能基数が存在する」]$ の無矛盾性をモデルを作って示している．
  この結果を素直にこの結果をLean 4に持ってくることは出来ないが，最近ようやく #link("https://github.com/leanprover/con-leche") などで取り組まれているように思える．
  もちろん今ある数学が全然 $ZFC$ でやってるわけねーだろという方にとっては一切この話は関係ない．
]普通に行われている数学が全部展開出来るだろうとされている．

== 余談: 定理証明支援系・Leanは信頼できるか？

最近のニュース: @Kum260726 はCollatz予想の反証をLean v4.32.1 で形式化した．

```lean
-- `n` はCollatzの操作を何度行っても1にならない．
def Diverges (n : Nat) : Prop := 0 < n ∧ ∀ k, iterate step k n ≠ 1

-- そのような `n` が存在する．
theorem exists_nonterminating_orbit : ∃ n, Diverges n :
```

もちろん#footnote[この講演が行われた当時は少なくとも]このような上手い話があるわけがなく，これはLeanの*ソフトウェアとしての*実装のバグに由来するものであった（詳しい解説は @dM260801）．

#pagebreak()

ひとくちに定理証明支援系を使うと言っても，次のことに目を向けるべきだと感じる #footnote[この基準は @Alwe260929 のツイートから拝借した．]．

1. 依拠している数学的基礎に問題や矛盾が無いか？*（論理学者として）*
2. ソフトウェアとしての実装にバグが存在しないか？*（ソフトウェア開発者として）*
3. 形式化したそのコードは命題を正しく形式化しているか？*（エンドユーザとして）*


= 1階述語論理および不完全性定理

== 言葉遣いについて

#remark[
  _formalize_ という語の意図を以下で使い分ける．

  / formalize (形式化): 数理論理学の技法として数学的議論を形式操作だと思って展開する．
  / mechanize (機械化): 定理証明支援系によって数学をプログラムによって実装する．

  我々がやったことの端的な説明：*数学の形式化の機械化*！
]

== 不完全性定理

#let R0 = $upright(sans(R_0))$
#let ISigma1 = $upright(sans(I)) Sigma_1$

次のGödelの不完全性定理の素朴なバージョンを機械化した．

#theorem(numbering: none)[Gödelの第1不完全性定理(G1)][
  $T$ がCobhamの最弱の算術 $R0$ を含み，$Delta_1$-定義可能 #footnote[$T$の公理を記述する論理式が $Delta_1$-論理式で記述出来る] で，$Sigma_1$-健全なら，$T$ から証明も反証も出来ない論理式が存在する．
]

#theorem(numbering: none)[Gödelの第2不完全性定理(G2)][
  $T$ が $ISigma1$ より強く無矛盾なら，$T$ の無矛盾性を表す文は証明できない．
]

いくつかの条件は改良できる(後述)．

```lean
theorem incomplete (T : ArithmeticTheory) [T.Δ₁] [𝗥₀ ⪯ T] [T.SoundOnHierarchy 𝚺 1] : Incomplete T
```

== 論理式

論理式 (疑論理式) は否定標準形で扱う．`L` は言語，型 `ξ` を自由変数，束縛変数はde Bruijnインデックスによって自然数 `ℕ` で扱うこととする．

$ phi, psi ::= top | bot | R(arrow(v)) | not R(arrow(v)) | phi and psi | phi or psi | forall phi | exists phi $

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

- `Formula L ξ` を `Semiformula L ξ 0` の略記（束縛変数無し）
- `Semisentence L 0` を `Semiformula L Empty n` の略記（自由変数無し）
- `Sentence L` を `Formula L Empty` の略記（自由・束縛変数無し）

#pagebreak()

#let LOR = $cal(L)_"OR"$

算術の言語 $LOR$ を定めて，Leanのマクロによる糖衣構文を用意する．
例えばこんな感じで記述出来る．

== 証明体系

#let LK = $bold(upright("LK"))$

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

#pagebreak()

カット無しの証明図へ変換する具体的な計算手続きを定める #footnote[証明図の帰納法による愚直な証明は機械化において煩雑で面倒なので，Avigad による直観主義述語論理への還元および強制法的な議論による．]ことで，#LK ではカット除去定理を機械化出来る #footnote[ただしこれが現実的にLeanで計算可能なのかはわからない．]．

```lean
def hauptsatz {Γ : LK.Sequent L} : ⊢ᴸᴷ¹ Γ → {d : ⊢ᴸᴷ¹ Γ // LK.Derivation.IsCutFree d}
```

言語 $L$ の理論 $T$ を $L$-文の集合 `Set (Sentence L)` とする．

- $phi$ が $T$ から導出できることを $T proves phi$ と書く．
- $T$ を満たす任意のモデル $M$ で $phi$ も満たされるとき，$T models phi$ と書く．

カット除去定理からカノニカルモデルを作るなどの議論を行って，完全性定理を得る．

```lean
theorem small_satisfiable_of_consistent : Consistent T → Satisfiable T

theorem Proof.complete_iff : T ⊨ φ ↔ T ⊢ φ := ⟨fun h ↦ Proof.complete h, Proof.sound⟩
```

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
  Lean proves \"T proves phi\" <==> Lean proves \"T models phi\"
$

意味論的な議論においては，例えば $T$ が十分に豊かな算術であるなら $T models V$ を満たす $V$ が良い代数的な構造になる．
Mathlibなどが提供する代数的な構造に対しての様々な補題やメタプログラミング，自動証明タクティクが利用出来る．
これを戻して $T proves phi$ を簡単に示せる．

#pagebreak()

算術 $T$ の任意のモデル $V$ を固定する．

```lean
  variable {V : Type*} [ORingStruc V] [V ⊧ₘ* T]
```

- `ORingStruc V`: $V$ が言語 $cal(L)_"OR"$ の構造であることを主張するtypeclass.
- `V ⊧ₘ* T`: $V$ が理論 $T$ を満たすことを主張するtypeclass.

$V$ 上で機械化を行う．関数は選択関数を用いて定義出来る．

```lean
  lemma sqrt_exists_unique (a : V) : ∃! x, x * x ≤ a ∧ a < (x + 1) * (x + 1) := by ...

  def sqrt (a : V) : V := Classical.choose! (sqrt_exists_unique a)
  prefix:75 "√" => sqrt

  lemma sqrt_mul_self (a : V) : √(a * a) = a := by ...
```

#let Rep(S) = $sans("Rep")_(#S)$
#let godelize(x) = $lr(⌜ #x ⌝)$
#let num(x) = $overline(#x)$

== メタ数学の算術化

形式体系を算術の中でさらに形式化する#footnote[Formalizing \[Formalizing \[Formalizing mathematics in formal system\] in Arithmetic\] in Lean]：*算術化・Bootstraping*．

- 論理式 $phi$ や導出木 $D$ に対して $V$ への割り当て $godelize(dot)$ を割り当てる（*Gödel数*）．
- 逆に $V$ の要素 $x$ が項，論理式，導出木のGödel数であるというメタの（Lean上の）述語 $upright("IsFormula")(x) : V mapsto 2$ などを考える．

メタの述語 $upright("IsFormula")(x)$ に対応する $LOR$-論理式 $sans("IsFormula")(godelize(phi))$ などを $Delta_0, Sigma_n, Pi_n$ の適当な階層で*ひたすら頑張って*構成していく．

$
  V models upright("IsFormula")(godelize(phi)) <==> T proves sans("IsFormula")(godelize(phi))
$

== $R0$ の表現定理


$R0$ では表現定理が成り立つ #footnote[もちろんRobinson算術や $PA$ でも成り立つが，$R0$ は表現定理が成り立つよく知られている算術理論の中では最弱とされる．]．

#theorem[$R0$ の表現定理][
  $Sigma_1$-健全な $T supset.eq R0$ と，$S$ をr.e.集合とする．
  このとき，$LOR$-論理式 $Rep(S)(x)$ があって以下を満たす．
  $
    n in S <==> T proves Rep(S)(num(n))
  $
]

== 第1不完全性定理

表現定理および算術化を用いて，Gödelの第1不完全性定理(G1)をまず形式化出来る．

#theorem(numbering: none)[G1][
  $T$ がCobhamの最弱の算術 $R0$ を含み，$Delta_1$-定義可能で，$Sigma_1$-健全なら，$T$ から証明も反証も出来ない文が存在する．
]

#proof[
  $D := { godelize(phi) : #text[$phi$ は1変数論理式かつ $T proves not phi(godelize(phi))$] }$ を取ると，これはr.e.なので $theta(x)$ が存在して $n in D <==> T proves theta(num(n))$．以下の同値性が成立する．
  $
    T proves theta(godelize(theta)) <==> godelize(theta) in D <==> T proves not theta(godelize(theta))
  $
  ゆえに $T$ が完全なら無矛盾性に反する．
]

```lean
theorem incomplete (T : ArithmeticTheory) [T.Δ₁] [𝗥₀ ⪯ T] [T.SoundOnHierarchy 𝚺 1] : Incomplete T
```

ここで `Incomplete T` は `∃ φ, T ⊬ φ ∧ T ⊬ ∼φ` の略記．

== 証明可能性の抽象化

生の証明可能性述語を機械化で直接扱うと面倒なので，抽象化を導入する．

#let D1 = $bold("D1")$
#let D2 = $bold("D2")$
#let D3 = $bold("D3")$

#definition[証明可能性][
  1変数述語 $Bew$ が *$T_0$ 上の $T$-証明可能性 である*とは， $D1: T proves sigma ==> T_0 proves Bew sigma$ を任意の文 $sigma$ で満たすこととする．
  追加条件として以下を満たすとき，*HBLである*という．
  - $D2: T_0 proves Bew(sigma → tau) → (Bew sigma → Bew tau)$
  - $D3: T_0 proves Bew sigma → Bew(Bew sigma)$
]

#definition[対角化可能性][
  *$T$ が対角化可能*とは，1変数述語 $theta$ を入力とし文 $upright("fixpoint")_theta$ を返す関数があって，それは以下を満たす．
  $
    T proves upright("fixpoint")_theta <-> theta(godelize(upright("fixpoint")_theta))
  $
]

#pagebreak()

#definition[
  - $not Bew(dot.c)$ のfixpointをGödel文 $upright("G")_Bew$ とする．
  - 無矛盾性を表す文 $not Bew bot$ を $upright("Con")_Bew$ とする．
]

#lemma[Abstract G1, G2, Löb][
  $T$ が対角化可能で，$Bew$ はHBLを満たすとする．
  / G1: $T nproves upright("G")_Bew$
  / G2: $T nproves upright("Con")_Bew$
  / Löb: $T proves Bew sigma -> sigma$ なら $T proves sigma$
  / F-Löb: $T proves Bew (Bew sigma -> sigma) -> Bew sigma$
]

== 第2不完全性定理

算術化を頑張るとHBLを満たす証明可能性や対角可能性を実際に構成に構成することができる．
故に系として，第2不完全性定理やLöbの定理を機械化出来る．

#theorem[Gödelの第2不完全性定理][
  $T$ が $ISigma1$ より強く無矛盾なら，$T$ の無矛盾性を表す文 $not box_T bot$ は証明できない．
]

#theorem[Löbの定理][
  $T proves box_T sigma → sigma$ なら $T proves sigma$
]

$T$ としてPeano算術 $PA$ を取ることが出来る．

== いろんな系

= 証明可能性論理

== はじめに

証明可能性論理の簡単な説明
- *不完全性定理において中心的な役割を果たす証明可能性述語「$phi$ は $T$ で証明できる」を様相だと思おう．*
- 証明可能性 $Bew$ をより様相論理的に扱う

= まとめと今後の展望

== 山程の課題

== 今後の目標

== 余談: ソフトウェア開発としての数学の機械化

再掲：

1. 依拠している数学的基礎に問題や矛盾が無いか？*（論理学者として）*
2. ソフトウェアとしての実装にバグが存在しないか？*（ソフトウェア開発者として）*
3. 形式化したそのコードは命題を正しく形式化しているか？*（エンドユーザとして）*

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

== 参考文献

説明出来なかった機械化の技術的な詳細は @Sai24 にも記載がある（それほど実装の本筋は変わっていない）．

#bibliography(title: none, "references.yml", style: "elsevier-harvard")
