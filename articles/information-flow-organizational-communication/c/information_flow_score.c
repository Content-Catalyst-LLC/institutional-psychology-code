#include <stdio.h>

double information_flow_score_raw(
    double signal_quality,
    double communication_quality,
    double interpretive_integration,
    double feedback_usability,
    double memory_retention,
    double openness,
    double escalation_access,
    double trust,
    double community_voice,
    double digital_transparency,
    double distortion_loss,
    double overload,
    double siloing,
    double suppression_pressure,
    double metric_tunnel_vision
) {
    return
        0.12 * signal_quality +
        0.12 * communication_quality +
        0.12 * interpretive_integration +
        0.11 * feedback_usability +
        0.10 * memory_retention +
        0.11 * openness +
        0.09 * escalation_access +
        0.08 * trust +
        0.07 * community_voice +
        0.07 * digital_transparency -
        0.12 * distortion_loss -
        0.09 * overload -
        0.08 * siloing -
        0.08 * suppression_pressure -
        0.07 * metric_tunnel_vision;
}

int main(void) {
    double score = information_flow_score_raw(
        84.0, 78.0, 80.0, 76.0, 74.0, 77.0, 72.0, 75.0, 70.0, 73.0,
        24.0, 28.0, 22.0, 20.0, 26.0
    );

    printf("Information flow raw score: %.2f\n", score);
    return 0;
}
