#include <stdio.h>

double normative_stability_raw(
    double norm_repetition,
    double expectation_convergence,
    double internalization,
    double social_enforcement,
    double legitimacy_alignment,
    double trust_reinforcement,
    double role_clarity,
    double learning_capacity,
    double fragmentation_pressure,
    double unequal_normative_burden,
    double suppressive_pressure
) {
    return
        0.13 * norm_repetition +
        0.14 * expectation_convergence +
        0.13 * internalization +
        0.11 * social_enforcement +
        0.13 * legitimacy_alignment +
        0.11 * trust_reinforcement +
        0.09 * role_clarity +
        0.08 * learning_capacity -
        0.13 * fragmentation_pressure -
        0.10 * unequal_normative_burden -
        0.08 * suppressive_pressure;
}

int main(void) {
    double score = normative_stability_raw(
        82.0, 84.0, 78.0, 76.0, 80.0, 79.0, 77.0, 74.0,
        22.0, 20.0, 18.0
    );

    printf("Normative stability raw score: %.2f\n", score);
    return 0;
}
