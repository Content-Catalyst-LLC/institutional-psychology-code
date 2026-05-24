struct Institution {
    robustness: f64,
    adaptive_capacity: f64,
    recovery_capacity: f64,
    transformational_capacity: f64,
    legitimacy: f64,
    trust: f64,
    feedback_quality: f64,
    learning_rate: f64,
    redundancy: f64,
    modularity: f64,
    coordination: f64,
    shock_intensity: f64,
}

fn resilience_index(x: &Institution) -> f64 {
    0.10 * x.robustness
        + 0.12 * x.adaptive_capacity
        + 0.10 * x.recovery_capacity
        + 0.08 * x.transformational_capacity
        + 0.12 * x.legitimacy
        + 0.10 * x.trust
        + 0.10 * x.feedback_quality
        + 0.08 * x.learning_rate
        + 0.07 * x.redundancy
        + 0.05 * x.modularity
        + 0.08 * x.coordination
        - 0.10 * x.shock_intensity
}

fn main() {
    let demo = Institution {
        robustness: 80.0,
        adaptive_capacity: 75.0,
        recovery_capacity: 70.0,
        transformational_capacity: 60.0,
        legitimacy: 85.0,
        trust: 82.0,
        feedback_quality: 78.0,
        learning_rate: 74.0,
        redundancy: 65.0,
        modularity: 68.0,
        coordination: 80.0,
        shock_intensity: 50.0,
    };

    println!(
        "Institutional resilience raw score: {:.2}",
        resilience_index(&demo)
    );
}
