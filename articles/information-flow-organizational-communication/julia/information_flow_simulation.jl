# Information flow and organizational communication simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1414)

n = 500

data = DataFrame(
    unit_id = 1:n,
    signal_quality = rand(n) .* 85 .+ 10,
    communication_quality = rand(n) .* 85 .+ 10,
    interpretive_integration = rand(n) .* 85 .+ 10,
    feedback_usability = rand(n) .* 85 .+ 10,
    memory_retention = rand(n) .* 85 .+ 10,
    openness = rand(n) .* 85 .+ 10,
    escalation_access = rand(n) .* 85 .+ 10,
    trust = rand(n) .* 85 .+ 10,
    community_voice = rand(n) .* 85 .+ 10,
    digital_transparency = rand(n) .* 85 .+ 10,
    distortion_loss = rand(n) .* 90 .+ 5,
    overload = rand(n) .* 90 .+ 5,
    siloing = rand(n) .* 90 .+ 5,
    suppression_pressure = rand(n) .* 90 .+ 5,
    metric_tunnel_vision = rand(n) .* 90 .+ 5
)

data.information_raw =
    0.12 .* data.signal_quality .+
    0.12 .* data.communication_quality .+
    0.12 .* data.interpretive_integration .+
    0.11 .* data.feedback_usability .+
    0.10 .* data.memory_retention .+
    0.11 .* data.openness .+
    0.09 .* data.escalation_access .+
    0.08 .* data.trust .+
    0.07 .* data.community_voice .+
    0.07 .* data.digital_transparency .-
    0.12 .* data.distortion_loss .-
    0.09 .* data.overload .-
    0.08 .* data.siloing .-
    0.08 .* data.suppression_pressure .-
    0.07 .* data.metric_tunnel_vision

min_raw = minimum(data.information_raw)
max_raw = maximum(data.information_raw)
data.information_effectiveness = (data.information_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_integration = data.information_effectiveness .>= 60
data.fragile_communication = (data.high_integration .== true) .& (data.openness .< 40) .& (data.distortion_loss .> 65)
data.high_overload_system = (data.high_integration .== true) .& (data.overload .> 70) .& (data.metric_tunnel_vision .> 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "information_flow_julia_simulation.csv"), data)

println("Mean information effectiveness: ", mean(data.information_effectiveness))
println("High integration rate: ", mean(data.high_integration))
println("Fragile communication rate: ", mean(data.fragile_communication))
println("High overload system rate: ", mean(data.high_overload_system))
