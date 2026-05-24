#include <stdio.h>

double decision_quality_raw(
    double overconfidence,
    double conformity_pressure,
    double filtering_distortion,
    double path_lock_in,
    double metric_tunnel_vision,
    double power_protection,
    double dissent_capacity,
    double corrective_review,
    double information_quality,
    double feedback_openness,
    double psychological_safety,
    double justice_voice
) {
    return
        0.14 * dissent_capacity +
        0.14 * corrective_review +
        0.14 * information_quality +
        0.13 * feedback_openness +
        0.11 * psychological_safety +
        0.10 * justice_voice -
        0.13 * overconfidence -
        0.13 * conformity_pressure -
        0.14 * filtering_distortion -
        0.12 * path_lock_in -
        0.10 * metric_tunnel_vision -
        0.09 * power_protection;
}

int main(void) {
    double score = decision_quality_raw(
        22.0, 25.0, 24.0, 28.0, 20.0, 21.0,
        82.0, 80.0, 84.0, 78.0, 76.0, 72.0
    );

    printf("Institutional decision quality raw score: %.2f\n", score);
    return 0;
}
