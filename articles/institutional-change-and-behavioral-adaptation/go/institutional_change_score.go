package main

import "fmt"

type InstitutionalChangeCase struct {
	FeedbackQuality        float64
	AdaptiveCapacity       float64
	Legitimacy             float64
	IncentiveAlignment     float64
	NormativeSupport       float64
	GovernanceCapacity     float64
	PathDependence         float64
	BehavioralFlexibility  float64
	CoordinationQuality    float64
	EnvironmentalChange    float64
	DistributionalAttention float64
	TransitionBurden       float64
}

func InstitutionalChangeScoreRaw(x InstitutionalChangeCase) float64 {
	return 0.13*x.FeedbackQuality +
		0.14*x.AdaptiveCapacity +
		0.10*x.Legitimacy +
		0.10*x.IncentiveAlignment +
		0.09*x.NormativeSupport +
		0.12*x.GovernanceCapacity -
		0.12*x.PathDependence +
		0.10*x.BehavioralFlexibility +
		0.08*x.CoordinationQuality +
		0.06*x.EnvironmentalChange +
		0.05*x.DistributionalAttention -
		0.05*x.TransitionBurden
}

func main() {
	demo := InstitutionalChangeCase{80, 78, 75, 70, 72, 82, 40, 76, 74, 65, 70, 35}
	fmt.Printf("Institutional change raw score: %.2f\n", InstitutionalChangeScoreRaw(demo))
}
