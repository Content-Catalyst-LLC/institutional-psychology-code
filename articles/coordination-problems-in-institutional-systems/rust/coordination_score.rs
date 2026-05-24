struct CoordinationCase {
    trust: f64,
    information_quality: f64,
    communication_clarity: f64,
    focal_salience: f64,
    authority_signal: f64,
    norm_strength: f64,
    learning_capacity: f64,
    uncertainty: f64,
    adaptation_burden: f64,
    competing_standards: f64,
    competing_authority: f64,
    distributional_attention: f64,
}

fn coordination_score_raw(x: &CoordinationCase) -> f64 {
    0.14 * x.trust
        + 0.14 * x.information_quality
        + 0.13 * x.communication_clarity
        + 0.12 * x.focal_salience
        + 0.10 * x.authority_signal
        + 0.10 * x.norm_strength
        + 0.09 * x.learning_capacity
        - 0.13 * x.uncertainty
        - 0.07 * x.adaptation_burden
        - 0.06 * x.competing_standards
        - 0.05 * x.competing_authority
        + 0.04 * x.distributional_attention
}

fn main() {
    let demo = CoordinationCase {
        trust: 80.0,
        information_quality: 78.0,
        communication_clarity: 82.0,
        focal_salience: 76.0,
        authority_signal: 74.0,
        norm_strength: 70.0,
        learning_capacity: 72.0,
        uncertainty: 30.0,
        adaptation_burden: 35.0,
        competing_standards: 25.0,
        competing_authority: 20.0,
        distributional_attention: 68.0,
    };

    println!(
        "Institutional coordination raw score: {:.2}",
        coordination_score_raw(&demo)
    );
}
