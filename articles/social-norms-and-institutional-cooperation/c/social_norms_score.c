#include <stdio.h>

double social_norms_cooperation_score_raw(
    double descriptive_norm,
    double injunctive_norm,
    double trust,
    double legitimacy,
    double sanction_intensity,
    double transmission_strength,
    double institutional_reinforcement,
    double norm_conflict,
    double hypocrisy_visibility,
    double unequal_enforcement,
    double performative_compliance,
    double distributional_attention
) {
    return
        0.14 * descriptive_norm +
        0.14 * injunctive_norm +
        0.13 * trust +
        0.12 * legitimacy +
        0.10 * sanction_intensity +
        0.11 * transmission_strength +
        0.12 * institutional_reinforcement -
        0.13 * norm_conflict -
        0.08 * hypocrisy_visibility -
        0.07 * unequal_enforcement -
        0.05 * performative_compliance +
        0.04 * distributional_attention;
}

int main(void) {
    double score = social_norms_cooperation_score_raw(
        80.0, 78.0, 75.0, 72.0, 60.0, 74.0,
        82.0, 30.0, 25.0, 20.0, 25.0, 70.0
    );

    printf("Social norms cooperation raw score: %.2f\n", score);
    return 0;
}
