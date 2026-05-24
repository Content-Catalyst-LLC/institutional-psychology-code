struct NormCase {
    norm_repetition: f64,
    expectation_convergence: f64,
    internalization: f64,
    social_enforcement: f64,
    legitimacy_alignment: f64,
    trust_reinforcement: f64,
    role_clarity: f64,
    learning_capacity: f64,
    fragmentation_pressure: f64,
    unequal_normative_burden: f64,
    suppressive_pressure: f64,
}

fn normative_stability_raw(x: &NormCase) -> f64 {
    0.13 * x.norm_repetition
        + 0.14 * x.expectation_convergence
        + 0.13 * x.internalization
        + 0.11 * x.social_enforcement
        + 0.13 * x.legitimacy_alignment
        + 0.11 * x.trust_reinforcement
        + 0.09 * x.role_clarity
        + 0.08 * x.learning_capacity
        - 0.13 * x.fragmentation_pressure
        - 0.10 * x.unequal_normative_burden
        - 0.08 * x.suppressive_pressure
}

fn main() {
    let demo = NormCase {
        norm_repetition: 82.0,
        expectation_convergence: 84.0,
        internalization: 78.0,
        social_enforcement: 76.0,
        legitimacy_alignment: 80.0,
        trust_reinforcement: 79.0,
        role_clarity: 77.0,
        learning_capacity: 74.0,
        fragmentation_pressure: 22.0,
        unequal_normative_burden: 20.0,
        suppressive_pressure: 18.0,
    };

    println!(
        "Normative stability raw score: {:.2}",
        normative_stability_raw(&demo)
    );
}
