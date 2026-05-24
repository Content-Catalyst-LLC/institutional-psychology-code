# Institutional path dependence simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(101)

n = 500

data = DataFrame(
    institution_id = 1:n,
    initial_conditions = rand(n) .* 75 .+ 20,
    behavioral_reinforcement = rand(n) .* 80 .+ 15,
    feedback_strength = rand(n) .* 75 .+ 20,
    increasing_returns = rand(n) .* 85 .+ 10,
    coordination_effects = rand(n) .* 80 .+ 15,
    learning_effects = rand(n) .* 75 .+ 20,
    legitimacy = rand(n) .* 75 .+ 20,
    switching_costs = rand(n) .* 90 .+ 10,
    complementarity = rand(n) .* 80 .+ 15,
    disruption_pressure = rand(n) .* 85 .+ 5,
    reform_capacity = rand(n) .* 90 .+ 5,
    distributional_burden = rand(n) .* 90 .+ 5
)

data.path_dependence_raw =
    0.08 .* data.initial_conditions .+
    0.12 .* data.behavioral_reinforcement .+
    0.12 .* data.feedback_strength .+
    0.13 .* data.increasing_returns .+
    0.11 .* data.coordination_effects .+
    0.10 .* data.learning_effects .+
    0.12 .* data.legitimacy .+
    0.12 .* data.switching_costs .+
    0.10 .* data.complementarity .-
    0.12 .* data.disruption_pressure .-
    0.05 .* data.reform_capacity

min_raw = minimum(data.path_dependence_raw)
max_raw = maximum(data.path_dependence_raw)
data.path_dependence_score = (data.path_dependence_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.lock_in = data.path_dependence_score .>= 60
data.strong_lock_in = data.path_dependence_score .>= 75
data.high_burden_lock_in = (data.path_dependence_score .>= 60) .& (data.distributional_burden .>= 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_path_dependence_julia_simulation.csv"), data)

println("Mean path dependence score: ", mean(data.path_dependence_score))
println("Lock-in rate: ", mean(data.lock_in))
println("Strong lock-in rate: ", mean(data.strong_lock_in))
println("High-burden lock-in rate: ", mean(data.high_burden_lock_in))
