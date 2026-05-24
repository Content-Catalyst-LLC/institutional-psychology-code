# Crisis, reform, and institutional transformation simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(123)

n = 500

data = DataFrame(
    case_id = 1:n,
    crisis_severity = rand(n) .* 80 .+ 20,
    feedback_breakdown = rand(n) .* 85 .+ 15,
    legitimacy_failure = rand(n) .* 90 .+ 10,
    adaptive_capacity = rand(n) .* 75 .+ 20,
    reform_window = rand(n) .* 85 .+ 10,
    coalition_strength = rand(n) .* 90 .+ 5,
    coordination_quality = rand(n) .* 85 .+ 10,
    learning_rate = rand(n) .* 75 .+ 15,
    governance_alignment = rand(n) .* 85 .+ 10,
    power_concentration = rand(n) .* 90 .+ 5,
    capture_risk = rand(n) .* 85 .+ 5,
    distributional_attention = rand(n) .* 90 .+ 5
)

data.transformation_raw =
    0.15 .* data.crisis_severity .+
    0.11 .* data.feedback_breakdown .+
    0.14 .* data.legitimacy_failure .+
    0.10 .* data.adaptive_capacity .+
    0.12 .* data.reform_window .+
    0.12 .* data.coalition_strength .+
    0.08 .* data.coordination_quality .+
    0.06 .* data.learning_rate .+
    0.06 .* data.governance_alignment .+
    0.05 .* data.distributional_attention .-
    0.07 .* data.capture_risk .-
    0.04 .* abs.(data.power_concentration .- 50)

min_raw = minimum(data.transformation_raw)
max_raw = maximum(data.transformation_raw)
data.transformation_score = (data.transformation_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.major_reform = data.transformation_score .>= 60
data.deep_transformation = data.transformation_score .>= 75
data.high_capture_risk = data.capture_risk .>= 65

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "crisis_reform_julia_simulation.csv"), data)

println("Mean transformation score: ", mean(data.transformation_score))
println("Major reform rate: ", mean(data.major_reform))
println("Deep transformation rate: ", mean(data.deep_transformation))
println("High capture risk rate: ", mean(data.high_capture_risk))
