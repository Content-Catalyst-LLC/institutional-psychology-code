fn institutional_effectiveness(
    legitimacy: f64,
    norms: f64,
    trust: f64,
    cognition: f64,
    info_flow: f64,
    memory: f64,
    learning: f64,
    fragmentation: f64,
) -> f64 {
    0.14 * legitimacy + 0.14 * norms + 0.13 * trust + 0.12 * cognition +
    0.12 * info_flow + 0.12 * memory + 0.13 * learning - 0.16 * fragmentation
}

fn main() {
    let score = institutional_effectiveness(0.72, 0.68, 0.64, 0.70, 0.66, 0.58, 0.62, 0.30);
    println!("Institutional effectiveness score: {:.3}", score);
}
