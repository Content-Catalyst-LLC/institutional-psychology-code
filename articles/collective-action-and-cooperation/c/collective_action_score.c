#include <stdio.h>

double collective_action_score_raw(
    double incentive_alignment,
    double trust,
    double legitimacy,
    double norm_strength,
    double enforcement_credibility,
    double communication_quality,
    double coordination_quality,
    double perceived_fairness,
    double free_riding_pressure,
    double burden_inequality,
    double hypocrisy_visibility,
    double scale_complexity
) {
    return
        0.12 * incentive_alignment +
        0.13 * trust +
        0.12 * legitimacy +
        0.11 * norm_strength +
        0.10 * enforcement_credibility +
        0.11 * communication_quality +
        0.11 * coordination_quality +
        0.10 * perceived_fairness -
        0.12 * free_riding_pressure -
        0.07 * burden_inequality -
        0.06 * hypocrisy_visibility -
        0.05 * scale_complexity;
}

int main(void) {
    double score = collective_action_score_raw(
        78.0, 76.0, 74.0, 72.0, 70.0, 80.0,
        75.0, 73.0, 30.0, 25.0, 20.0, 35.0
    );

    printf("Collective action raw score: %.2f\n", score);
    return 0;
}
