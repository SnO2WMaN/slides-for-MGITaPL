// スライド間で共有する記法．

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
#let nforces = sym.forces.not

#let Bew = $op(frak("B"))$
#let Wid = $op(frak("W"))$
#let Con = $sans(upright("Con"))$

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
#let Nec = $Rule("Nec")$
#let RuleWL = $Rule("WL")$
#let RuleWR = $Rule("WL")$

// 様相論理・シークエント計算
#let Logic(L) = $bold(upright(#L))$
#let LogicGL = $Logic("GL")$
#let LogiciK = $Logic("iK")$
#let LogiciGL = $Logic("iGL")$
#let LogiciSL = $Logic("iSL")$
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
#let ZF = $sans("ZF")$
#let ZFC = $sans("ZFC")$
#let Lean = $sans("Lean")$
#let LK = $bold(upright("LK"))$

#let Arith(A) = $sans(#A)$
#let PA = $Arith("PA")$
#let HA = $Arith("HA")$
#let PAMinus = $Arith("PA")^-$
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
