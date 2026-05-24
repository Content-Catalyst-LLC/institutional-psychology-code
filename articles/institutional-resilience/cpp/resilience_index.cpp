#include <iostream>
#include <vector>
#include <numeric>

struct Institution {
    double robustness;
    double adaptive_capacity;
    double recovery_capacity;
    double transformational_capacity;
    double legitimacy;
    double trust;
    double feedback_quality;
    double learning_rate;
    double redundancy;
    double modularity;
    double coordination;
    double shock_intensity;
};

double resilience_index(const Institution& x) {
    return
        0.10 * x.robustness +
        0.12 * x.adaptive_capacity +
        0.10 * x.recovery_capacity +
        0.08 * x.transformational_capacity +
        0.12 * x.legitimacy +
        0.10 * x.trust +
        0.10 * x.feedback_quality +
        0.08 * x.learning_rate +
        0.07 * x.redundancy +
        0.05 * x.modularity +
        0.08 * x.coordination -
        0.10 * x.shock_intensity;
}

int main() {
    Institution demo {80, 75, 70, 60, 85, 82, 78, 74, 65, 68, 80, 50};
    std::cout << "Institutional resilience raw score: "
              << resilience_index(demo) << std::endl;
    return 0;
}
