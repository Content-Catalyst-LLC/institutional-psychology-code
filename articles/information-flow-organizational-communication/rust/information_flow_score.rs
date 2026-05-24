struct InformationFlowCase {
    signal_quality: f64,
    communication_quality: f64,
    interpretive_integration: f64,
    feedback_usability: f64,
    memory_retention: f64,
    openness: f64,
    escalation_access: f64,
    trust: f64,
    community_voice: f64,
    digital_transparency: f64,
    distortion_loss: f64,
    overload: f64,
    siloing: f64,
    suppression_pressure: f64,
    metric_tunnel_vision: f64,
}

fn information_flow_score_raw(x: &InformationFlowCase) -> f64 {
    0.12 * x.signal_quality
        + 0.12 * x.communication_quality
        + 0.12 * x.interpretive_integration
        + 0.11 * x.feedback_usability
        + 0.10 * x.memory_retention
        + 0.11 * x.openness
        + 0.09 * x.escalation_access
        + 0.08 * x.trust
        + 0.07 * x.community_voice
        + 0.07 * x.digital_transparency
        - 0.12 * x.distortion_loss
        - 0.09 * x.overload
        - 0.08 * x.siloing
        - 0.08 * x.suppression_pressure
        - 0.07 * x.metric_tunnel_vision
}

fn main() {
    let demo = InformationFlowCase {
        signal_quality: 84.0,
        communication_quality: 78.0,
        interpretive_integration: 80.0,
        feedback_usability: 76.0,
        memory_retention: 74.0,
        openness: 77.0,
        escalation_access: 72.0,
        trust: 75.0,
        community_voice: 70.0,
        digital_transparency: 73.0,
        distortion_loss: 24.0,
        overload: 28.0,
        siloing: 22.0,
        suppression_pressure: 20.0,
        metric_tunnel_vision: 26.0,
    };

    println!(
        "Information flow raw score: {:.2}",
        information_flow_score_raw(&demo)
    );
}
