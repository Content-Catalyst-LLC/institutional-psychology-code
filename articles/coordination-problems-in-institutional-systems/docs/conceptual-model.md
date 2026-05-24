# Conceptual Model

A semi-formal model of institutional coordination quality:

```text
CQ = f(IQ, TR, FS, CM, AU, NO, LE, UN, AB, CS, CA, DA)
```

Where:

| Symbol | Meaning |
|---|---|
| CQ | Coordination Quality |
| IQ | Information Quality |
| TR | Trust |
| FS | Focal-Point Salience |
| CM | Communication Clarity |
| AU | Authority Signal Strength |
| NO | Norm Strength |
| LE | Learning Capacity |
| UN | Uncertainty |
| AB | Adaptation Burden |
| CS | Competing Standards |
| CA | Competing Authority |
| DA | Distributional Attention |

A simplified coordination score:

```text
CQ = β1(IQ) + β2(TR) + β3(FS) + β4(CM) + β5(AU)
   + β6(NO) + β7(LE) + β8(DA)
   − β9(UN) − β10(AB) − β11(CS) − β12(CA)
```

A simplified alignment probability model:

```text
P(Align_i) = σ(α0 + α1T_i + α2I_i + α3C_i + α4A_i
                 + α5F_i + α6N_i − α7U_i − α8B_i)
```

Where:

- `T_i` = trust
- `I_i` = information quality
- `C_i` = communication clarity
- `A_i` = authority signal strength
- `F_i` = focal-point salience
- `N_i` = norm strength
- `U_i` = uncertainty
- `B_i` = adaptation burden

## Interpretation

- Coordination depends on shared expectations, not only incentives.
- Information must become common knowledge to coordinate behavior.
- Focal points reduce equilibrium-selection uncertainty.
- Authority can designate focal points, but legitimacy affects uptake.
- High coordination may still be fragile or unjust if trust is low or adaptation burdens are unequal.
