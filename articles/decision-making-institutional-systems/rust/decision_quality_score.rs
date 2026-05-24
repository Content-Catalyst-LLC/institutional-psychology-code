struct DecisionQualityCase {
    bounded_rationality_pressure: f64,
    organizational_structure_quality: f64,
    incentive_alignment: f64,
    information_flow_effectiveness: f64,
    legitimacy: f64,
    uncertainty_management: f64,
    corrective_capacity: f64,
    justice_voice: f64,
    memory_quality: f64,
    feedback_openness: f64,
    bias_distortion: f64,
    power_protection: f64,
    metric_fixation: f64,
    siloing: f64,
    premature_closure: f64,
}

fn decision_quality_raw(x: &DecisionQualityCase) -> f64 {
    0.12 * x.organizational_structure_quality
        + 0.12 * x.incentive_alignment
        + 0.13 * x.information_flow_effectiveness
        + 0.11 * x.legitimacy
        + 0.11 * x.uncertainty_management
        + 0.13 * x.corrective_capacity
        + 0.09 * x.justice_voice
        + 0.08 * x.memory_quality
        + 0.08 * x.feedback_openness
        - 0.13 * x.bounded_rationality_pressure
        - 0.11 * x.bias_distortion
        - 0.09 * x.power_protection
        - 0.08 * x.metric_fixation
        - 0.07 * x.siloing
        - 0.07 * x.premature_closure
}

fn main() {
    let demo = DecisionQualityCase {
        bounded_rationality_pressure: 24.0,
        organizational_structure_quality: 82.0,
        incentive_alignment: 78.0,
        information_flow_effectiveness: 84.0,
        legitimacy: 80.0,
        uncertainty_management: 76.0,
        corrective_capacity: 82.0,
        justice_voice: 72.0,
        memory_quality: 74.0,
        feedback_openness: 78.0,
        bias_distortion: 22.0,
        power_protection: 20.0,
        metric_fixation: 24.0,
        siloing: 18.0,
        premature_closure: 21.0,
    };

    println!(
        "Institutional decision quality raw score: {:.2}",
        decision_quality_raw(&demo)
    );
}
