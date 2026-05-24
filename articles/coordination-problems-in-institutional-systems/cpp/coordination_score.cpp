#include <iostream>

struct CoordinationCase {
    double trust;
    double information_quality;
    double communication_clarity;
    double focal_salience;
    double authority_signal;
    double norm_strength;
    double learning_capacity;
    double uncertainty;
    double adaptation_burden;
    double competing_standards;
    double competing_authority;
    double distributional_attention;
};

double coordination_score_raw(const CoordinationCase& x) {
    return
        0.14 * x.trust +
        0.14 * x.information_quality +
        0.13 * x.communication_clarity +
        0.12 * x.focal_salience +
        0.10 * x.authority_signal +
        0.10 * x.norm_strength +
        0.09 * x.learning_capacity -
        0.13 * x.uncertainty -
        0.07 * x.adaptation_burden -
        0.06 * x.competing_standards -
        0.05 * x.competing_authority +
        0.04 * x.distributional_attention;
}

int main() {
    CoordinationCase demo {80, 78, 82, 76, 74, 70, 72, 30, 35, 25, 20, 68};
    std::cout << "Institutional coordination raw score: "
              << coordination_score_raw(demo) << std::endl;
    return 0;
}
