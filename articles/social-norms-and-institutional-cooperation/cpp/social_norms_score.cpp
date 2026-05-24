#include <iostream>

struct SocialNormsCase {
    double descriptive_norm;
    double injunctive_norm;
    double trust;
    double legitimacy;
    double sanction_intensity;
    double transmission_strength;
    double institutional_reinforcement;
    double norm_conflict;
    double hypocrisy_visibility;
    double unequal_enforcement;
    double performative_compliance;
    double distributional_attention;
};

double social_norms_cooperation_score_raw(const SocialNormsCase& x) {
    return
        0.14 * x.descriptive_norm +
        0.14 * x.injunctive_norm +
        0.13 * x.trust +
        0.12 * x.legitimacy +
        0.10 * x.sanction_intensity +
        0.11 * x.transmission_strength +
        0.12 * x.institutional_reinforcement -
        0.13 * x.norm_conflict -
        0.08 * x.hypocrisy_visibility -
        0.07 * x.unequal_enforcement -
        0.05 * x.performative_compliance +
        0.04 * x.distributional_attention;
}

int main() {
    SocialNormsCase demo {80, 78, 75, 72, 60, 74, 82, 30, 25, 20, 25, 70};
    std::cout << "Social norms cooperation raw score: "
              << social_norms_cooperation_score_raw(demo) << std::endl;
    return 0;
}
