# Decision-making in institutional systems simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1616)

n = 500

data = DataFrame(
    unit_id = 1:n,
    bounded_rationality_pressure = rand(n) .* 90 .+ 5,
    organizational_structure_quality = rand(n) .* 85 .+ 10,
    incentive_alignment = rand(n) .* 85 .+ 10,
    information_flow_effectiveness = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    uncertainty_management = rand(n) .* 85 .+ 10,
    corrective_capacity = rand(n) .* 85 .+ 10,
    justice_voice = rand(n) .* 85 .+ 10,
    memory_quality = rand(n) .* 85 .+ 10,
    feedback_openness = rand(n) .* 85 .+ 10,
    bias_distortion = rand(n) .* 90 .+ 5,
    power_protection = rand(n) .* 90 .+ 5,
    metric_fixation = rand(n) .* 90 .+ 5,
    siloing = rand(n) .* 90 .+ 5,
    premature_closure = rand(n) .* 90 .+ 5
)

data.decision_quality_raw =
    0.12 .* data.organizational_structure_quality .+
    0.12 .* data.incentive_alignment .+
    0.13 .* data.information_flow_effectiveness .+
    0.11 .* data.legitimacy .+
    0.11 .* data.uncertainty_management .+
    0.13 .* data.corrective_capacity .+
    0.09 .* data.justice_voice .+
    0.08 .* data.memory_quality .+
    0.08 .* data.feedback_openness .-
    0.13 .* data.bounded_rationality_pressure .-
    0.11 .* data.bias_distortion .-
    0.09 .* data.power_protection .-
    0.08 .* data.metric_fixation .-
    0.07 .* data.siloing .-
    0.07 .* data.premature_closure

function rescale100(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
end

data.decision_quality = rescale100(data.decision_quality_raw)
data.high_quality_decision = data.decision_quality .>= 60
data.fragile_decision_environment = (data.high_quality_decision .== true) .& (data.corrective_capacity .< 40) .& (data.information_flow_effectiveness .< 45)
data.high_distortion_environment = (data.bias_distortion .> 70) .& (data.power_protection .> 65) .& (data.feedback_openness .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "decision_quality_julia_simulation.csv"), data)

println("Mean decision quality: ", mean(data.decision_quality))
println("High quality decision rate: ", mean(data.high_quality_decision))
println("Fragile decision environment rate: ", mean(data.fragile_decision_environment))
println("High distortion environment rate: ", mean(data.high_distortion_environment))
