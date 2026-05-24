#include <stdio.h>

double institutional_resilience(
    double robustness,
    double adaptive_capacity,
    double recovery_capacity,
    double transformational_capacity,
    double legitimacy,
    double trust,
    double feedback_quality,
    double learning_rate,
    double redundancy,
    double modularity,
    double coordination,
    double shock_intensity
) {
    return
        0.10 * robustness +
        0.12 * adaptive_capacity +
        0.10 * recovery_capacity +
        0.08 * transformational_capacity +
        0.12 * legitimacy +
        0.10 * trust +
        0.10 * feedback_quality +
        0.08 * learning_rate +
        0.07 * redundancy +
        0.05 * modularity +
        0.08 * coordination -
        0.10 * shock_intensity;
}

int main(void) {
    double score = institutional_resilience(
        80.0, 75.0, 70.0, 60.0, 85.0, 82.0,
        78.0, 74.0, 65.0, 68.0, 80.0, 50.0
    );

    printf("Institutional resilience raw score: %.2f\n", score);
    return 0;
}
