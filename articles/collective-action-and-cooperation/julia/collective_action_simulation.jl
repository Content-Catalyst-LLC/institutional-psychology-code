# Collective action and cooperation simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(606)

n = 500

data = DataFrame(
    unit_id = 1:n,
    incentive_alignment = rand(n) .* 85 .+ 10,
    trust = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    norm_strength = rand(n) .* 85 .+ 10,
    enforcement_credibility = rand(n) .* 90 .+ 5,
    communication_quality = rand(n) .* 85 .+ 10,
    coordination_quality = rand(n) .* 85 .+ 10,
    perceived_fairness = rand(n) .* 90 .+ 5,
    free_riding_pressure = rand(n) .* 90 .+ 5,
    burden_inequality = rand(n) .* 90 .+ 5,
    hypocrisy_visibility = rand(n) .* 90 .+ 5,
    scale_complexity = rand(n) .* 90 .+ 5
)

data.cooperation_raw =
    0.12 .* data.incentive_alignment .+
    0.13 .* data.trust .+
    0.12 .* data.legitimacy .+
    0.11 .* data.norm_strength .+
    0.10 .* data.enforcement_credibility .+
    0.11 .* data.communication_quality .+
    0.11 .* data.coordination_quality .+
    0.10 .* data.perceived_fairness .-
    0.12 .* data.free_riding_pressure .-
    0.07 .* data.burden_inequality .-
    0.06 .* data.hypocrisy_visibility .-
    0.05 .* data.scale_complexity

min_raw = minimum(data.cooperation_raw)
max_raw = maximum(data.cooperation_raw)
data.cooperation_score = (data.cooperation_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_cooperation = data.cooperation_score .>= 60
data.fragile_cooperation = (data.high_cooperation .== true) .& (data.trust .< 40)
data.high_burden_cooperation = (data.high_cooperation .== true) .& (data.burden_inequality .> 65) .& (data.perceived_fairness .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "collective_action_julia_simulation.csv"), data)

println("Mean cooperation score: ", mean(data.cooperation_score))
println("High cooperation rate: ", mean(data.high_cooperation))
println("Fragile cooperation rate: ", mean(data.fragile_cooperation))
println("High-burden cooperation rate: ", mean(data.high_burden_cooperation))
