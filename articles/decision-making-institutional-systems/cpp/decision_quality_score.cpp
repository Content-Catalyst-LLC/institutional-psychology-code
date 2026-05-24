#include <iostream>

struct DecisionQualityCase {
    double bounded_rationality_pressure;
    double organizational_structure_quality;
    double incentive_alignment;
    double information_flow_effectiveness;
    double legitimacy;
    double uncertainty_management;
    double corrective_capacity;
    double justice_voice;
    double memory_quality;
    double feedback_openness;
    double bias_distortion;
    double power_protection;
    double metric_fixation;
    double siloing;
    double premature_closure;
};

double decision_quality_raw(const DecisionQualityCase& x) {
    return
        0.12 * x.organizational_structure_quality +
        0.12 * x.incentive_alignment +
        0.13 * x.information_flow_effectiveness +
        0.11 * x.legitimacy +
        0.11 * x.uncertainty_management +
        0.13 * x.corrective_capacity +
        0.09 * x.justice_voice +
        0.08 * x.memory_quality +
        0.08 * x.feedback_openness -
        0.13 * x.bounded_rationality_pressure -
        0.11 * x.bias_distortion -
        0.09 * x.power_protection -
        0.08 * x.metric_fixation -
        0.07 * x.siloing -
        0.07 * x.premature_closure;
}

int main() {
    DecisionQualityCase demo {24, 82, 78, 84, 80, 76, 82, 72, 74, 78, 22, 20, 24, 18, 21};
    std::cout << "Institutional decision quality raw score: "
              << decision_quality_raw(demo) << std::endl;
    return 0;
}
