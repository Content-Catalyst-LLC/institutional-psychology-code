# Conceptual Model

A semi-formal model of enforcement effectiveness:

```text
EE = f(MO, LG, IN, SA, IQ, AL, AR, CB, SE, AD, HY, DC)
```

Where:

| Symbol | Meaning |
|---|---|
| EE | Enforcement Effectiveness |
| MO | Monitoring Quality |
| LG | Legitimacy |
| IN | Incentive Alignment |
| SA | Sanction Credibility |
| IQ | Information Quality |
| AL | Adaptive Learning |
| AR | Accountability Reach |
| CB | Compliance Burden |
| SE | Selective Enforcement |
| AD | Adaptive Evasion or Distortion Pressure |
| HY | Hypocrisy Visibility |
| DC | Defensive Compliance |

A simplified enforcement score:

```text
EE = β1(MO) + β2(LG) + β3(IN) + β4(SA) + β5(IQ)
   + β6(AL) + β7(AR)
   − β8(CB) − β9(SE) − β10(AD) − β11(HY) − β12(DC)
```

A simplified compliance probability model:

```text
P(Comply_i) = σ(α0 + α1L_i + α2F_i + α3D_i + α4T_i
                   + α5R_i − α6C_i − α7S_i)
```

Where:

- `L_i` = legitimacy
- `F_i` = fairness and consistency
- `D_i` = detection visibility
- `T_i` = trust that rules apply to others
- `R_i` = reputational or normative cost of violation
- `C_i` = compliance burden
- `S_i` = selective enforcement exposure

## Interpretation

- Enforcement is not merely sanction severity; it is a behavioral system.
- Monitoring requires information quality and interpretability.
- Sanctions require legitimacy and proportionality to sustain durable compliance.
- High apparent enforcement may be fragile when evasion, burden, defensive compliance, or selective enforcement are high.
