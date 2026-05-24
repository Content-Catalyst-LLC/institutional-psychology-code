struct BehavioralGovernanceCase {
    incentive_alignment: f64,
    legitimacy: f64,
    norm_support: f64,
    cognitive_interpretability: f64,
    trust: f64,
    coordination_quality: f64,
    enforcement_credibility: f64,
    adaptive_learning: f64,
    perceived_fairness: f64,
    behavioral_burden: f64,
    hypocrisy_visibility: f64,
    power_asymmetry: f64,
}

fn behavioral_governance_score_raw(x: &BehavioralGovernanceCase) -> f64 {
    0.11 * x.incentive_alignment
        + 0.13 * x.legitimacy
        + 0.10 * x.norm_support
        + 0.11 * x.cognitive_interpretability
        + 0.12 * x.trust
        + 0.11 * x.coordination_quality
        + 0.10 * x.enforcement_credibility
        + 0.11 * x.adaptive_learning
        + 0.10 * x.perceived_fairness
        - 0.10 * x.behavioral_burden
        - 0.07 * x.hypocrisy_visibility
        - 0.06 * x.power_asymmetry
}

fn main() {
    let demo = BehavioralGovernanceCase {
        incentive_alignment: 78.0,
        legitimacy: 76.0,
        norm_support: 72.0,
        cognitive_interpretability: 80.0,
        trust: 74.0,
        coordination_quality: 75.0,
        enforcement_credibility: 70.0,
        adaptive_learning: 73.0,
        perceived_fairness: 77.0,
        behavioral_burden: 28.0,
        hypocrisy_visibility: 20.0,
        power_asymmetry: 25.0,
    };

    println!(
        "Behavioral governance raw score: {:.2}",
        behavioral_governance_score_raw(&demo)
    );
}
