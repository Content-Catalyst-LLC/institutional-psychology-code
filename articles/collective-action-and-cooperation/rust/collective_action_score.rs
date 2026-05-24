struct CollectiveActionCase {
    incentive_alignment: f64,
    trust: f64,
    legitimacy: f64,
    norm_strength: f64,
    enforcement_credibility: f64,
    communication_quality: f64,
    coordination_quality: f64,
    perceived_fairness: f64,
    free_riding_pressure: f64,
    burden_inequality: f64,
    hypocrisy_visibility: f64,
    scale_complexity: f64,
}

fn collective_action_score_raw(x: &CollectiveActionCase) -> f64 {
    0.12 * x.incentive_alignment
        + 0.13 * x.trust
        + 0.12 * x.legitimacy
        + 0.11 * x.norm_strength
        + 0.10 * x.enforcement_credibility
        + 0.11 * x.communication_quality
        + 0.11 * x.coordination_quality
        + 0.10 * x.perceived_fairness
        - 0.12 * x.free_riding_pressure
        - 0.07 * x.burden_inequality
        - 0.06 * x.hypocrisy_visibility
        - 0.05 * x.scale_complexity
}

fn main() {
    let demo = CollectiveActionCase {
        incentive_alignment: 78.0,
        trust: 76.0,
        legitimacy: 74.0,
        norm_strength: 72.0,
        enforcement_credibility: 70.0,
        communication_quality: 80.0,
        coordination_quality: 75.0,
        perceived_fairness: 73.0,
        free_riding_pressure: 30.0,
        burden_inequality: 25.0,
        hypocrisy_visibility: 20.0,
        scale_complexity: 35.0,
    };

    println!(
        "Collective action raw score: {:.2}",
        collective_action_score_raw(&demo)
    );
}
