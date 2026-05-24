#include <stdio.h>

double coordination_score_raw(
    double trust,
    double information_quality,
    double communication_clarity,
    double focal_salience,
    double authority_signal,
    double norm_strength,
    double learning_capacity,
    double uncertainty,
    double adaptation_burden,
    double competing_standards,
    double competing_authority,
    double distributional_attention
) {
    return
        0.14 * trust +
        0.14 * information_quality +
        0.13 * communication_clarity +
        0.12 * focal_salience +
        0.10 * authority_signal +
        0.10 * norm_strength +
        0.09 * learning_capacity -
        0.13 * uncertainty -
        0.07 * adaptation_burden -
        0.06 * competing_standards -
        0.05 * competing_authority +
        0.04 * distributional_attention;
}

int main(void) {
    double score = coordination_score_raw(
        80.0, 78.0, 82.0, 76.0, 74.0, 70.0,
        72.0, 30.0, 35.0, 25.0, 20.0, 68.0
    );

    printf("Institutional coordination raw score: %.2f\n", score);
    return 0;
}
