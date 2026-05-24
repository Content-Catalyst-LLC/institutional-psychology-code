#include <stdio.h>

double trust_score_raw(
    double consistency,
    double competence,
    double fairness,
    double transparency,
    double accountability,
    double integrity,
    double recognition_voice,
    double repair_capacity,
    double arbitrariness_pressure,
    double visible_violation_pressure,
    double administrative_burden
) {
    return
        0.11 * consistency +
        0.12 * competence +
        0.14 * fairness +
        0.10 * transparency +
        0.13 * accountability +
        0.12 * integrity +
        0.09 * recognition_voice +
        0.09 * repair_capacity -
        0.13 * arbitrariness_pressure -
        0.11 * visible_violation_pressure -
        0.08 * administrative_burden;
}

int main(void) {
    double score = trust_score_raw(
        82.0, 80.0, 84.0, 78.0, 82.0, 79.0, 76.0, 74.0,
        22.0, 20.0, 18.0
    );

    printf("Institutional trust raw score: %.2f\n", score);
    return 0;
}
