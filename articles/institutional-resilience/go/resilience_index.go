package main

import "fmt"

type Institution struct {
	Robustness               float64
	AdaptiveCapacity         float64
	RecoveryCapacity         float64
	TransformationalCapacity float64
	Legitimacy               float64
	Trust                    float64
	FeedbackQuality          float64
	LearningRate             float64
	Redundancy               float64
	Modularity               float64
	Coordination             float64
	ShockIntensity           float64
}

func ResilienceIndex(x Institution) float64 {
	return 0.10*x.Robustness +
		0.12*x.AdaptiveCapacity +
		0.10*x.RecoveryCapacity +
		0.08*x.TransformationalCapacity +
		0.12*x.Legitimacy +
		0.10*x.Trust +
		0.10*x.FeedbackQuality +
		0.08*x.LearningRate +
		0.07*x.Redundancy +
		0.05*x.Modularity +
		0.08*x.Coordination -
		0.10*x.ShockIntensity
}

func main() {
	demo := Institution{80, 75, 70, 60, 85, 82, 78, 74, 65, 68, 80, 50}
	fmt.Printf("Institutional resilience raw score: %.2f\n", ResilienceIndex(demo))
}
