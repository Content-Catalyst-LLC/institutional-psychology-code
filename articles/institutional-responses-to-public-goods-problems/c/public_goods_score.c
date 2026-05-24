#include <stdio.h>

double public_goods_provision_score_raw(
    double contribution_rate,
    double legitimacy,
    double trust,
    double coordination,
    double monitoring,
    double distributional_attention,
    double scale_complexity,
    double capture_risk
) {
    return
        0.22 * contribution_rate +
        0.13 * legitimacy +
        0.12 * trust +
        0.11 * coordination +
        0.10 * monitoring +
        0.08 * distributional_attention -
        0.12 * scale_complexity -
        0.08 * capture_risk;
}

int main(void) {
    double score = public_goods_provision_score_raw(
        70.0, 78.0, 75.0, 72.0, 80.0, 74.0, 35.0, 25.0
    );

    printf("Public goods provision raw score: %.2f\n", score);
    return 0;
}
