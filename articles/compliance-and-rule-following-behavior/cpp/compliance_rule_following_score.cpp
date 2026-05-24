#include <iostream>

struct ComplianceCase {
    double legitimacy;
    double fairness;
    double incentive_alignment;
    double norm_support;
    double enforcement_credibility;
    double communication_quality;
    double cognitive_clarity;
    double trust;
    double adaptive_learning;
    double compliance_burden;
    double selective_rule_application;
    double defensive_compliance;
    double hypocrisy_visibility;
    double norm_failure;
};

double compliance_quality_score_raw(const ComplianceCase& x) {
    return
        0.13 * x.legitimacy +
        0.13 * x.fairness +
        0.11 * x.incentive_alignment +
        0.11 * x.norm_support +
        0.10 * x.enforcement_credibility +
        0.11 * x.communication_quality +
        0.12 * x.cognitive_clarity +
        0.11 * x.trust +
        0.09 * x.adaptive_learning -
        0.11 * x.compliance_burden -
        0.08 * x.selective_rule_application -
        0.06 * x.defensive_compliance -
        0.05 * x.hypocrisy_visibility -
        0.05 * x.norm_failure;
}

int main() {
    ComplianceCase demo {76, 78, 72, 74, 70, 80, 82, 75, 73, 28, 24, 20, 18, 22};
    std::cout << "Compliance quality raw score: "
              << compliance_quality_score_raw(demo) << std::endl;
    return 0;
}
