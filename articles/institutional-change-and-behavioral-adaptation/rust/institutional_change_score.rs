struct InstitutionalChangeCase {
    feedback_quality: f64,
    adaptive_capacity: f64,
    legitimacy: f64,
    incentive_alignment: f64,
    normative_support: f64,
    governance_capacity: f64,
    path_dependence: f64,
    behavioral_flexibility: f64,
    coordination_quality: f64,
    environmental_change: f64,
    distributional_attention: f64,
    transition_burden: f64,
}

fn institutional_change_score_raw(x: &InstitutionalChangeCase) -> f64 {
    0.13 * x.feedback_quality
        + 0.14 * x.adaptive_capacity
        + 0.10 * x.legitimacy
        + 0.10 * x.incentive_alignment
        + 0.09 * x.normative_support
        + 0.12 * x.governance_capacity
        - 0.12 * x.path_dependence
        + 0.10 * x.behavioral_flexibility
        + 0.08 * x.coordination_quality
        + 0.06 * x.environmental_change
        + 0.05 * x.distributional_attention
        - 0.05 * x.transition_burden
}

fn main() {
    let demo = InstitutionalChangeCase {
        feedback_quality: 80.0,
        adaptive_capacity: 78.0,
        legitimacy: 75.0,
        incentive_alignment: 70.0,
        normative_support: 72.0,
        governance_capacity: 82.0,
        path_dependence: 40.0,
        behavioral_flexibility: 76.0,
        coordination_quality: 74.0,
        environmental_change: 65.0,
        distributional_attention: 70.0,
        transition_burden: 35.0,
    };

    println!(
        "Institutional change raw score: {:.2}",
        institutional_change_score_raw(&demo)
    );
}
