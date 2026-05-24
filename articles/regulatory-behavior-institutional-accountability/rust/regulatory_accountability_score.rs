struct RegulatoryAccountabilityCase {
    oversight_strength: f64,
    legitimacy: f64,
    incentive_alignment: f64,
    enforcement_credibility: f64,
    information_quality: f64,
    adaptive_learning: f64,
    accountability_reach: f64,
    capture_pressure: f64,
    regulatory_burden: f64,
    evasion_pressure: f64,
    hypocrisy_visibility: f64,
    unequal_accountability: f64,
}

fn regulatory_accountability_score_raw(x: &RegulatoryAccountabilityCase) -> f64 {
    0.13 * x.oversight_strength
        + 0.13 * x.legitimacy
        + 0.11 * x.incentive_alignment
        + 0.12 * x.enforcement_credibility
        + 0.13 * x.information_quality
        + 0.11 * x.adaptive_learning
        + 0.11 * x.accountability_reach
        - 0.12 * x.capture_pressure
        - 0.08 * x.regulatory_burden
        - 0.07 * x.evasion_pressure
        - 0.06 * x.hypocrisy_visibility
        - 0.06 * x.unequal_accountability
}

fn main() {
    let demo = RegulatoryAccountabilityCase {
        oversight_strength: 82.0,
        legitimacy: 76.0,
        incentive_alignment: 74.0,
        enforcement_credibility: 72.0,
        information_quality: 80.0,
        adaptive_learning: 75.0,
        accountability_reach: 70.0,
        capture_pressure: 25.0,
        regulatory_burden: 30.0,
        evasion_pressure: 22.0,
        hypocrisy_visibility: 18.0,
        unequal_accountability: 24.0,
    };

    println!(
        "Regulatory accountability raw score: {:.2}",
        regulatory_accountability_score_raw(&demo)
    );
}
