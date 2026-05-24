struct TrustCase {
    consistency: f64,
    competence: f64,
    fairness: f64,
    transparency: f64,
    accountability: f64,
    integrity: f64,
    recognition_voice: f64,
    repair_capacity: f64,
    arbitrariness_pressure: f64,
    visible_violation_pressure: f64,
    administrative_burden: f64,
}

fn trust_score_raw(x: &TrustCase) -> f64 {
    0.11 * x.consistency
        + 0.12 * x.competence
        + 0.14 * x.fairness
        + 0.10 * x.transparency
        + 0.13 * x.accountability
        + 0.12 * x.integrity
        + 0.09 * x.recognition_voice
        + 0.09 * x.repair_capacity
        - 0.13 * x.arbitrariness_pressure
        - 0.11 * x.visible_violation_pressure
        - 0.08 * x.administrative_burden
}

fn main() {
    let demo = TrustCase {
        consistency: 82.0,
        competence: 80.0,
        fairness: 84.0,
        transparency: 78.0,
        accountability: 82.0,
        integrity: 79.0,
        recognition_voice: 76.0,
        repair_capacity: 74.0,
        arbitrariness_pressure: 22.0,
        visible_violation_pressure: 20.0,
        administrative_burden: 18.0,
    };

    println!(
        "Institutional trust raw score: {:.2}",
        trust_score_raw(&demo)
    );
}
