struct InstitutionalEnforcementCase {
    monitoring_quality: f64,
    legitimacy: f64,
    incentive_alignment: f64,
    sanction_credibility: f64,
    information_quality: f64,
    adaptive_learning: f64,
    accountability_reach: f64,
    compliance_burden: f64,
    selective_enforcement: f64,
    evasion_pressure: f64,
    hypocrisy_visibility: f64,
    defensive_compliance: f64,
}

fn institutional_enforcement_score_raw(x: &InstitutionalEnforcementCase) -> f64 {
    0.13 * x.monitoring_quality
        + 0.13 * x.legitimacy
        + 0.12 * x.incentive_alignment
        + 0.12 * x.sanction_credibility
        + 0.13 * x.information_quality
        + 0.11 * x.adaptive_learning
        + 0.10 * x.accountability_reach
        - 0.08 * x.compliance_burden
        - 0.08 * x.selective_enforcement
        - 0.12 * x.evasion_pressure
        - 0.06 * x.hypocrisy_visibility
        - 0.06 * x.defensive_compliance
}

fn main() {
    let demo = InstitutionalEnforcementCase {
        monitoring_quality: 82.0,
        legitimacy: 76.0,
        incentive_alignment: 74.0,
        sanction_credibility: 72.0,
        information_quality: 80.0,
        adaptive_learning: 75.0,
        accountability_reach: 70.0,
        compliance_burden: 30.0,
        selective_enforcement: 24.0,
        evasion_pressure: 22.0,
        hypocrisy_visibility: 18.0,
        defensive_compliance: 20.0,
    };

    println!(
        "Institutional enforcement raw score: {:.2}",
        institutional_enforcement_score_raw(&demo)
    );
}
