# Public goods provision simulation in Julia.
# Synthetic demonstration only.

using Random
using Statistics
using CSV
using DataFrames

Random.seed!(303)

n = 500

data = DataFrame(
    unit_id = 1:n,
    trust = rand(n) .* 85 .+ 10,
    legitimacy = rand(n) .* 85 .+ 10,
    enforcement = rand(n) .* 90 .+ 5,
    norm_strength = rand(n) .* 85 .+ 10,
    coordination = rand(n) .* 85 .+ 10,
    monitoring = rand(n) .* 85 .+ 10,
    selective_incentives = rand(n) .* 90 .+ 5,
    scale_complexity = rand(n) .* 90 .+ 5,
    perceived_fairness = rand(n) .* 90 .+ 5,
    capture_risk = rand(n) .* 85 .+ 5,
    distributional_attention = rand(n) .* 90 .+ 5
)

data.contribution_rate =
    0.15 .* data.trust .+
    0.14 .* data.legitimacy .+
    0.12 .* data.enforcement .+
    0.11 .* data.norm_strength .+
    0.10 .* data.coordination .+
    0.10 .* data.monitoring .+
    0.09 .* data.selective_incentives .+
    0.08 .* data.perceived_fairness .-
    0.12 .* data.scale_complexity .-
    0.07 .* data.capture_risk

data.contribution_rate = clamp.(data.contribution_rate, 0, 100)

data.provision_quality_raw =
    0.22 .* data.contribution_rate .+
    0.13 .* data.legitimacy .+
    0.12 .* data.trust .+
    0.11 .* data.coordination .+
    0.10 .* data.monitoring .+
    0.08 .* data.distributional_attention .-
    0.12 .* data.scale_complexity .-
    0.08 .* data.capture_risk

min_raw = minimum(data.provision_quality_raw)
max_raw = maximum(data.provision_quality_raw)
data.provision_quality = (data.provision_quality_raw .- min_raw) ./ (max_raw - min_raw) .* 100
data.high_provision = data.provision_quality .>= 60
data.fragile_public_good = (data.high_provision .== true) .& (data.legitimacy .< 40)
data.high_burden_risk = (data.high_provision .== true) .& (data.distributional_attention .< 35)

outdir = joinpath(@__DIR__, "..", "outputs", "tables")
mkpath(outdir)
CSV.write(joinpath(outdir, "public_goods_julia_simulation.csv"), data)

println("Mean contribution rate: ", mean(data.contribution_rate))
println("Mean provision quality: ", mean(data.provision_quality))
println("High provision rate: ", mean(data.high_provision))
println("Fragile public good rate: ", mean(data.fragile_public_good))
