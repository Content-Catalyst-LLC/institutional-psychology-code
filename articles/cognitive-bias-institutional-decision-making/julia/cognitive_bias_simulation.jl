# Cognitive bias in institutional decision-making simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1515)

n = 500

data = DataFrame(
    unit_id = 1:n,
    overconfidence = rand(n) .* 90 .+ 5,
    anchoring_pressure = rand(n) .* 90 .+ 5,
    confirmation_pressure = rand(n) .* 90 .+ 5,
    conformity_pressure = rand(n) .* 90 .+ 5,
    filtering_distortion = rand(n) .* 90 .+ 5,
    path_lock_in = rand(n) .* 90 .+ 5,
    metric_tunnel_vision = rand(n) .* 90 .+ 5,
    power_protection = rand(n) .* 90 .+ 5,
    dissent_capacity = rand(n) .* 85 .+ 10,
    corrective_review = rand(n) .* 85 .+ 10,
    information_quality = rand(n) .* 85 .+ 10,
    feedback_openness = rand(n) .* 85 .+ 10,
    psychological_safety = rand(n) .* 85 .+ 10,
    justice_voice = rand(n) .* 85 .+ 10
)

data.bias_pressure_raw =
    0.12 .* data.overconfidence .+
    0.11 .* data.anchoring_pressure .+
    0.11 .* data.confirmation_pressure .+
    0.11 .* data.conformity_pressure .+
    0.12 .* data.filtering_distortion .+
    0.10 .* data.path_lock_in .+
    0.09 .* data.metric_tunnel_vision .+
    0.08 .* data.power_protection .-
    0.12 .* data.dissent_capacity .-
    0.11 .* data.corrective_review .-
    0.11 .* data.information_quality .-
    0.10 .* data.feedback_openness .-
    0.08 .* data.psychological_safety .-
    0.07 .* data.justice_voice

data.decision_quality_raw =
    0.14 .* data.dissent_capacity .+
    0.14 .* data.corrective_review .+
    0.14 .* data.information_quality .+
    0.13 .* data.feedback_openness .+
    0.11 .* data.psychological_safety .+
    0.10 .* data.justice_voice .-
    0.13 .* data.overconfidence .-
    0.13 .* data.conformity_pressure .-
    0.14 .* data.filtering_distortion .-
    0.12 .* data.path_lock_in .-
    0.10 .* data.metric_tunnel_vision .-
    0.09 .* data.power_protection

function rescale100(x)
    return (x .- minimum(x)) ./ (maximum(x) - minimum(x)) .* 100
end

data.institutional_bias_pressure = rescale100(data.bias_pressure_raw)
data.decision_quality = rescale100(data.decision_quality_raw)
data.high_resilience_decision = data.decision_quality .>= 60
data.fragile_judgment = (data.high_resilience_decision .== true) .& (data.dissent_capacity .< 40) .& (data.filtering_distortion .> 65)
data.high_bias_environment = (data.institutional_bias_pressure .>= 65) .& (data.corrective_review .< 40) .& (data.feedback_openness .< 40)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "cognitive_bias_julia_simulation.csv"), data)

println("Mean decision quality: ", mean(data.decision_quality))
println("Mean institutional bias pressure: ", mean(data.institutional_bias_pressure))
println("High resilience decision rate: ", mean(data.high_resilience_decision))
println("Fragile judgment rate: ", mean(data.fragile_judgment))
println("High-bias environment rate: ", mean(data.high_bias_environment))
