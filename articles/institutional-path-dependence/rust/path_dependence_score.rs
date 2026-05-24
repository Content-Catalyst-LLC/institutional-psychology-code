struct PathDependenceCase {
    initial_conditions: f64,
    behavioral_reinforcement: f64,
    feedback_strength: f64,
    increasing_returns: f64,
    coordination_effects: f64,
    learning_effects: f64,
    legitimacy: f64,
    switching_costs: f64,
    complementarity: f64,
    disruption_pressure: f64,
    reform_capacity: f64,
}

fn path_dependence_score_raw(x: &PathDependenceCase) -> f64 {
    0.08 * x.initial_conditions
        + 0.12 * x.behavioral_reinforcement
        + 0.12 * x.feedback_strength
        + 0.13 * x.increasing_returns
        + 0.11 * x.coordination_effects
        + 0.10 * x.learning_effects
        + 0.12 * x.legitimacy
        + 0.12 * x.switching_costs
        + 0.10 * x.complementarity
        - 0.12 * x.disruption_pressure
        - 0.05 * x.reform_capacity
}

fn main() {
    let demo = PathDependenceCase {
        initial_conditions: 80.0,
        behavioral_reinforcement: 75.0,
        feedback_strength: 70.0,
        increasing_returns: 82.0,
        coordination_effects: 78.0,
        learning_effects: 74.0,
        legitimacy: 85.0,
        switching_costs: 88.0,
        complementarity: 79.0,
        disruption_pressure: 35.0,
        reform_capacity: 40.0,
    };

    println!(
        "Institutional path dependence raw score: {:.2}",
        path_dependence_score_raw(&demo)
    );
}
