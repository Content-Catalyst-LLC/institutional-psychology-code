#include <iostream>

struct InstitutionalChangeCase {
    double feedback_quality;
    double adaptive_capacity;
    double legitimacy;
    double incentive_alignment;
    double normative_support;
    double governance_capacity;
    double path_dependence;
    double behavioral_flexibility;
    double coordination_quality;
    double environmental_change;
    double distributional_attention;
    double transition_burden;
};

double institutional_change_score_raw(const InstitutionalChangeCase& x) {
    return
        0.13 * x.feedback_quality +
        0.14 * x.adaptive_capacity +
        0.10 * x.legitimacy +
        0.10 * x.incentive_alignment +
        0.09 * x.normative_support +
        0.12 * x.governance_capacity -
        0.12 * x.path_dependence +
        0.10 * x.behavioral_flexibility +
        0.08 * x.coordination_quality +
        0.06 * x.environmental_change +
        0.05 * x.distributional_attention -
        0.05 * x.transition_burden;
}

int main() {
    InstitutionalChangeCase demo {80, 78, 75, 70, 72, 82, 40, 76, 74, 65, 70, 35};
    std::cout << "Institutional change raw score: "
              << institutional_change_score_raw(demo) << std::endl;
    return 0;
}
