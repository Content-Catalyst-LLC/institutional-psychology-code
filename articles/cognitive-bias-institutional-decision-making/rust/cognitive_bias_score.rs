struct BiasDecisionCase {
    overconfidence: f64,
    conformity_pressure: f64,
    filtering_distortion: f64,
    path_lock_in: f64,
    metric_tunnel_vision: f64,
    power_protection: f64,
    dissent_capacity: f64,
    corrective_review: f64,
    information_quality: f64,
    feedback_openness: f64,
    psychological_safety: f64,
    justice_voice: f64,
}

fn decision_quality_raw(x: &BiasDecisionCase) -> f64 {
    0.14 * x.dissent_capacity
        + 0.14 * x.corrective_review
        + 0.14 * x.information_quality
        + 0.13 * x.feedback_openness
        + 0.11 * x.psychological_safety
        + 0.10 * x.justice_voice
        - 0.13 * x.overconfidence
        - 0.13 * x.conformity_pressure
        - 0.14 * x.filtering_distortion
        - 0.12 * x.path_lock_in
        - 0.10 * x.metric_tunnel_vision
        - 0.09 * x.power_protection
}

fn main() {
    let demo = BiasDecisionCase {
        overconfidence: 22.0,
        conformity_pressure: 25.0,
        filtering_distortion: 24.0,
        path_lock_in: 28.0,
        metric_tunnel_vision: 20.0,
        power_protection: 21.0,
        dissent_capacity: 82.0,
        corrective_review: 80.0,
        information_quality: 84.0,
        feedback_openness: 78.0,
        psychological_safety: 76.0,
        justice_voice: 72.0,
    };

    println!(
        "Institutional decision quality raw score: {:.2}",
        decision_quality_raw(&demo)
    );
}
