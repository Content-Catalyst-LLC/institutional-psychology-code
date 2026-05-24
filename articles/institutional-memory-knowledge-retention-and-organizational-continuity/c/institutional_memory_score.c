#include <stdio.h>

double institutional_memory_score_raw(
    double documented_retention,
    double tacit_transfer,
    double accessibility,
    double interpretive_use,
    double revisability,
    double technical_continuity,
    double metadata_quality,
    double distributed_integration,
    double memory_justice,
    double path_dependence_pressure,
    double loss_fragmentation,
    double selective_narration,
    double turnover_pressure,
    double key_person_dependency
) {
    return
        0.12 * documented_retention +
        0.12 * tacit_transfer +
        0.12 * accessibility +
        0.12 * interpretive_use +
        0.11 * revisability +
        0.09 * technical_continuity +
        0.08 * metadata_quality +
        0.08 * distributed_integration +
        0.08 * memory_justice -
        0.11 * path_dependence_pressure -
        0.11 * loss_fragmentation -
        0.08 * selective_narration -
        0.07 * turnover_pressure -
        0.06 * key_person_dependency;
}

int main(void) {
    double score = institutional_memory_score_raw(
        84.0, 78.0, 80.0, 76.0, 74.0, 79.0, 82.0,
        72.0, 70.0, 24.0, 22.0, 20.0, 26.0, 28.0
    );

    printf("Institutional memory raw score: %.2f\n", score);
    return 0;
}
