#include <iostream>

struct BiasDecisionCase {
    double overconfidence;
    double conformity_pressure;
    double filtering_distortion;
    double path_lock_in;
    double metric_tunnel_vision;
    double power_protection;
    double dissent_capacity;
    double corrective_review;
    double information_quality;
    double feedback_openness;
    double psychological_safety;
    double justice_voice;
};

double decision_quality_raw(const BiasDecisionCase& x) {
    return
        0.14 * x.dissent_capacity +
        0.14 * x.corrective_review +
        0.14 * x.information_quality +
        0.13 * x.feedback_openness +
        0.11 * x.psychological_safety +
        0.10 * x.justice_voice -
        0.13 * x.overconfidence -
        0.13 * x.conformity_pressure -
        0.14 * x.filtering_distortion -
        0.12 * x.path_lock_in -
        0.10 * x.metric_tunnel_vision -
        0.09 * x.power_protection;
}

int main() {
    BiasDecisionCase demo {22, 25, 24, 28, 20, 21, 82, 80, 84, 78, 76, 72};
    std::cout << "Institutional decision quality raw score: "
              << decision_quality_raw(demo) << std::endl;
    return 0;
}
