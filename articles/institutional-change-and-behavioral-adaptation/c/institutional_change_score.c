#include <stdio.h>

double institutional_change_score_raw(
    double feedback_quality,
    double adaptive_capacity,
    double legitimacy,
    double incentive_alignment,
    double normative_support,
    double governance_capacity,
    double path_dependence,
    double behavioral_flexibility,
    double coordination_quality,
    double environmental_change,
    double distributional_attention,
    double transition_burden
) {
    return
        0.13 * feedback_quality +
        0.14 * adaptive_capacity +
        0.10 * legitimacy +
        0.10 * incentive_alignment +
        0.09 * normative_support +
        0.12 * governance_capacity -
        0.12 * path_dependence +
        0.10 * behavioral_flexibility +
        0.08 * coordination_quality +
        0.06 * environmental_change +
        0.05 * distributional_attention -
        0.05 * transition_burden;
}

int main(void) {
    double score = institutional_change_score_raw(
        80.0, 78.0, 75.0, 70.0, 72.0, 82.0,
        40.0, 76.0, 74.0, 65.0, 70.0, 35.0
    );

    printf("Institutional change raw score: %.2f\n", score);
    return 0;
}
