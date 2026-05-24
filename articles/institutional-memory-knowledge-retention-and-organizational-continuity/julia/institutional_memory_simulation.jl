# Institutional memory, knowledge retention, and organizational continuity simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1313)

n = 500

data = DataFrame(
    unit_id = 1:n,
    documented_retention = rand(n) .* 85 .+ 10,
    tacit_transfer = rand(n) .* 85 .+ 10,
    accessibility = rand(n) .* 85 .+ 10,
    interpretive_use = rand(n) .* 85 .+ 10,
    revisability = rand(n) .* 85 .+ 10,
    technical_continuity = rand(n) .* 85 .+ 10,
    metadata_quality = rand(n) .* 85 .+ 10,
    distributed_integration = rand(n) .* 85 .+ 10,
    memory_justice = rand(n) .* 85 .+ 10,
    path_dependence_pressure = rand(n) .* 90 .+ 5,
    loss_fragmentation = rand(n) .* 90 .+ 5,
    selective_narration = rand(n) .* 90 .+ 5,
    turnover_pressure = rand(n) .* 90 .+ 5,
    key_person_dependency = rand(n) .* 90 .+ 5
)

data.memory_raw =
    0.12 .* data.documented_retention .+
    0.12 .* data.tacit_transfer .+
    0.12 .* data.accessibility .+
    0.12 .* data.interpretive_use .+
    0.11 .* data.revisability .+
    0.09 .* data.technical_continuity .+
    0.08 .* data.metadata_quality .+
    0.08 .* data.distributed_integration .+
    0.08 .* data.memory_justice .-
    0.11 .* data.path_dependence_pressure .-
    0.11 .* data.loss_fragmentation .-
    0.08 .* data.selective_narration .-
    0.07 .* data.turnover_pressure .-
    0.06 .* data.key_person_dependency

min_raw = minimum(data.memory_raw)
max_raw = maximum(data.memory_raw)
data.memory_effectiveness = (data.memory_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_resilience_memory = data.memory_effectiveness .>= 60
data.fragile_memory = (data.high_resilience_memory .== true) .& (data.documented_retention .< 40) .& (data.tacit_transfer .< 40)
data.high_path_dependence_memory = (data.high_resilience_memory .== true) .& (data.path_dependence_pressure .> 65) .& (data.revisability .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_memory_julia_simulation.csv"), data)

println("Mean memory effectiveness: ", mean(data.memory_effectiveness))
println("High resilience memory rate: ", mean(data.high_resilience_memory))
println("Fragile memory rate: ", mean(data.fragile_memory))
println("High path-dependence memory rate: ", mean(data.high_path_dependence_memory))
