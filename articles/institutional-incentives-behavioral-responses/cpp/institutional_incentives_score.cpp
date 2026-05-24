#include <iostream>

struct InstitutionalIncentiveCase {
    double value_alignment;
    double fairness;
    double information_quality;
    double legitimacy;
    double learning_support;
    double accountability;
    double bias_pressure;
    double metric_substitution;
    double reporting_distortion;
    double behavioral_burden;
    double short_termism;
    double status_inequality;
    double motivation_crowding;
};

double institutional_incentive_score_raw(const InstitutionalIncentiveCase& x) {
    return
        0.14 * x.value_alignment +
        0.12 * x.fairness +
        0.13 * x.information_quality +
        0.12 * x.legitimacy +
        0.12 * x.learning_support +
        0.10 * x.accountability -
        0.10 * x.bias_pressure -
        0.12 * x.metric_substitution -
        0.09 * x.reporting_distortion -
        0.08 * x.behavioral_burden -
        0.07 * x.short_termism -
        0.06 * x.status_inequality -
        0.05 * x.motivation_crowding;
}

int main() {
    InstitutionalIncentiveCase demo {82, 76, 80, 78, 75, 72, 25, 22, 20, 28, 24, 18, 21};
    std::cout << "Institutional incentive raw score: "
              << institutional_incentive_score_raw(demo) << std::endl;
    return 0;
}
