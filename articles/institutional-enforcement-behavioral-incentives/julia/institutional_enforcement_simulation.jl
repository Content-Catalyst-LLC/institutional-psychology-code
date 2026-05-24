# Institutional enforcement and behavioral incentives simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(909)

n = 500

data = DataFrame(
    unit_id = 1:n,
    monitoring_quality = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    incentive_alignment = rand(n) .* 85 .+ 10,
    sanction_credibility = rand(n) .* 90 .+ 5,
    information_quality = rand(n) .* 85 .+ 10,
    adaptive_learning = rand(n) .* 85 .+ 10,
    accountability_reach = rand(n) .* 90 .+ 5,
    compliance_burden = rand(n) .* 90 .+ 5,
    selective_enforcement = rand(n) .* 90 .+ 5,
    evasion_pressure = rand(n) .* 90 .+ 5,
    hypocrisy_visibility = rand(n) .* 90 .+ 5,
    defensive_compliance = rand(n) .* 90 .+ 5
)

data.enforcement_raw =
    0.13 .* data.monitoring_quality .+
    0.13 .* data.legitimacy .+
    0.12 .* data.incentive_alignment .+
    0.12 .* data.sanction_credibility .+
    0.13 .* data.information_quality .+
    0.11 .* data.adaptive_learning .+
    0.10 .* data.accountability_reach .-
    0.08 .* data.compliance_burden .-
    0.08 .* data.selective_enforcement .-
    0.12 .* data.evasion_pressure .-
    0.06 .* data.hypocrisy_visibility .-
    0.06 .* data.defensive_compliance

min_raw = minimum(data.enforcement_raw)
max_raw = maximum(data.enforcement_raw)
data.enforcement_effectiveness = (data.enforcement_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_compliance_quality = data.enforcement_effectiveness .>= 60
data.fragile_enforcement = (data.high_compliance_quality .== true) .& (data.legitimacy .< 40)
data.high_burden_enforcement = (data.high_compliance_quality .== true) .& (data.compliance_burden .> 65) .& (data.selective_enforcement .> 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_enforcement_julia_simulation.csv"), data)

println("Mean enforcement effectiveness: ", mean(data.enforcement_effectiveness))
println("High compliance quality rate: ", mean(data.high_compliance_quality))
println("Fragile enforcement rate: ", mean(data.fragile_enforcement))
println("High-burden enforcement rate: ", mean(data.high_burden_enforcement))
