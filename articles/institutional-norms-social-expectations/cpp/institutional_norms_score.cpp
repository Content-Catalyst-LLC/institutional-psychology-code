#include <iostream>

struct NormCase {
    double norm_repetition;
    double expectation_convergence;
    double internalization;
    double social_enforcement;
    double legitimacy_alignment;
    double trust_reinforcement;
    double role_clarity;
    double learning_capacity;
    double fragmentation_pressure;
    double unequal_normative_burden;
    double suppressive_pressure;
};

double normative_stability_raw(const NormCase& x) {
    return
        0.13 * x.norm_repetition +
        0.14 * x.expectation_convergence +
        0.13 * x.internalization +
        0.11 * x.social_enforcement +
        0.13 * x.legitimacy_alignment +
        0.11 * x.trust_reinforcement +
        0.09 * x.role_clarity +
        0.08 * x.learning_capacity -
        0.13 * x.fragmentation_pressure -
        0.10 * x.unequal_normative_burden -
        0.08 * x.suppressive_pressure;
}

int main() {
    NormCase demo {82, 84, 78, 76, 80, 79, 77, 74, 22, 20, 18};
    std::cout << "Normative stability raw score: "
              << normative_stability_raw(demo) << std::endl;
    return 0;
}
