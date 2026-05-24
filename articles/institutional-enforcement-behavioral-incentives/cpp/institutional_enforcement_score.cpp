#include <iostream>

struct InstitutionalEnforcementCase {
    double monitoring_quality;
    double legitimacy;
    double incentive_alignment;
    double sanction_credibility;
    double information_quality;
    double adaptive_learning;
    double accountability_reach;
    double compliance_burden;
    double selective_enforcement;
    double evasion_pressure;
    double hypocrisy_visibility;
    double defensive_compliance;
};

double institutional_enforcement_score_raw(const InstitutionalEnforcementCase& x) {
    return
        0.13 * x.monitoring_quality +
        0.13 * x.legitimacy +
        0.12 * x.incentive_alignment +
        0.12 * x.sanction_credibility +
        0.13 * x.information_quality +
        0.11 * x.adaptive_learning +
        0.10 * x.accountability_reach -
        0.08 * x.compliance_burden -
        0.08 * x.selective_enforcement -
        0.12 * x.evasion_pressure -
        0.06 * x.hypocrisy_visibility -
        0.06 * x.defensive_compliance;
}

int main() {
    InstitutionalEnforcementCase demo {82, 76, 74, 72, 80, 75, 70, 30, 24, 22, 18, 20};
    std::cout << "Institutional enforcement raw score: "
              << institutional_enforcement_score_raw(demo) << std::endl;
    return 0;
}
