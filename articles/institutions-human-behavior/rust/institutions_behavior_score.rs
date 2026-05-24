struct InstitutionCase {
    normative_stability: f64,
    legitimacy_strength: f64,
    incentive_alignment: f64,
    information_quality: f64,
    memory_retention: f64,
    learning_capacity: f64,
    trust_reinforcement: f64,
    role_clarity: f64,
    repair_capacity: f64,
    fragmentation_pressure: f64,
    opacity_pressure: f64,
    administrative_burden: f64,
    historical_harm_pressure: f64,
}

fn institutional_strength_raw(x: &InstitutionCase) -> f64 {
    0.13 * x.normative_stability
        + 0.14 * x.legitimacy_strength
        + 0.11 * x.incentive_alignment
        + 0.12 * x.information_quality
        + 0.11 * x.memory_retention
        + 0.13 * x.learning_capacity
        + 0.12 * x.trust_reinforcement
        + 0.08 * x.role_clarity
        + 0.08 * x.repair_capacity
        - 0.12 * x.fragmentation_pressure
        - 0.08 * x.opacity_pressure
        - 0.08 * x.administrative_burden
        - 0.07 * x.historical_harm_pressure
}

fn main() {
    let demo = InstitutionCase {
        normative_stability: 82.0,
        legitimacy_strength: 84.0,
        incentive_alignment: 78.0,
        information_quality: 80.0,
        memory_retention: 76.0,
        learning_capacity: 79.0,
        trust_reinforcement: 81.0,
        role_clarity: 77.0,
        repair_capacity: 74.0,
        fragmentation_pressure: 22.0,
        opacity_pressure: 20.0,
        administrative_burden: 18.0,
        historical_harm_pressure: 16.0,
    };

    println!(
        "Institutional strength raw score: {:.2}",
        institutional_strength_raw(&demo)
    );
}
