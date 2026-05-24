#include <stdio.h>

double institutional_incentive_score_raw(
    double value_alignment,
    double fairness,
    double information_quality,
    double legitimacy,
    double learning_support,
    double accountability,
    double bias_pressure,
    double metric_substitution,
    double reporting_distortion,
    double behavioral_burden,
    double short_termism,
    double status_inequality,
    double motivation_crowding
) {
    return
        0.14 * value_alignment +
        0.12 * fairness +
        0.13 * information_quality +
        0.12 * legitimacy +
        0.12 * learning_support +
        0.10 * accountability -
        0.10 * bias_pressure -
        0.12 * metric_substitution -
        0.09 * reporting_distortion -
        0.08 * behavioral_burden -
        0.07 * short_termism -
        0.06 * status_inequality -
        0.05 * motivation_crowding;
}

int main(void) {
    double score = institutional_incentive_score_raw(
        82.0, 76.0, 80.0, 78.0, 75.0, 72.0,
        25.0, 22.0, 20.0, 28.0, 24.0, 18.0, 21.0
    );

    printf("Institutional incentive raw score: %.2f\n", score);
    return 0;
}
