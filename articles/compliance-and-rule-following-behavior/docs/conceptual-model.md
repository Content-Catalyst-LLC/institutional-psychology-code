# Conceptual Model

A semi-formal model of compliance quality:

```text
CQ = f(LG, FR, IN, NO, EN, CM, CC, TR, AL, BD, SE, DC, HY, NF)
```

Where:

| Symbol | Meaning |
|---|---|
| CQ | Compliance Quality |
| LG | Legitimacy |
| FR | Perceived Fairness |
| IN | Incentive Alignment |
| NO | Norm Support |
| EN | Enforcement Credibility |
| CM | Communication Quality |
| CC | Cognitive Clarity |
| TR | Trust |
| AL | Adaptive Learning |
| BD | Behavioral Burden |
| SE | Selective Rule Application |
| DC | Defensive Compliance |
| HY | Hypocrisy Visibility |
| NF | Norm Failure |

A simplified compliance-quality score:

```text
CQ = β1(LG) + β2(FR) + β3(IN) + β4(NO) + β5(EN)
   + β6(CM) + β7(CC) + β8(TR) + β9(AL)
   − β10(BD) − β11(SE) − β12(DC) − β13(HY) − β14(NF)
```

A simplified compliance probability model:

```text
P(Comply_i) = σ(α0 + α1L_i + α2F_i + α3T_i + α4N_i
                   + α5E_i + α6C_i + α7K_i − α8B_i − α9S_i)
```

Where:

- `L_i` = legitimacy
- `F_i` = fairness
- `T_i` = trust that others comply
- `N_i` = norm support
- `E_i` = enforcement credibility
- `C_i` = communication quality
- `K_i` = cognitive clarity
- `B_i` = compliance burden
- `S_i` = selective rule-application exposure

## Interpretation

- Compliance is not merely visible adherence; it is a system property.
- Rules become behaviorally real when they are legitimate, intelligible, feasible, socially supported, and fairly enforced.
- High visible compliance can be fragile when burden, selective rule application, defensive compliance, hypocrisy, or norm failure are high.
