# Behavioral governance systems simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(707)

n = 500

data = DataFrame(
    unit_id = 1:n,
    incentive_alignment = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    norm_support = rand(n) .* 85 .+ 10,
    cognitive_interpretability = rand(n) .* 85 .+ 10,
    trust = rand(n) .* 85 .+ 10,
    coordination_quality = rand(n) .* 85 .+ 10,
    enforcement_credibility = rand(n) .* 90 .+ 5,
    adaptive_learning = rand(n) .* 85 .+ 10,
    perceived_fairness = rand(n) .* 90 .+ 5,
    behavioral_burden = rand(n) .* 90 .+ 5,
    hypocrisy_visibility = rand(n) .* 90 .+ 5,
    power_asymmetry = rand(n) .* 90 .+ 5
)

data.governance_raw =
    0.11 .* data.incentive_alignment .+
    0.13 .* data.legitimacy .+
    0.10 .* data.norm_support .+
    0.11 .* data.cognitive_interpretability .+
    0.12 .* data.trust .+
    0.11 .* data.coordination_quality .+
    0.10 .* data.enforcement_credibility .+
    0.11 .* data.adaptive_learning .+
    0.10 .* data.perceived_fairness .-
    0.10 .* data.behavioral_burden .-
    0.07 .* data.hypocrisy_visibility .-
    0.06 .* data.power_asymmetry

min_raw = minimum(data.governance_raw)
max_raw = maximum(data.governance_raw)
data.governance_effectiveness = (data.governance_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_governance = data.governance_effectiveness .>= 60
data.fragile_governance = (data.high_governance .== true) .& (data.trust .< 40)
data.high_burden_governance = (data.high_governance .== true) .& (data.behavioral_burden .> 65) .& (data.perceived_fairness .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "behavioral_governance_julia_simulation.csv"), data)

println("Mean governance effectiveness: ", mean(data.governance_effectiveness))
println("High governance rate: ", mean(data.high_governance))
println("Fragile governance rate: ", mean(data.fragile_governance))
println("High-burden governance rate: ", mean(data.high_burden_governance))
