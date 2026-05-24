# Institutional resilience simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(42)

n = 300

data = DataFrame(
    institution_id = 1:n,
    robustness = rand(n) .* 55 .+ 40,
    adaptive_capacity = rand(n) .* 65 .+ 30,
    recovery_capacity = rand(n) .* 60 .+ 35,
    transformational_capacity = rand(n) .* 70 .+ 20,
    legitimacy = rand(n) .* 70 .+ 25,
    trust = rand(n) .* 75 .+ 20,
    feedback_quality = rand(n) .* 80 .+ 15,
    learning_rate = rand(n) .* 70 .+ 20,
    redundancy = rand(n) .* 75 .+ 10,
    modularity = rand(n) .* 75 .+ 15,
    coordination = rand(n) .* 75 .+ 20,
    shock_intensity = rand(n) .* 90 .+ 10
)

data.resilience_raw =
    0.10 .* data.robustness .+
    0.12 .* data.adaptive_capacity .+
    0.10 .* data.recovery_capacity .+
    0.08 .* data.transformational_capacity .+
    0.12 .* data.legitimacy .+
    0.10 .* data.trust .+
    0.10 .* data.feedback_quality .+
    0.08 .* data.learning_rate .+
    0.07 .* data.redundancy .+
    0.05 .* data.modularity .+
    0.08 .* data.coordination .-
    0.10 .* data.shock_intensity

min_raw = minimum(data.resilience_raw)
max_raw = maximum(data.resilience_raw)
data.resilience_index = (data.resilience_raw .- min_raw) ./ (max_raw - min_raw) .* 100

data.continuity_score = clamp.(
    0.35 .* data.resilience_index .+
    0.25 .* data.legitimacy .+
    0.20 .* data.trust .+
    0.20 .* data.coordination .-
    0.30 .* data.shock_intensity,
    0,
    100
)

data.maintained_core_function = data.continuity_score .>= 55

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_resilience_julia_simulation.csv"), data)

println("Mean resilience index: ", mean(data.resilience_index))
println("Mean continuity score: ", mean(data.continuity_score))
println("Maintained core function rate: ", mean(data.maintained_core_function))
