#include <stdio.h>

double path_dependence_score_raw(
    double initial_conditions,
    double behavioral_reinforcement,
    double feedback_strength,
    double increasing_returns,
    double coordination_effects,
    double learning_effects,
    double legitimacy,
    double switching_costs,
    double complementarity,
    double disruption_pressure,
    double reform_capacity
) {
    return
        0.08 * initial_conditions +
        0.12 * behavioral_reinforcement +
        0.12 * feedback_strength +
        0.13 * increasing_returns +
        0.11 * coordination_effects +
        0.10 * learning_effects +
        0.12 * legitimacy +
        0.12 * switching_costs +
        0.10 * complementarity -
        0.12 * disruption_pressure -
        0.05 * reform_capacity;
}

int main(void) {
    double score = path_dependence_score_raw(
        80.0, 75.0, 70.0, 82.0, 78.0, 74.0,
        85.0, 88.0, 79.0, 35.0, 40.0
    );

    printf("Institutional path dependence raw score: %.2f\n", score);
    return 0;
}
