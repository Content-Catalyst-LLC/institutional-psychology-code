#include <iostream>

struct CollectiveActionCase {
    double incentive_alignment;
    double trust;
    double legitimacy;
    double norm_strength;
    double enforcement_credibility;
    double communication_quality;
    double coordination_quality;
    double perceived_fairness;
    double free_riding_pressure;
    double burden_inequality;
    double hypocrisy_visibility;
    double scale_complexity;
};

double collective_action_score_raw(const CollectiveActionCase& x) {
    return
        0.12 * x.incentive_alignment +
        0.13 * x.trust +
        0.12 * x.legitimacy +
        0.11 * x.norm_strength +
        0.10 * x.enforcement_credibility +
        0.11 * x.communication_quality +
        0.11 * x.coordination_quality +
        0.10 * x.perceived_fairness -
        0.12 * x.free_riding_pressure -
        0.07 * x.burden_inequality -
        0.06 * x.hypocrisy_visibility -
        0.05 * x.scale_complexity;
}

int main() {
    CollectiveActionCase demo {78, 76, 74, 72, 70, 80, 75, 73, 30, 25, 20, 35};
    std::cout << "Collective action raw score: "
              << collective_action_score_raw(demo) << std::endl;
    return 0;
}
