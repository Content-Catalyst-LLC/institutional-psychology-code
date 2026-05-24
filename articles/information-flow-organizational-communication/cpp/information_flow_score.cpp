#include <iostream>

struct InformationFlowCase {
    double signal_quality;
    double communication_quality;
    double interpretive_integration;
    double feedback_usability;
    double memory_retention;
    double openness;
    double escalation_access;
    double trust;
    double community_voice;
    double digital_transparency;
    double distortion_loss;
    double overload;
    double siloing;
    double suppression_pressure;
    double metric_tunnel_vision;
};

double information_flow_score_raw(const InformationFlowCase& x) {
    return
        0.12 * x.signal_quality +
        0.12 * x.communication_quality +
        0.12 * x.interpretive_integration +
        0.11 * x.feedback_usability +
        0.10 * x.memory_retention +
        0.11 * x.openness +
        0.09 * x.escalation_access +
        0.08 * x.trust +
        0.07 * x.community_voice +
        0.07 * x.digital_transparency -
        0.12 * x.distortion_loss -
        0.09 * x.overload -
        0.08 * x.siloing -
        0.08 * x.suppression_pressure -
        0.07 * x.metric_tunnel_vision;
}

int main() {
    InformationFlowCase demo {84, 78, 80, 76, 74, 77, 72, 75, 70, 73, 24, 28, 22, 20, 26};
    std::cout << "Information flow raw score: "
              << information_flow_score_raw(demo) << std::endl;
    return 0;
}
