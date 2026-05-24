#include <iostream>

struct PathDependenceCase {
    double initial_conditions;
    double behavioral_reinforcement;
    double feedback_strength;
    double increasing_returns;
    double coordination_effects;
    double learning_effects;
    double legitimacy;
    double switching_costs;
    double complementarity;
    double disruption_pressure;
    double reform_capacity;
};

double path_dependence_score_raw(const PathDependenceCase& x) {
    return
        0.08 * x.initial_conditions +
        0.12 * x.behavioral_reinforcement +
        0.12 * x.feedback_strength +
        0.13 * x.increasing_returns +
        0.11 * x.coordination_effects +
        0.10 * x.learning_effects +
        0.12 * x.legitimacy +
        0.12 * x.switching_costs +
        0.10 * x.complementarity -
        0.12 * x.disruption_pressure -
        0.05 * x.reform_capacity;
}

int main() {
    PathDependenceCase demo {80, 75, 70, 82, 78, 74, 85, 88, 79, 35, 40};
    std::cout << "Institutional path dependence raw score: "
              << path_dependence_score_raw(demo) << std::endl;
    return 0;
}
