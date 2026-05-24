# Institutional incentives and behavioral responses simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1111)

n = 500

data = DataFrame(
    unit_id = 1:n,
    value_alignment = rand(n) .* 85 .+ 10,
    fairness = rand(n) .* 85 .+ 10,
    information_quality = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    learning_support = rand(n) .* 85 .+ 10,
    accountability = rand(n) .* 85 .+ 10,
    bias_pressure = rand(n) .* 90 .+ 5,
    metric_substitution = rand(n) .* 90 .+ 5,
    reporting_distortion = rand(n) .* 90 .+ 5,
    behavioral_burden = rand(n) .* 90 .+ 5,
    short_termism = rand(n) .* 90 .+ 5,
    status_inequality = rand(n) .* 90 .+ 5,
    motivation_crowding = rand(n) .* 90 .+ 5
)

data.incentive_raw =
    0.14 .* data.value_alignment .+
    0.12 .* data.fairness .+
    0.13 .* data.information_quality .+
    0.12 .* data.legitimacy .+
    0.12 .* data.learning_support .+
    0.10 .* data.accountability .-
    0.10 .* data.bias_pressure .-
    0.12 .* data.metric_substitution .-
    0.09 .* data.reporting_distortion .-
    0.08 .* data.behavioral_burden .-
    0.07 .* data.short_termism .-
    0.06 .* data.status_inequality .-
    0.05 .* data.motivation_crowding

min_raw = minimum(data.incentive_raw)
max_raw = maximum(data.incentive_raw)
data.incentive_effectiveness = (data.incentive_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_alignment = data.incentive_effectiveness .>= 60
data.fragile_incentive_system = (data.high_alignment .== true) .& (data.legitimacy .< 40)
data.high_burden_incentive_system = (data.high_alignment .== true) .& (data.behavioral_burden .> 65) .& (data.metric_substitution .> 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_incentives_julia_simulation.csv"), data)

println("Mean incentive effectiveness: ", mean(data.incentive_effectiveness))
println("High alignment rate: ", mean(data.high_alignment))
println("Fragile incentive system rate: ", mean(data.fragile_incentive_system))
println("High-burden incentive system rate: ", mean(data.high_burden_incentive_system))
