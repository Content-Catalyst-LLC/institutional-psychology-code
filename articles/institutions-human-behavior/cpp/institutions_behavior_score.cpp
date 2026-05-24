#include <iostream>

struct InstitutionCase {
    double normative_stability;
    double legitimacy_strength;
    double incentive_alignment;
    double information_quality;
    double memory_retention;
    double learning_capacity;
    double trust_reinforcement;
    double role_clarity;
    double repair_capacity;
    double fragmentation_pressure;
    double opacity_pressure;
    double administrative_burden;
    double historical_harm_pressure;
};

double institutional_strength_raw(const InstitutionCase& x) {
    return
        0.13 * x.normative_stability +
        0.14 * x.legitimacy_strength +
        0.11 * x.incentive_alignment +
        0.12 * x.information_quality +
        0.11 * x.memory_retention +
        0.13 * x.learning_capacity +
        0.12 * x.trust_reinforcement +
        0.08 * x.role_clarity +
        0.08 * x.repair_capacity -
        0.12 * x.fragmentation_pressure -
        0.08 * x.opacity_pressure -
        0.08 * x.administrative_burden -
        0.07 * x.historical_harm_pressure;
}

int main() {
    InstitutionCase demo {82, 84, 78, 80, 76, 79, 81, 77, 74, 22, 20, 18, 16};
    std::cout << "Institutional strength raw score: "
              << institutional_strength_raw(demo) << std::endl;
    return 0;
}
