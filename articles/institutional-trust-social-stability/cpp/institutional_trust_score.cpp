#include <iostream>

struct TrustCase {
    double consistency;
    double competence;
    double fairness;
    double transparency;
    double accountability;
    double integrity;
    double recognition_voice;
    double repair_capacity;
    double arbitrariness_pressure;
    double visible_violation_pressure;
    double administrative_burden;
};

double trust_score_raw(const TrustCase& x) {
    return
        0.11 * x.consistency +
        0.12 * x.competence +
        0.14 * x.fairness +
        0.10 * x.transparency +
        0.13 * x.accountability +
        0.12 * x.integrity +
        0.09 * x.recognition_voice +
        0.09 * x.repair_capacity -
        0.13 * x.arbitrariness_pressure -
        0.11 * x.visible_violation_pressure -
        0.08 * x.administrative_burden;
}

int main() {
    TrustCase demo {82, 80, 84, 78, 82, 79, 76, 74, 22, 20, 18};
    std::cout << "Institutional trust raw score: "
              << trust_score_raw(demo) << std::endl;
    return 0;
}
