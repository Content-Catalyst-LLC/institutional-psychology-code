#include <stdio.h>
#include <math.h>

double transformation_score_raw(
    double crisis_severity,
    double feedback_breakdown,
    double legitimacy_failure,
    double adaptive_capacity,
    double reform_window,
    double coalition_strength,
    double coordination_quality,
    double learning_rate,
    double governance_alignment,
    double power_concentration,
    double capture_risk,
    double distributional_attention
) {
    return
        0.15 * crisis_severity +
        0.11 * feedback_breakdown +
        0.14 * legitimacy_failure +
        0.10 * adaptive_capacity +
        0.12 * reform_window +
        0.12 * coalition_strength +
        0.08 * coordination_quality +
        0.06 * learning_rate +
        0.06 * governance_alignment +
        0.05 * distributional_attention -
        0.07 * capture_risk -
        0.04 * fabs(power_concentration - 50.0);
}

int main(void) {
    double score = transformation_score_raw(
        85.0, 78.0, 80.0, 70.0, 75.0, 68.0,
        72.0, 65.0, 74.0, 55.0, 35.0, 80.0
    );

    printf("Institutional transformation raw score: %.2f\n", score);
    return 0;
}
