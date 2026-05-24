# Compliance and rule-following simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1001)

n = 500

data = DataFrame(
    unit_id = 1:n,
    legitimacy = rand(n) .* 85 .+ 10,
    fairness = rand(n) .* 85 .+ 10,
    incentive_alignment = rand(n) .* 85 .+ 10,
    norm_support = rand(n) .* 85 .+ 10,
    enforcement_credibility = rand(n) .* 90 .+ 5,
    communication_quality = rand(n) .* 85 .+ 10,
    cognitive_clarity = rand(n) .* 85 .+ 10,
    trust = rand(n) .* 85 .+ 10,
    adaptive_learning = rand(n) .* 85 .+ 10,
    compliance_burden = rand(n) .* 90 .+ 5,
    selective_rule_application = rand(n) .* 90 .+ 5,
    defensive_compliance = rand(n) .* 90 .+ 5,
    hypocrisy_visibility = rand(n) .* 90 .+ 5,
    norm_failure = rand(n) .* 90 .+ 5
)

data.compliance_raw =
    0.13 .* data.legitimacy .+
    0.13 .* data.fairness .+
    0.11 .* data.incentive_alignment .+
    0.11 .* data.norm_support .+
    0.10 .* data.enforcement_credibility .+
    0.11 .* data.communication_quality .+
    0.12 .* data.cognitive_clarity .+
    0.11 .* data.trust .+
    0.09 .* data.adaptive_learning .-
    0.11 .* data.compliance_burden .-
    0.08 .* data.selective_rule_application .-
    0.06 .* data.defensive_compliance .-
    0.05 .* data.hypocrisy_visibility .-
    0.05 .* data.norm_failure

min_raw = minimum(data.compliance_raw)
max_raw = maximum(data.compliance_raw)
data.compliance_quality = (data.compliance_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_compliance = data.compliance_quality .>= 60
data.fragile_compliance = (data.high_compliance .== true) .& (data.legitimacy .< 40)
data.high_burden_compliance = (data.high_compliance .== true) .& (data.compliance_burden .> 65) .& (data.selective_rule_application .> 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "compliance_rule_following_julia_simulation.csv"), data)

println("Mean compliance quality: ", mean(data.compliance_quality))
println("High compliance rate: ", mean(data.high_compliance))
println("Fragile compliance rate: ", mean(data.fragile_compliance))
println("High-burden compliance rate: ", mean(data.high_burden_compliance))
