struct SocialNormsCase {
    descriptive_norm: f64,
    injunctive_norm: f64,
    trust: f64,
    legitimacy: f64,
    sanction_intensity: f64,
    transmission_strength: f64,
    institutional_reinforcement: f64,
    norm_conflict: f64,
    hypocrisy_visibility: f64,
    unequal_enforcement: f64,
    performative_compliance: f64,
    distributional_attention: f64,
}

fn social_norms_cooperation_score_raw(x: &SocialNormsCase) -> f64 {
    0.14 * x.descriptive_norm
        + 0.14 * x.injunctive_norm
        + 0.13 * x.trust
        + 0.12 * x.legitimacy
        + 0.10 * x.sanction_intensity
        + 0.11 * x.transmission_strength
        + 0.12 * x.institutional_reinforcement
        - 0.13 * x.norm_conflict
        - 0.08 * x.hypocrisy_visibility
        - 0.07 * x.unequal_enforcement
        - 0.05 * x.performative_compliance
        + 0.04 * x.distributional_attention
}

fn main() {
    let demo = SocialNormsCase {
        descriptive_norm: 80.0,
        injunctive_norm: 78.0,
        trust: 75.0,
        legitimacy: 72.0,
        sanction_intensity: 60.0,
        transmission_strength: 74.0,
        institutional_reinforcement: 82.0,
        norm_conflict: 30.0,
        hypocrisy_visibility: 25.0,
        unequal_enforcement: 20.0,
        performative_compliance: 25.0,
        distributional_attention: 70.0,
    };

    println!(
        "Social norms cooperation raw score: {:.2}",
        social_norms_cooperation_score_raw(&demo)
    );
}
