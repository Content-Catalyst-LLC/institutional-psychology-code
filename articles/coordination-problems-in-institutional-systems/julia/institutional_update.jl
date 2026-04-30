# Toy institutional effectiveness update model.

institutional_effectiveness = 0.45
legitimacy = 0.70
norms = 0.65
trust = 0.60
compliance = 0.68
learning = 0.55
fragmentation = 0.25
rate = 0.08

for t in 1:20
    institutional_effectiveness = institutional_effectiveness +
        rate * (0.20 * legitimacy + 0.18 * norms + 0.18 * trust + 0.16 * compliance + 0.14 * learning - 0.22 * fragmentation)
    institutional_effectiveness = clamp(institutional_effectiveness, 0.0, 1.0)
    println("Time ", t, ": institutional effectiveness = ", round(institutional_effectiveness, digits=3))
end
