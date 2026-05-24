#include <iostream>

struct BehavioralGovernanceCase {
    double incentive_alignment;
    double legitimacy;
    double norm_support;
    double cognitive_interpretability;
    double trust;
    double coordination_quality;
    double enforcement_credibility;
    double adaptive_learning;
    double perceived_fairness;
    double behavioral_burden;
    double hypocrisy_visibility;
    double power_asymmetry;
};

double behavioral_governance_score_raw(const BehavioralGovernanceCase& x) {
    return
        0.11 * x.incentive_alignment +
        0.13 * x.legitimacy +
        0.10 * x.norm_support +
        0.11 * x.cognitive_interpretability +
        0.12 * x.trust +
        0.11 * x.coordination_quality +
        0.10 * x.enforcement_credibility +
        0.11 * x.adaptive_learning +
        0.10 * x.perceived_fairness -
        0.10 * x.behavioral_burden -
        0.07 * x.hypocrisy_visibility -
        0.06 * x.power_asymmetry;
}

int main() {
    BehavioralGovernanceCase demo {78, 76, 72, 80, 74, 75, 70, 73, 77, 28, 20, 25};
    std::cout << "Behavioral governance raw score: "
              << behavioral_governance_score_raw(demo) << std::endl;
    return 0;
}
