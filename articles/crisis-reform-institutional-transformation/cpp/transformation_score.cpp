#include <cmath>
#include <iostream>

struct CrisisReformCase {
    double crisis_severity;
    double feedback_breakdown;
    double legitimacy_failure;
    double adaptive_capacity;
    double reform_window;
    double coalition_strength;
    double coordination_quality;
    double learning_rate;
    double governance_alignment;
    double power_concentration;
    double capture_risk;
    double distributional_attention;
};

double transformation_score_raw(const CrisisReformCase& x) {
    return
        0.15 * x.crisis_severity +
        0.11 * x.feedback_breakdown +
        0.14 * x.legitimacy_failure +
        0.10 * x.adaptive_capacity +
        0.12 * x.reform_window +
        0.12 * x.coalition_strength +
        0.08 * x.coordination_quality +
        0.06 * x.learning_rate +
        0.06 * x.governance_alignment +
        0.05 * x.distributional_attention -
        0.07 * x.capture_risk -
        0.04 * std::abs(x.power_concentration - 50.0);
}

int main() {
    CrisisReformCase demo {85, 78, 80, 70, 75, 68, 72, 65, 74, 55, 35, 80};
    std::cout << "Institutional transformation raw score: "
              << transformation_score_raw(demo) << std::endl;
    return 0;
}
