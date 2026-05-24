#include <stdio.h>

double authority_legitimacy_raw(
    double formal_authority_clarity,
    double procedural_legitimacy,
    double outcome_legitimacy,
    double trust,
    double rule_clarity,
    double social_recognition,
    double accountability,
    double repair_capacity,
    double fairness,
    double arbitrariness_pressure,
    double visible_inconsistency,
    double unequal_burden,
    double opacity_pressure
) {
    return
        0.11 * formal_authority_clarity +
        0.14 * procedural_legitimacy +
        0.12 * outcome_legitimacy +
        0.13 * trust +
        0.11 * rule_clarity +
        0.11 * social_recognition +
        0.12 * accountability +
        0.10 * repair_capacity +
        0.10 * fairness -
        0.14 * arbitrariness_pressure -
        0.10 * visible_inconsistency -
        0.09 * unequal_burden -
        0.08 * opacity_pressure;
}

int main(void) {
    double score = authority_legitimacy_raw(
        82.0, 84.0, 78.0, 80.0, 82.0, 76.0, 79.0, 74.0, 81.0,
        22.0, 20.0, 18.0, 19.0
    );

    printf("Authority-legitimacy raw score: %.2f\n", score);
    return 0;
}
