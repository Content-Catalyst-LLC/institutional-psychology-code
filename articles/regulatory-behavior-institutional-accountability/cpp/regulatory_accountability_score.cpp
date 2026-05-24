#include <iostream>

struct RegulatoryAccountabilityCase {
    double oversight_strength;
    double legitimacy;
    double incentive_alignment;
    double enforcement_credibility;
    double information_quality;
    double adaptive_learning;
    double accountability_reach;
    double capture_pressure;
    double regulatory_burden;
    double evasion_pressure;
    double hypocrisy_visibility;
    double unequal_accountability;
};

double regulatory_accountability_score_raw(const RegulatoryAccountabilityCase& x) {
    return
        0.13 * x.oversight_strength +
        0.13 * x.legitimacy +
        0.11 * x.incentive_alignment +
        0.12 * x.enforcement_credibility +
        0.13 * x.information_quality +
        0.11 * x.adaptive_learning +
        0.11 * x.accountability_reach -
        0.12 * x.capture_pressure -
        0.08 * x.regulatory_burden -
        0.07 * x.evasion_pressure -
        0.06 * x.hypocrisy_visibility -
        0.06 * x.unequal_accountability;
}

int main() {
    RegulatoryAccountabilityCase demo {82, 76, 74, 72, 80, 75, 70, 25, 30, 22, 18, 24};
    std::cout << "Regulatory accountability raw score: "
              << regulatory_accountability_score_raw(demo) << std::endl;
    return 0;
}
