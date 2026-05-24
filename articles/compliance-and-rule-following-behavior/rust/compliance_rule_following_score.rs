struct ComplianceCase {
    legitimacy: f64,
    fairness: f64,
    incentive_alignment: f64,
    norm_support: f64,
    enforcement_credibility: f64,
    communication_quality: f64,
    cognitive_clarity: f64,
    trust: f64,
    adaptive_learning: f64,
    compliance_burden: f64,
    selective_rule_application: f64,
    defensive_compliance: f64,
    hypocrisy_visibility: f64,
    norm_failure: f64,
}

fn compliance_quality_score_raw(x: &ComplianceCase) -> f64 {
    0.13 * x.legitimacy
        + 0.13 * x.fairness
        + 0.11 * x.incentive_alignment
        + 0.11 * x.norm_support
        + 0.10 * x.enforcement_credibility
        + 0.11 * x.communication_quality
        + 0.12 * x.cognitive_clarity
        + 0.11 * x.trust
        + 0.09 * x.adaptive_learning
        - 0.11 * x.compliance_burden
        - 0.08 * x.selective_rule_application
        - 0.06 * x.defensive_compliance
        - 0.05 * x.hypocrisy_visibility
        - 0.05 * x.norm_failure
}

fn main() {
    let demo = ComplianceCase {
        legitimacy: 76.0,
        fairness: 78.0,
        incentive_alignment: 72.0,
        norm_support: 74.0,
        enforcement_credibility: 70.0,
        communication_quality: 80.0,
        cognitive_clarity: 82.0,
        trust: 75.0,
        adaptive_learning: 73.0,
        compliance_burden: 28.0,
        selective_rule_application: 24.0,
        defensive_compliance: 20.0,
        hypocrisy_visibility: 18.0,
        norm_failure: 22.0,
    };

    println!(
        "Compliance quality raw score: {:.2}",
        compliance_quality_score_raw(&demo)
    );
}
