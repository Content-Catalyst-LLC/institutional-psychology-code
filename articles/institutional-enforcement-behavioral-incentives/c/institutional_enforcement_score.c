#include <stdio.h>

double institutional_enforcement_score_raw(
    double monitoring_quality,
    double legitimacy,
    double incentive_alignment,
    double sanction_credibility,
    double information_quality,
    double adaptive_learning,
    double accountability_reach,
    double compliance_burden,
    double selective_enforcement,
    double evasion_pressure,
    double hypocrisy_visibility,
    double defensive_compliance
) {
    return
        0.13 * monitoring_quality +
        0.13 * legitimacy +
        0.12 * incentive_alignment +
        0.12 * sanction_credibility +
        0.13 * information_quality +
        0.11 * adaptive_learning +
        0.10 * accountability_reach -
        0.08 * compliance_burden -
        0.08 * selective_enforcement -
        0.12 * evasion_pressure -
        0.06 * hypocrisy_visibility -
        0.06 * defensive_compliance;
}

int main(void) {
    double score = institutional_enforcement_score_raw(
        82.0, 76.0, 74.0, 72.0, 80.0, 75.0,
        70.0, 30.0, 24.0, 22.0, 18.0, 20.0
    );

    printf("Institutional enforcement raw score: %.2f\n", score);
    return 0;
}
