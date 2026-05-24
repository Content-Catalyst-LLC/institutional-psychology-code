#include <stdio.h>

double institutional_learning_score_raw(
    double feedback_quality,
    double memory_retention,
    double communication_openness,
    double interpretive_quality,
    double decision_revisability,
    double psychological_safety,
    double accountability_reach,
    double disconfirming_evidence,
    double institutional_inertia,
    double signal_distortion,
    double memory_decay,
    double defensive_routines,
    double power_protection,
    double feedback_delay
) {
    return
        0.13 * feedback_quality +
        0.12 * memory_retention +
        0.12 * communication_openness +
        0.12 * interpretive_quality +
        0.12 * decision_revisability +
        0.12 * psychological_safety +
        0.10 * accountability_reach +
        0.06 * disconfirming_evidence -
        0.12 * institutional_inertia -
        0.10 * signal_distortion -
        0.08 * memory_decay -
        0.08 * defensive_routines -
        0.08 * power_protection -
        0.07 * feedback_delay;
}

int main(void) {
    double score = institutional_learning_score_raw(
        84.0, 78.0, 76.0, 80.0, 74.0, 77.0, 72.0,
        68.0, 25.0, 22.0, 18.0, 20.0, 24.0, 21.0
    );

    printf("Institutional learning raw score: %.2f\n", score);
    return 0;
}
