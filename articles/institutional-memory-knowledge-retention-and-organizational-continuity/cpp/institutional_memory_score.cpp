#include <iostream>

struct InstitutionalMemoryCase {
    double documented_retention;
    double tacit_transfer;
    double accessibility;
    double interpretive_use;
    double revisability;
    double technical_continuity;
    double metadata_quality;
    double distributed_integration;
    double memory_justice;
    double path_dependence_pressure;
    double loss_fragmentation;
    double selective_narration;
    double turnover_pressure;
    double key_person_dependency;
};

double institutional_memory_score_raw(const InstitutionalMemoryCase& x) {
    return
        0.12 * x.documented_retention +
        0.12 * x.tacit_transfer +
        0.12 * x.accessibility +
        0.12 * x.interpretive_use +
        0.11 * x.revisability +
        0.09 * x.technical_continuity +
        0.08 * x.metadata_quality +
        0.08 * x.distributed_integration +
        0.08 * x.memory_justice -
        0.11 * x.path_dependence_pressure -
        0.11 * x.loss_fragmentation -
        0.08 * x.selective_narration -
        0.07 * x.turnover_pressure -
        0.06 * x.key_person_dependency;
}

int main() {
    InstitutionalMemoryCase demo {84, 78, 80, 76, 74, 79, 82, 72, 70, 24, 22, 20, 26, 28};
    std::cout << "Institutional memory raw score: "
              << institutional_memory_score_raw(demo) << std::endl;
    return 0;
}
