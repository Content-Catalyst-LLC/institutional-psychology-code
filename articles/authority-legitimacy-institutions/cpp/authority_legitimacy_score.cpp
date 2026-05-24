#include <iostream>

struct LegitimacyCase {
    double formal_authority_clarity;
    double procedural_legitimacy;
    double outcome_legitimacy;
    double trust;
    double rule_clarity;
    double social_recognition;
    double accountability;
    double repair_capacity;
    double fairness;
    double arbitrariness_pressure;
    double visible_inconsistency;
    double unequal_burden;
    double opacity_pressure;
};

double authority_legitimacy_raw(const LegitimacyCase& x) {
    return
        0.11 * x.formal_authority_clarity +
        0.14 * x.procedural_legitimacy +
        0.12 * x.outcome_legitimacy +
        0.13 * x.trust +
        0.11 * x.rule_clarity +
        0.11 * x.social_recognition +
        0.12 * x.accountability +
        0.10 * x.repair_capacity +
        0.10 * x.fairness -
        0.14 * x.arbitrariness_pressure -
        0.10 * x.visible_inconsistency -
        0.09 * x.unequal_burden -
        0.08 * x.opacity_pressure;
}

int main() {
    LegitimacyCase demo {82, 84, 78, 80, 82, 76, 79, 74, 81, 22, 20, 18, 19};
    std::cout << "Authority-legitimacy raw score: "
              << authority_legitimacy_raw(demo) << std::endl;
    return 0;
}
