#include <stdio.h>

// Toy institutional alignment utility.
// Compile with: cc c/alignment_score.c -o outputs/alignment_score

double alignment_score(double legitimacy, double expectation, double trust, double norm_support, double role_id, double uncertainty) {
    return 0.20 * legitimacy + 0.18 * expectation + 0.20 * trust + 0.16 * norm_support + 0.14 * role_id - 0.20 * uncertainty;
}

int main(void) {
    double score = alignment_score(0.75, 0.70, 0.68, 0.65, 0.60, 0.25);
    printf("Institutional alignment score: %.3f\n", score);
    return 0;
}
