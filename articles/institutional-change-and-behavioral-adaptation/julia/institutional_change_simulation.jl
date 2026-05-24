# Institutional change and behavioral adaptation simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(202)

n = 500

data = DataFrame(
    institution_id = 1:n,
    feedback_quality = rand(n) .* 80 .+ 15,
    adaptive_capacity = rand(n) .* 75 .+ 20,
    legitimacy = rand(n) .* 80 .+ 15,
    incentive_alignment = rand(n) .* 85 .+ 10,
    normative_support = rand(n) .* 85 .+ 10,
    governance_capacity = rand(n) .* 80 .+ 15,
    path_dependence = rand(n) .* 80 .+ 15,
    behavioral_flexibility = rand(n) .* 85 .+ 10,
    coordination_quality = rand(n) .* 85 .+ 10,
    environmental_change = rand(n) .* 90 .+ 5,
    distributional_attention = rand(n) .* 90 .+ 5,
    transition_burden = rand(n) .* 90 .+ 5
)

data.change_raw =
    0.13 .* data.feedback_quality .+
    0.14 .* data.adaptive_capacity .+
    0.10 .* data.legitimacy .+
    0.10 .* data.incentive_alignment .+
    0.09 .* data.normative_support .+
    0.12 .* data.governance_capacity .+
    0.10 .* data.behavioral_flexibility .+
    0.08 .* data.coordination_quality .+
    0.06 .* data.environmental_change .+
    0.05 .* data.distributional_attention .-
    0.12 .* data.path_dependence .-
    0.05 .* data.transition_burden

min_raw = minimum(data.change_raw)
max_raw = maximum(data.change_raw)
data.change_score = (data.change_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.successful_adaptation = data.change_score .>= 58
data.high_transition_burden = data.transition_burden .>= 65
data.fragile_adaptation = (data.successful_adaptation .== true) .& (data.legitimacy .< 45)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_change_julia_simulation.csv"), data)

println("Mean change score: ", mean(data.change_score))
println("Successful adaptation rate: ", mean(data.successful_adaptation))
println("Fragile adaptation rate: ", mean(data.fragile_adaptation))
println("High transition burden rate: ", mean(data.high_transition_burden))
