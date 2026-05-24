# Coordination problems in institutional systems simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(404)

n = 500

data = DataFrame(
    unit_id = 1:n,
    trust = rand(n) .* 85 .+ 10,
    information_quality = rand(n) .* 85 .+ 10,
    communication_clarity = rand(n) .* 85 .+ 10,
    focal_salience = rand(n) .* 90 .+ 5,
    authority_signal = rand(n) .* 90 .+ 5,
    norm_strength = rand(n) .* 85 .+ 10,
    learning_capacity = rand(n) .* 85 .+ 10,
    uncertainty = rand(n) .* 90 .+ 5,
    adaptation_burden = rand(n) .* 90 .+ 5,
    competing_standards = rand(n) .* 90 .+ 5,
    competing_authority = rand(n) .* 90 .+ 5,
    distributional_attention = rand(n) .* 90 .+ 5
)

data.coordination_raw =
    0.14 .* data.trust .+
    0.14 .* data.information_quality .+
    0.13 .* data.communication_clarity .+
    0.12 .* data.focal_salience .+
    0.10 .* data.authority_signal .+
    0.10 .* data.norm_strength .+
    0.09 .* data.learning_capacity .-
    0.13 .* data.uncertainty .-
    0.07 .* data.adaptation_burden .-
    0.06 .* data.competing_standards .-
    0.05 .* data.competing_authority .+
    0.04 .* data.distributional_attention

min_raw = minimum(data.coordination_raw)
max_raw = maximum(data.coordination_raw)
data.coordination_quality = (data.coordination_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_alignment = data.coordination_quality .>= 60
data.fragile_coordination = (data.high_alignment .== true) .& (data.trust .< 40)
data.high_burden_coordination = (data.high_alignment .== true) .& (data.adaptation_burden .> 65) .& (data.distributional_attention .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "coordination_julia_simulation.csv"), data)

println("Mean coordination quality: ", mean(data.coordination_quality))
println("High alignment rate: ", mean(data.high_alignment))
println("Fragile coordination rate: ", mean(data.fragile_coordination))
println("High-burden coordination rate: ", mean(data.high_burden_coordination))
