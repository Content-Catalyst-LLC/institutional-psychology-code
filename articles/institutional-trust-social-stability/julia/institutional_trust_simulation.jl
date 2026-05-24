# Institutional trust and social stability simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1717)

n = 500

data = DataFrame(
    unit_id = 1:n,
    consistency = rand(n) .* 85 .+ 10,
    competence = rand(n) .* 85 .+ 10,
    fairness = rand(n) .* 85 .+ 10,
    transparency = rand(n) .* 85 .+ 10,
    accountability = rand(n) .* 85 .+ 10,
    integrity = rand(n) .* 85 .+ 10,
    recognition_voice = rand(n) .* 85 .+ 10,
    repair_capacity = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    voluntary_compliance = rand(n) .* 85 .+ 10,
    cooperation_capacity = rand(n) .* 85 .+ 10,
    learning_repair = rand(n) .* 85 .+ 10,
    arbitrariness_pressure = rand(n) .* 90 .+ 5,
    visible_violation_pressure = rand(n) .* 90 .+ 5,
    fragmentation_pressure = rand(n) .* 90 .+ 5,
    administrative_burden = rand(n) .* 90 .+ 5
)

data.trust_raw =
    0.11 .* data.consistency .+
    0.12 .* data.competence .+
    0.14 .* data.fairness .+
    0.10 .* data.transparency .+
    0.13 .* data.accountability .+
    0.12 .* data.integrity .+
    0.09 .* data.recognition_voice .+
    0.09 .* data.repair_capacity .-
    0.13 .* data.arbitrariness_pressure .-
    0.11 .* data.visible_violation_pressure .-
    0.08 .* data.administrative_burden

function rescale100(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
end

data.trust_score = rescale100(data.trust_raw)

data.stability_raw =
    0.18 .* data.trust_score .+
    0.14 .* data.legitimacy .+
    0.13 .* data.voluntary_compliance .+
    0.12 .* data.cooperation_capacity .+
    0.10 .* data.learning_repair .+
    0.08 .* data.repair_capacity .-
    0.12 .* data.arbitrariness_pressure .-
    0.10 .* data.fragmentation_pressure .-
    0.08 .* data.visible_violation_pressure

data.social_stability = rescale100(data.stability_raw)
data.high_trust = data.trust_score .>= 60
data.high_stability = data.social_stability .>= 60
data.fragile_trust_environment = (data.high_trust .== true) .& (data.fairness .< 40) .& (data.accountability .< 40)
data.high_distrust_pressure = (data.arbitrariness_pressure .> 70) .& (data.visible_violation_pressure .> 65) .& (data.repair_capacity .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_trust_julia_simulation.csv"), data)

println("Mean trust score: ", mean(data.trust_score))
println("Mean social stability: ", mean(data.social_stability))
println("High trust rate: ", mean(data.high_trust))
println("High stability rate: ", mean(data.high_stability))
println("Fragile trust environment rate: ", mean(data.fragile_trust_environment))
