#include <iostream>

struct PublicGoodsCase {
    double contribution_rate;
    double legitimacy;
    double trust;
    double coordination;
    double monitoring;
    double distributional_attention;
    double scale_complexity;
    double capture_risk;
};

double public_goods_provision_score_raw(const PublicGoodsCase& x) {
    return
        0.22 * x.contribution_rate +
        0.13 * x.legitimacy +
        0.12 * x.trust +
        0.11 * x.coordination +
        0.10 * x.monitoring +
        0.08 * x.distributional_attention -
        0.12 * x.scale_complexity -
        0.08 * x.capture_risk;
}

int main() {
    PublicGoodsCase demo {70, 78, 75, 72, 80, 74, 35, 25};
    std::cout << "Public goods provision raw score: "
              << public_goods_provision_score_raw(demo) << std::endl;
    return 0;
}
