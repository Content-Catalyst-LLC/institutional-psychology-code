# Social norms and institutional cooperation simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(505)

n = 500

data = DataFrame(
    unit_id = 1:n,
    descriptive_norm = rand(n) .* 85 .+ 10,
    injunctive_norm = rand(n) .* 85 .+ 10,
    trust = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    sanction_intensity = rand(n) .* 90 .+ 5,
    transmission_strength = rand(n) .* 85 .+ 10,
    institutional_reinforcement = rand(n) .* 85 .+ 10,
    norm_conflict = rand(n) .* 90 .+ 5,
    hypocrisy_visibility = rand(n) .* 90 .+ 5,
    unequal_enforcement = rand(n) .* 90 .+ 5,
    performative_compliance = rand(n) .* 90 .+ 5,
    distributional_attention = rand(n) .* 90 .+ 5
)

data.cooperation_raw =
    0.14 .* data.descriptive_norm .+
    0.14 .* data.injunctive_norm .+
    0.13 .* data.trust .+
    0.12 .* data.legitimacy .+
    0.10 .* data.sanction_intensity .+
    0.11 .* data.transmission_strength .+
    0.12 .* data.institutional_reinforcement .-
    0.13 .* data.norm_conflict .-
    0.08 .* data.hypocrisy_visibility .-
    0.07 .* data.unequal_enforcement .-
    0.05 .* data.performative_compliance .+
    0.04 .* data.distributional_attention

min_raw = minimum(data.cooperation_raw)
max_raw = maximum(data.cooperation_raw)
data.cooperation_score = (data.cooperation_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_norm_compliance = data.cooperation_score .>= 60
data.fragile_norm_environment = (data.high_norm_compliance .== true) .& (data.trust .< 40)
data.high_burden_norm_environment = (data.high_norm_compliance .== true) .& (data.unequal_enforcement .> 65) .& (data.distributional_attention .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "social_norms_julia_simulation.csv"), data)

println("Mean cooperation score: ", mean(data.cooperation_score))
println("High norm compliance rate: ", mean(data.high_norm_compliance))
println("Fragile norm environment rate: ", mean(data.fragile_norm_environment))
println("High-burden norm environment rate: ", mean(data.high_burden_norm_environment))
