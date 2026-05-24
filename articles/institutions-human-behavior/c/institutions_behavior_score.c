#include <stdio.h>

double institutional_strength_raw(
    double normative_stability,
    double legitimacy_strength,
    double incentive_alignment,
    double information_quality,
    double memory_retention,
    double learning_capacity,
    double trust_reinforcement,
    double role_clarity,
    double repair_capacity,
    double fragmentation_pressure,
    double opacity_pressure,
    double administrative_burden,
    double historical_harm_pressure
) {
    return
        0.13 * normative_stability +
        0.14 * legitimacy_strength +
        0.11 * incentive_alignment +
        0.12 * information_quality +
        0.11 * memory_retention +
        0.13 * learning_capacity +
        0.12 * trust_reinforcement +
        0.08 * role_clarity +
        0.08 * repair_capacity -
        0.12 * fragmentation_pressure -
        0.08 * opacity_pressure -
        0.08 * administrative_burden -
        0.07 * historical_harm_pressure;
}

int main(void) {
    double score = institutional_strength_raw(
        82.0, 84.0, 78.0, 80.0, 76.0, 79.0, 81.0, 77.0, 74.0,
        22.0, 20.0, 18.0, 16.0
    );

    printf("Institutional strength raw score: %.2f\n", score);
    return 0;
}
