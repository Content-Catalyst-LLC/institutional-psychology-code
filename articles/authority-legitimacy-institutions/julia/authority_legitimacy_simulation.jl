# Authority and legitimacy simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1818)

n = 500

data = DataFrame(
    unit_id = 1:n,
    formal_authority_clarity = rand(n) .* 85 .+ 10,
    procedural_legitimacy = rand(n) .* 85 .+ 10,
    outcome_legitimacy = rand(n) .* 85 .+ 10,
    trust = rand(n) .* 85 .+ 10,
    rule_clarity = rand(n) .* 85 .+ 10,
    social_recognition = rand(n) .* 85 .+ 10,
    accountability = rand(n) .* 85 .+ 10,
    repair_capacity = rand(n) .* 85 .+ 10,
    fairness = rand(n) .* 85 .+ 10,
    shared_norm_support = rand(n) .* 85 .+ 10,
    arbitrariness_pressure = rand(n) .* 90 .+ 5,
    visible_inconsistency = rand(n) .* 90 .+ 5,
    unequal_burden = rand(n) .* 90 .+ 5,
    opacity_pressure = rand(n) .* 90 .+ 5,
    enforcement_coercion_pressure = rand(n) .* 90 .+ 5
)

data.authority_legitimacy_raw =
    0.11 .* data.formal_authority_clarity .+
    0.14 .* data.procedural_legitimacy .+
    0.12 .* data.outcome_legitimacy .+
    0.13 .* data.trust .+
    0.11 .* data.rule_clarity .+
    0.11 .* data.social_recognition .+
    0.12 .* data.accountability .+
    0.10 .* data.repair_capacity .+
    0.10 .* data.fairness .-
    0.14 .* data.arbitrariness_pressure .-
    0.10 .* data.visible_inconsistency .-
    0.09 .* data.unequal_burden .-
    0.08 .* data.opacity_pressure

function rescale100(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
end

data.authority_legitimacy_strength = rescale100(data.authority_legitimacy_raw)

data.voluntary_compliance_raw =
    0.20 .* data.authority_legitimacy_strength .+
    0.13 .* data.trust .+
    0.12 .* data.fairness .+
    0.11 .* data.shared_norm_support .+
    0.10 .* data.rule_clarity .+
    0.08 .* data.repair_capacity .-
    0.12 .* data.enforcement_coercion_pressure .-
    0.10 .* data.arbitrariness_pressure .-
    0.08 .* data.unequal_burden

data.voluntary_compliance = rescale100(data.voluntary_compliance_raw)
data.high_legitimacy = data.authority_legitimacy_strength .>= 60
data.high_voluntary_compliance = data.voluntary_compliance .>= 60
data.fragile_legitimacy_environment = (data.high_legitimacy .== true) .& (data.procedural_legitimacy .< 40) .& (data.trust .< 40)
data.high_arbitrariness_environment = (data.arbitrariness_pressure .> 70) .& (data.visible_inconsistency .> 65) .& (data.repair_capacity .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "authority_legitimacy_julia_simulation.csv"), data)

println("Mean authority-legitimacy strength: ", mean(data.authority_legitimacy_strength))
println("Mean voluntary compliance: ", mean(data.voluntary_compliance))
println("High legitimacy rate: ", mean(data.high_legitimacy))
println("High voluntary compliance rate: ", mean(data.high_voluntary_compliance))
println("Fragile legitimacy environment rate: ", mean(data.fragile_legitimacy_environment))
