#include <stdio.h>

double compliance_quality_score_raw(
    double legitimacy,
    double fairness,
    double incentive_alignment,
    double norm_support,
    double enforcement_credibility,
    double communication_quality,
    double cognitive_clarity,
    double trust,
    double adaptive_learning,
    double compliance_burden,
    double selective_rule_application,
    double defensive_compliance,
    double hypocrisy_visibility,
    double norm_failure
) {
    return
        0.13 * legitimacy +
        0.13 * fairness +
        0.11 * incentive_alignment +
        0.11 * norm_support +
        0.10 * enforcement_credibility +
        0.11 * communication_quality +
        0.12 * cognitive_clarity +
        0.11 * trust +
        0.09 * adaptive_learning -
        0.11 * compliance_burden -
        0.08 * selective_rule_application -
        0.06 * defensive_compliance -
        0.05 * hypocrisy_visibility -
        0.05 * norm_failure;
}

int main(void) {
    double score = compliance_quality_score_raw(
        76.0, 78.0, 72.0, 74.0, 70.0, 80.0, 82.0,
        75.0, 73.0, 28.0, 24.0, 20.0, 18.0, 22.0
    );

    printf("Compliance quality raw score: %.2f\n", score);
    return 0;
}
