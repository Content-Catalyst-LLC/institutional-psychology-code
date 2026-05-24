#include <stdio.h>

double behavioral_governance_score_raw(
    double incentive_alignment,
    double legitimacy,
    double norm_support,
    double cognitive_interpretability,
    double trust,
    double coordination_quality,
    double enforcement_credibility,
    double adaptive_learning,
    double perceived_fairness,
    double behavioral_burden,
    double hypocrisy_visibility,
    double power_asymmetry
) {
    return
        0.11 * incentive_alignment +
        0.13 * legitimacy +
        0.10 * norm_support +
        0.11 * cognitive_interpretability +
        0.12 * trust +
        0.11 * coordination_quality +
        0.10 * enforcement_credibility +
        0.11 * adaptive_learning +
        0.10 * perceived_fairness -
        0.10 * behavioral_burden -
        0.07 * hypocrisy_visibility -
        0.06 * power_asymmetry;
}

int main(void) {
    double score = behavioral_governance_score_raw(
        78.0, 76.0, 72.0, 80.0, 74.0, 75.0,
        70.0, 73.0, 77.0, 28.0, 20.0, 25.0
    );

    printf("Behavioral governance raw score: %.2f\n", score);
    return 0;
}
