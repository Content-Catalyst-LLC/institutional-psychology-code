#include <iostream>

// Toy institutional effectiveness score.
// Compile with: g++ cpp/institutional_effectiveness.cpp -o outputs/institutional_effectiveness

int main() {
    double legitimacy = 0.72;
    double normative_stability = 0.68;
    double trust = 0.64;
    double cognition = 0.70;
    double information_flow = 0.66;
    double memory = 0.58;
    double learning = 0.62;
    double fragmentation = 0.30;

    double effectiveness =
        0.14 * legitimacy +
        0.14 * normative_stability +
        0.13 * trust +
        0.12 * cognition +
        0.12 * information_flow +
        0.12 * memory +
        0.13 * learning -
        0.16 * fragmentation;

    std::cout << "Institutional effectiveness score: " << effectiveness << "\n";
    return 0;
}
