# Conceptual Model

A semi-formal model of public goods provision:

```text
PG = f(IC, EN, NO, TR, LG, CO, MO, SC, PF, CR, DA)
```

Where:

| Symbol | Meaning |
|---|---|
| PG | Public Goods Provision Quality |
| IC | Incentive Compatibility |
| EN | Enforcement Capacity |
| NO | Norm Strength |
| TR | Trust |
| LG | Legitimacy |
| CO | Coordination Quality |
| MO | Monitoring Quality |
| SC | Scale Complexity |
| PF | Perceived Fairness |
| CR | Capture Risk |
| DA | Distributional Attention |

A simplified public goods provision score:

```text
PG = β1(IC) + β2(EN) + β3(NO) + β4(TR) + β5(LG)
   + β6(CO) + β7(MO) + β8(PF) + β9(DA)
   − β10(SC) − β11(CR)
```

A simplified contribution probability model:

```text
P(Contribute_i) = σ(α0 + α1T_i + α2L_i + α3E_i + α4N_i
                      + α5S_i + α6F_i − α7R_i)
```

Where:

- `T_i` = trust
- `L_i` = legitimacy
- `E_i` = enforcement
- `N_i` = norm strength
- `S_i` = selective incentives
- `F_i` = perceived fairness
- `R_i` = free-riding opportunity

## Interpretation

- Contribution depends on belief, enforcement, incentives, and norms.
- Provision quality depends on whether contributions are converted into shared benefits.
- High enforcement without legitimacy may create adversarial compliance.
- High provision with low legitimacy can be fragile.
- Distributional attention helps distinguish public goods from public goods for some.
