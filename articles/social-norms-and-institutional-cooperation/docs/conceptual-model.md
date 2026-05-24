# Conceptual Model

A semi-formal model of norm-based institutional cooperation:

```text
NC = f(DE, IN, TR, LG, SA, TM, IR, CF, HY, UE, PC, DA)
```

Where:

| Symbol | Meaning |
|---|---|
| NC | Norm-Based Cooperation |
| DE | Descriptive Norm Strength |
| IN | Injunctive Norm Strength |
| TR | Trust |
| LG | Legitimacy |
| SA | Social Sanction Intensity |
| TM | Transmission Mechanisms |
| IR | Institutional Reinforcement |
| CF | Norm Conflict or Fragmentation |
| HY | Hypocrisy Visibility |
| UE | Unequal Enforcement |
| PC | Performative Compliance |
| DA | Distributional Attention |

A simplified norm-based cooperation score:

```text
NC = β1(DE) + β2(IN) + β3(TR) + β4(LG) + β5(SA)
   + β6(TM) + β7(IR) + β8(DA)
   − β9(CF) − β10(HY) − β11(UE) − β12(PC)
```

A simplified compliance probability model:

```text
P(Comply_i) = σ(α0 + α1D_i + α2J_i + α3T_i + α4L_i
                  + α5S_i + α6I_i − α7C_i − α8H_i − α9U_i)
```

Where:

- `D_i` = descriptive norm perception
- `J_i` = injunctive norm perception
- `T_i` = trust
- `L_i` = legitimacy
- `S_i` = social sanction
- `I_i` = institutional reinforcement
- `C_i` = norm conflict
- `H_i` = hypocrisy visibility
- `U_i` = unequal enforcement exposure

## Interpretation

- Norms shape cooperation through social expectations, not only incentives.
- Norm strength depends on repetition, transmission, reinforcement, trust, and legitimacy.
- Hypocrisy, unequal enforcement, and performative compliance can make a norm fragile.
- High norm compliance does not automatically imply justice, legitimacy, or institutional health.
