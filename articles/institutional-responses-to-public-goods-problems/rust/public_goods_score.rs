struct PublicGoodsCase {
    contribution_rate: f64,
    legitimacy: f64,
    trust: f64,
    coordination: f64,
    monitoring: f64,
    distributional_attention: f64,
    scale_complexity: f64,
    capture_risk: f64,
}

fn public_goods_provision_score_raw(x: &PublicGoodsCase) -> f64 {
    0.22 * x.contribution_rate
        + 0.13 * x.legitimacy
        + 0.12 * x.trust
        + 0.11 * x.coordination
        + 0.10 * x.monitoring
        + 0.08 * x.distributional_attention
        - 0.12 * x.scale_complexity
        - 0.08 * x.capture_risk
}

fn main() {
    let demo = PublicGoodsCase {
        contribution_rate: 70.0,
        legitimacy: 78.0,
        trust: 75.0,
        coordination: 72.0,
        monitoring: 80.0,
        distributional_attention: 74.0,
        scale_complexity: 35.0,
        capture_risk: 25.0,
    };

    println!(
        "Public goods provision raw score: {:.2}",
        public_goods_provision_score_raw(&demo)
    );
}
