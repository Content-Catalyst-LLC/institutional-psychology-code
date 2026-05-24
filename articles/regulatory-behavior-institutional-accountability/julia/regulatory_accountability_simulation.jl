# Regulatory behavior and institutional accountability simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(808)

n = 500

data = DataFrame(
    unit_id = 1:n,
    oversight_strength = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    incentive_alignment = rand(n) .* 85 .+ 10,
    enforcement_credibility = rand(n) .* 90 .+ 5,
    information_quality = rand(n) .* 85 .+ 10,
    adaptive_learning = rand(n) .* 85 .+ 10,
    accountability_reach = rand(n) .* 90 .+ 5,
    capture_pressure = rand(n) .* 90 .+ 5,
    regulatory_burden = rand(n) .* 90 .+ 5,
    evasion_pressure = rand(n) .* 90 .+ 5,
    hypocrisy_visibility = rand(n) .* 90 .+ 5,
    unequal_accountability = rand(n) .* 90 .+ 5
)

data.accountability_raw =
    0.13 .* data.oversight_strength .+
    0.13 .* data.legitimacy .+
    0.11 .* data.incentive_alignment .+
    0.12 .* data.enforcement_credibility .+
    0.13 .* data.information_quality .+
    0.11 .* data.adaptive_learning .+
    0.11 .* data.accountability_reach .-
    0.12 .* data.capture_pressure .-
    0.08 .* data.regulatory_burden .-
    0.07 .* data.evasion_pressure .-
    0.06 .* data.hypocrisy_visibility .-
    0.06 .* data.unequal_accountability

min_raw = minimum(data.accountability_raw)
max_raw = maximum(data.accountability_raw)
data.accountability_effectiveness = (data.accountability_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_accountability = data.accountability_effectiveness .>= 60
data.fragile_regulation = (data.high_accountability .== true) .& (data.legitimacy .< 40)
data.high_burden_regulation = (data.high_accountability .== true) .& (data.regulatory_burden .> 65) .& (data.unequal_accountability .> 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "regulatory_accountability_julia_simulation.csv"), data)

println("Mean accountability effectiveness: ", mean(data.accountability_effectiveness))
println("High accountability rate: ", mean(data.high_accountability))
println("Fragile regulation rate: ", mean(data.fragile_regulation))
println("High-burden regulation rate: ", mean(data.high_burden_regulation))
