struct InstitutionalMemoryCase {
    documented_retention: f64,
    tacit_transfer: f64,
    accessibility: f64,
    interpretive_use: f64,
    revisability: f64,
    technical_continuity: f64,
    metadata_quality: f64,
    distributed_integration: f64,
    memory_justice: f64,
    path_dependence_pressure: f64,
    loss_fragmentation: f64,
    selective_narration: f64,
    turnover_pressure: f64,
    key_person_dependency: f64,
}

fn institutional_memory_score_raw(x: &InstitutionalMemoryCase) -> f64 {
    0.12 * x.documented_retention
        + 0.12 * x.tacit_transfer
        + 0.12 * x.accessibility
        + 0.12 * x.interpretive_use
        + 0.11 * x.revisability
        + 0.09 * x.technical_continuity
        + 0.08 * x.metadata_quality
        + 0.08 * x.distributed_integration
        + 0.08 * x.memory_justice
        - 0.11 * x.path_dependence_pressure
        - 0.11 * x.loss_fragmentation
        - 0.08 * x.selective_narration
        - 0.07 * x.turnover_pressure
        - 0.06 * x.key_person_dependency
}

fn main() {
    let demo = InstitutionalMemoryCase {
        documented_retention: 84.0,
        tacit_transfer: 78.0,
        accessibility: 80.0,
        interpretive_use: 76.0,
        revisability: 74.0,
        technical_continuity: 79.0,
        metadata_quality: 82.0,
        distributed_integration: 72.0,
        memory_justice: 70.0,
        path_dependence_pressure: 24.0,
        loss_fragmentation: 22.0,
        selective_narration: 20.0,
        turnover_pressure: 26.0,
        key_person_dependency: 28.0,
    };

    println!(
        "Institutional memory raw score: {:.2}",
        institutional_memory_score_raw(&demo)
    );
}
