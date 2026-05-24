#include <stdio.h>

double decision_quality_raw(
    double bounded_rationality_pressure,
    double organizational_structure_quality,
    double incentive_alignment,
    double information_flow_effectiveness,
    double legitimacy,
    double uncertainty_management,
    double corrective_capacity,
    double justice_voice,
    double memory_quality,
    double feedback_openness,
    double bias_distortion,
    double power_protection,
    double metric_fixation,
    double siloing,
    double premature_closure
) {
    return
        0.12 * organizational_structure_quality +
        0.12 * incentive_alignment +
        0.13 * information_flow_effectiveness +
        0.11 * legitimacy +
        0.11 * uncertainty_management +
        0.13 * corrective_capacity +
        0.09 * justice_voice +
        0.08 * memory_quality +
        0.08 * feedback_openness -
        0.13 * bounded_rationality_pressure -
        0.11 * bias_distortion -
        0.09 * power_protection -
        0.08 * metric_fixation -
        0.07 * siloing -
        0.07 * premature_closure;
}

int main(void) {
    double score = decision_quality_raw(
        24.0, 82.0, 78.0, 84.0, 80.0, 76.0, 82.0, 72.0, 74.0, 78.0,
        22.0, 20.0, 24.0, 18.0, 21.0
    );

    printf("Institutional decision quality raw score: %.2f\n", score);
    return 0;
}
