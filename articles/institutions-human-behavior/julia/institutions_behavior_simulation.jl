# Institutions and human behavior simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(2020)

n = 500

data = DataFrame(
    unit_id = 1:n,
    normative_stability = rand(n) .* 85 .+ 10,
    legitimacy_strength = rand(n) .* 85 .+ 10,
    incentive_alignment = rand(n) .* 85 .+ 10,
    information_quality = rand(n) .* 85 .+ 10,
    memory_retention = rand(n) .* 85 .+ 10,
    learning_capacity = rand(n) .* 85 .+ 10,
    trust_reinforcement = rand(n) .* 85 .+ 10,
    role_clarity = rand(n) .* 85 .+ 10,
    repair_capacity = rand(n) .* 85 .+ 10,
    administrative_burden = rand(n) .* 90 .+ 5,
    opacity_pressure = rand(n) .* 90 .+ 5,
    historical_harm_pressure = rand(n) .* 90 .+ 5,
    fragmentation_pressure = rand(n) .* 90 .+ 5
)

data.institutional_strength_raw =
    0.13 .* data.normative_stability .+
    0.14 .* data.legitimacy_strength .+
    0.11 .* data.incentive_alignment .+
    0.12 .* data.information_quality .+
    0.11 .* data.memory_retention .+
    0.13 .* data.learning_capacity .+
    0.12 .* data.trust_reinforcement .+
    0.08 .* data.role_clarity .+
    0.08 .* data.repair_capacity .-
    0.12 .* data.fragmentation_pressure .-
    0.08 .* data.opacity_pressure .-
    0.08 .* data.administrative_burden .-
    0.07 .* data.historical_harm_pressure

function rescale100(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
end

data.institutional_strength = rescale100(data.institutional_strength_raw)

data.behavioral_alignment_raw =
    0.18 .* data.institutional_strength .+
    0.13 .* data.legitimacy_strength .+
    0.12 .* data.normative_stability .+
    0.12 .* data.incentive_alignment .+
    0.12 .* data.trust_reinforcement .+
    0.10 .* data.role_clarity .-
    0.11 .* data.fragmentation_pressure .-
    0.08 .* data.opacity_pressure .-
    0.08 .* data.administrative_burden

data.behavioral_alignment = rescale100(data.behavioral_alignment_raw)
data.high_institutional_alignment = data.institutional_strength .>= 60
data.high_behavioral_alignment = data.behavioral_alignment .>= 60
data.fragile_institutional_environment = (data.institutional_strength .>= 60) .& (data.legitimacy_strength .< 40) .& (data.normative_stability .< 40)
data.high_fragmentation_environment = (data.fragmentation_pressure .> 70) .& (data.opacity_pressure .> 65) .& (data.repair_capacity .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutions_behavior_julia_simulation.csv"), data)

println("Mean institutional strength: ", mean(data.institutional_strength))
println("Mean behavioral alignment: ", mean(data.behavioral_alignment))
println("High institutional alignment rate: ", mean(data.high_institutional_alignment))
println("High behavioral alignment rate: ", mean(data.high_behavioral_alignment))
println("Fragile institutional environment rate: ", mean(data.fragile_institutional_environment))
