#include <iostream>

struct InstitutionalLearningCase {
    double feedback_quality;
    double memory_retention;
    double communication_openness;
    double interpretive_quality;
    double decision_revisability;
    double psychological_safety;
    double accountability_reach;
    double disconfirming_evidence;
    double institutional_inertia;
    double signal_distortion;
    double memory_decay;
    double defensive_routines;
    double power_protection;
    double feedback_delay;
};

double institutional_learning_score_raw(const InstitutionalLearningCase& x) {
    return
        0.13 * x.feedback_quality +
        0.12 * x.memory_retention +
        0.12 * x.communication_openness +
        0.12 * x.interpretive_quality +
        0.12 * x.decision_revisability +
        0.12 * x.psychological_safety +
        0.10 * x.accountability_reach +
        0.06 * x.disconfirming_evidence -
        0.12 * x.institutional_inertia -
        0.10 * x.signal_distortion -
        0.08 * x.memory_decay -
        0.08 * x.defensive_routines -
        0.08 * x.power_protection -
        0.07 * x.feedback_delay;
}

int main() {
    InstitutionalLearningCase demo {84, 78, 76, 80, 74, 77, 72, 68, 25, 22, 18, 20, 24, 21};
    std::cout << "Institutional learning raw score: "
              << institutional_learning_score_raw(demo) << std::endl;
    return 0;
}
