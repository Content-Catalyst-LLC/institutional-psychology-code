struct LegitimacyCase {
    formal_authority_clarity: f64,
    procedural_legitimacy: f64,
    outcome_legitimacy: f64,
    trust: f64,
    rule_clarity: f64,
    social_recognition: f64,
    accountability: f64,
    repair_capacity: f64,
    fairness: f64,
    arbitrariness_pressure: f64,
    visible_inconsistency: f64,
    unequal_burden: f64,
    opacity_pressure: f64,
}

fn authority_legitimacy_raw(x: &LegitimacyCase) -> f64 {
    0.11 * x.formal_authority_clarity
        + 0.14 * x.procedural_legitimacy
        + 0.12 * x.outcome_legitimacy
        + 0.13 * x.trust
        + 0.11 * x.rule_clarity
        + 0.11 * x.social_recognition
        + 0.12 * x.accountability
        + 0.10 * x.repair_capacity
        + 0.10 * x.fairness
        - 0.14 * x.arbitrariness_pressure
        - 0.10 * x.visible_inconsistency
        - 0.09 * x.unequal_burden
        - 0.08 * x.opacity_pressure
}

fn main() {
    let demo = LegitimacyCase {
        formal_authority_clarity: 82.0,
        procedural_legitimacy: 84.0,
        outcome_legitimacy: 78.0,
        trust: 80.0,
        rule_clarity: 82.0,
        social_recognition: 76.0,
        accountability: 79.0,
        repair_capacity: 74.0,
        fairness: 81.0,
        arbitrariness_pressure: 22.0,
        visible_inconsistency: 20.0,
        unequal_burden: 18.0,
        opacity_pressure: 19.0,
    };

    println!(
        "Authority-legitimacy raw score: {:.2}",
        authority_legitimacy_raw(&demo)
    );
}
