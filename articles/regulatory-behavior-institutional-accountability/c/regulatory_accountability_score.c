#include <stdio.h>

double regulatory_accountability_score_raw(
    double oversight_strength,
    double legitimacy,
    double incentive_alignment,
    double enforcement_credibility,
    double information_quality,
    double adaptive_learning,
    double accountability_reach,
    double capture_pressure,
    double regulatory_burden,
    double evasion_pressure,
    double hypocrisy_visibility,
    double unequal_accountability
) {
    return
        0.13 * oversight_strength +
        0.13 * legitimacy +
        0.11 * incentive_alignment +
        0.12 * enforcement_credibility +
        0.13 * information_quality +
        0.11 * adaptive_learning +
        0.11 * accountability_reach -
        0.12 * capture_pressure -
        0.08 * regulatory_burden -
        0.07 * evasion_pressure -
        0.06 * hypocrisy_visibility -
        0.06 * unequal_accountability;
}

int main(void) {
    double score = regulatory_accountability_score_raw(
        82.0, 76.0, 74.0, 72.0, 80.0, 75.0,
        70.0, 25.0, 30.0, 22.0, 18.0, 24.0
    );

    printf("Regulatory accountability raw score: %.2f\n", score);
    return 0;
}
