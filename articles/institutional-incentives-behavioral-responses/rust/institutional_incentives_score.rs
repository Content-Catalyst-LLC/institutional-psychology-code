struct InstitutionalIncentiveCase {
    value_alignment: f64,
    fairness: f64,
    information_quality: f64,
    legitimacy: f64,
    learning_support: f64,
    accountability: f64,
    bias_pressure: f64,
    metric_substitution: f64,
    reporting_distortion: f64,
    behavioral_burden: f64,
    short_termism: f64,
    status_inequality: f64,
    motivation_crowding: f64,
}

fn institutional_incentive_score_raw(x: &InstitutionalIncentiveCase) -> f64 {
    0.14 * x.value_alignment
        + 0.12 * x.fairness
        + 0.13 * x.information_quality
        + 0.12 * x.legitimacy
        + 0.12 * x.learning_support
        + 0.10 * x.accountability
        - 0.10 * x.bias_pressure
        - 0.12 * x.metric_substitution
        - 0.09 * x.reporting_distortion
        - 0.08 * x.behavioral_burden
        - 0.07 * x.short_termism
        - 0.06 * x.status_inequality
        - 0.05 * x.motivation_crowding
}

fn main() {
    let demo = InstitutionalIncentiveCase {
        value_alignment: 82.0,
        fairness: 76.0,
        information_quality: 80.0,
        legitimacy: 78.0,
        learning_support: 75.0,
        accountability: 72.0,
        bias_pressure: 25.0,
        metric_substitution: 22.0,
        reporting_distortion: 20.0,
        behavioral_burden: 28.0,
        short_termism: 24.0,
        status_inequality: 18.0,
        motivation_crowding: 21.0,
    };

    println!(
        "Institutional incentive raw score: {:.2}",
        institutional_incentive_score_raw(&demo)
    );
}
