struct CrisisReformCase {
    crisis_severity: f64,
    feedback_breakdown: f64,
    legitimacy_failure: f64,
    adaptive_capacity: f64,
    reform_window: f64,
    coalition_strength: f64,
    coordination_quality: f64,
    learning_rate: f64,
    governance_alignment: f64,
    power_concentration: f64,
    capture_risk: f64,
    distributional_attention: f64,
}

fn transformation_score_raw(x: &CrisisReformCase) -> f64 {
    0.15 * x.crisis_severity
        + 0.11 * x.feedback_breakdown
        + 0.14 * x.legitimacy_failure
        + 0.10 * x.adaptive_capacity
        + 0.12 * x.reform_window
        + 0.12 * x.coalition_strength
        + 0.08 * x.coordination_quality
        + 0.06 * x.learning_rate
        + 0.06 * x.governance_alignment
        + 0.05 * x.distributional_attention
        - 0.07 * x.capture_risk
        - 0.04 * (x.power_concentration - 50.0).abs()
}

fn main() {
    let demo = CrisisReformCase {
        crisis_severity: 85.0,
        feedback_breakdown: 78.0,
        legitimacy_failure: 80.0,
        adaptive_capacity: 70.0,
        reform_window: 75.0,
        coalition_strength: 68.0,
        coordination_quality: 72.0,
        learning_rate: 65.0,
        governance_alignment: 74.0,
        power_concentration: 55.0,
        capture_risk: 35.0,
        distributional_attention: 80.0,
    };

    println!(
        "Institutional transformation raw score: {:.2}",
        transformation_score_raw(&demo)
    );
}
