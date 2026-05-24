struct InstitutionalLearningCase {
    feedback_quality: f64,
    memory_retention: f64,
    communication_openness: f64,
    interpretive_quality: f64,
    decision_revisability: f64,
    psychological_safety: f64,
    accountability_reach: f64,
    disconfirming_evidence: f64,
    institutional_inertia: f64,
    signal_distortion: f64,
    memory_decay: f64,
    defensive_routines: f64,
    power_protection: f64,
    feedback_delay: f64,
}

fn institutional_learning_score_raw(x: &InstitutionalLearningCase) -> f64 {
    0.13 * x.feedback_quality
        + 0.12 * x.memory_retention
        + 0.12 * x.communication_openness
        + 0.12 * x.interpretive_quality
        + 0.12 * x.decision_revisability
        + 0.12 * x.psychological_safety
        + 0.10 * x.accountability_reach
        + 0.06 * x.disconfirming_evidence
        - 0.12 * x.institutional_inertia
        - 0.10 * x.signal_distortion
        - 0.08 * x.memory_decay
        - 0.08 * x.defensive_routines
        - 0.08 * x.power_protection
        - 0.07 * x.feedback_delay
}

fn main() {
    let demo = InstitutionalLearningCase {
        feedback_quality: 84.0,
        memory_retention: 78.0,
        communication_openness: 76.0,
        interpretive_quality: 80.0,
        decision_revisability: 74.0,
        psychological_safety: 77.0,
        accountability_reach: 72.0,
        disconfirming_evidence: 68.0,
        institutional_inertia: 25.0,
        signal_distortion: 22.0,
        memory_decay: 18.0,
        defensive_routines: 20.0,
        power_protection: 24.0,
        feedback_delay: 21.0,
    };

    println!(
        "Institutional learning raw score: {:.2}",
        institutional_learning_score_raw(&demo)
    );
}
