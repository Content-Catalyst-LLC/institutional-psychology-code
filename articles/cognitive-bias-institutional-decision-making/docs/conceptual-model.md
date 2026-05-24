# Conceptual Model

A semi-formal model of institutional bias pressure:

```text
IB = f(OC, AN, CF, CP, FD, PL, MT, PP, DC, CR, IQ, FO, PS, JV)
```

Where:

| Symbol | Meaning |
|---|---|
| IB | Institutional Bias Pressure |
| OC | Overconfidence |
| AN | Anchoring Pressure |
| CF | Confirmation Pressure |
| CP | Conformity Pressure |
| FD | Filtering Distortion |
| PL | Path Lock-In |
| MT | Metric Tunnel Vision |
| PP | Power Protection |
| DC | Dissent Capacity |
| CR | Corrective Review |
| IQ | Information Quality |
| FO | Feedback Openness |
| PS | Psychological Safety |
| JV | Justice-Sensitive Voice |

A simplified bias-pressure score:

```text
IB = β1(OC) + β2(AN) + β3(CF) + β4(CP) + β5(FD)
   + β6(PL) + β7(MT) + β8(PP)
   − β9(DC) − β10(CR) − β11(IQ) − β12(FO) − β13(PS) − β14(JV)
```

A decision-quality equation:

```text
DQ = α1(IQ) + α2(DC) + α3(CR) + α4(FO) + α5(PS) + α6(JV) − α7(IB)
```

A recursive decision-learning equation:

```text
Q(t+1) = Q(t) + αC(t) + βF(t) + γD(t) − δB(t)
```

Where:

- `Q(t)` = decision quality
- `C(t)` = corrective capacity
- `F(t)` = feedback openness
- `D(t)` = structured dissent
- `B(t)` = bias pressure

## Interpretation

- Institutions do not become rational merely by following procedure.
- Decision quality depends on whether evidence is interpreted under sufficient challenge, feedback, dissent, and accountability.
- High apparent decision quality can be fragile when dissent is weak, filtering distortion is high, and power protection is strong.
