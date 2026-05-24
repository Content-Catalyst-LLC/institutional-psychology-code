# Institutional norms and social expectations simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1919)

n = 500

data = DataFrame(
    unit_id = 1:n,
    norm_repetition = rand(n) .* 85 .+ 10,
    expectation_convergence = rand(n) .* 85 .+ 10,
    internalization = rand(n) .* 85 .+ 10,
    social_enforcement = rand(n) .* 85 .+ 10,
    legitimacy_alignment = rand(n) .* 85 .+ 10,
    trust_reinforcement = rand(n) .* 85 .+ 10,
    role_clarity = rand(n) .* 85 .+ 10,
    learning_capacity = rand(n) .* 85 .+ 10,
    alternative_norm_visibility = rand(n) .* 90 .+ 5,
    sanction_cost = rand(n) .* 90 .+ 5,
    suppressive_pressure = rand(n) .* 90 .+ 5,
    fragmentation_pressure = rand(n) .* 90 .+ 5,
    unequal_normative_burden = rand(n) .* 90 .+ 5,
    rigidity_pressure = rand(n) .* 90 .+ 5
)

data.normative_stability_raw =
    0.13 .* data.norm_repetition .+
    0.14 .* data.expectation_convergence .+
    0.13 .* data.internalization .+
    0.11 .* data.social_enforcement .+
    0.13 .* data.legitimacy_alignment .+
    0.11 .* data.trust_reinforcement .+
    0.09 .* data.role_clarity .+
    0.08 .* data.learning_capacity .-
    0.13 .* data.fragmentation_pressure .-
    0.10 .* data.unequal_normative_burden .-
    0.08 .* data.suppressive_pressure

function rescale100(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
end

data.normative_stability = rescale100(data.normative_stability_raw)
data.high_coordination = data.normative_stability .>= 60
data.fragile_normative_environment = (data.normative_stability .>= 60) .& (data.expectation_convergence .< 40) .& (data.legitimacy_alignment .< 40)
data.suppressive_norm_environment = (data.social_enforcement .> 70) .& (data.suppressive_pressure .> 65) .& (data.learning_capacity .< 40)

data.norm_change_readiness_raw =
    0.16 .* data.alternative_norm_visibility .+
    0.14 .* data.learning_capacity .+
    0.12 .* data.legitimacy_alignment .-
    0.15 .* data.sanction_cost .-
    0.12 .* data.rigidity_pressure .-
    0.10 .* data.suppressive_pressure

data.norm_change_readiness = rescale100(data.norm_change_readiness_raw)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_norms_julia_simulation.csv"), data)

println("Mean normative stability: ", mean(data.normative_stability))
println("High coordination rate: ", mean(data.high_coordination))
println("Fragile normative environment rate: ", mean(data.fragile_normative_environment))
println("Suppressive norm environment rate: ", mean(data.suppressive_norm_environment))
println("Mean norm change readiness: ", mean(data.norm_change_readiness))
