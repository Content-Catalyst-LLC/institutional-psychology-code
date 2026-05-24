# Institutional learning, feedback systems, and knowledge evolution simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(1212)

n = 500

data = DataFrame(
    unit_id = 1:n,
    feedback_quality = rand(n) .* 85 .+ 10,
    memory_retention = rand(n) .* 85 .+ 10,
    communication_openness = rand(n) .* 85 .+ 10,
    interpretive_quality = rand(n) .* 85 .+ 10,
    decision_revisability = rand(n) .* 85 .+ 10,
    psychological_safety = rand(n) .* 85 .+ 10,
    accountability_reach = rand(n) .* 85 .+ 10,
    disconfirming_evidence = rand(n) .* 90 .+ 5,
    institutional_inertia = rand(n) .* 90 .+ 5,
    signal_distortion = rand(n) .* 90 .+ 5,
    memory_decay = rand(n) .* 90 .+ 5,
    defensive_routines = rand(n) .* 90 .+ 5,
    power_protection = rand(n) .* 90 .+ 5,
    feedback_delay = rand(n) .* 90 .+ 5
)

data.learning_raw =
    0.13 .* data.feedback_quality .+
    0.12 .* data.memory_retention .+
    0.12 .* data.communication_openness .+
    0.12 .* data.interpretive_quality .+
    0.12 .* data.decision_revisability .+
    0.12 .* data.psychological_safety .+
    0.10 .* data.accountability_reach .+
    0.06 .* data.disconfirming_evidence .-
    0.12 .* data.institutional_inertia .-
    0.10 .* data.signal_distortion .-
    0.08 .* data.memory_decay .-
    0.08 .* data.defensive_routines .-
    0.08 .* data.power_protection .-
    0.07 .* data.feedback_delay

min_raw = minimum(data.learning_raw)
max_raw = maximum(data.learning_raw)
data.learning_capacity = (data.learning_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_adaptation = data.learning_capacity .>= 60
data.fragile_learning = (data.high_adaptation .== true) .& (data.communication_openness .< 40)
data.high_inertia_learning = (data.high_adaptation .== true) .& (data.institutional_inertia .> 65) .& (data.signal_distortion .> 65)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "institutional_learning_julia_simulation.csv"), data)

println("Mean learning capacity: ", mean(data.learning_capacity))
println("High adaptation rate: ", mean(data.high_adaptation))
println("Fragile learning rate: ", mean(data.fragile_learning))
println("High-inertia learning rate: ", mean(data.high_inertia_learning))
