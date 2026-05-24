package main

import "fmt"

type BehavioralGovernanceCase struct {
	IncentiveAlignment       float64
	Legitimacy              float64
	NormSupport             float64
	CognitiveInterpretability float64
	Trust                   float64
	CoordinationQuality     float64
	EnforcementCredibility  float64
	AdaptiveLearning        float64
	PerceivedFairness       float64
	BehavioralBurden        float64
	HypocrisyVisibility     float64
	PowerAsymmetry          float64
}

func BehavioralGovernanceScoreRaw(x BehavioralGovernanceCase) float64 {
	return 0.11*x.IncentiveAlignment +
		0.13*x.Legitimacy +
		0.10*x.NormSupport +
		0.11*x.CognitiveInterpretability +
		0.12*x.Trust +
		0.11*x.CoordinationQuality +
		0.10*x.EnforcementCredibility +
		0.11*x.AdaptiveLearning +
		0.10*x.PerceivedFairness -
		0.10*x.BehavioralBurden -
		0.07*x.HypocrisyVisibility -
		0.06*x.PowerAsymmetry
}

func main() {
	demo := BehavioralGovernanceCase{78, 76, 72, 80, 74, 75, 70, 73, 77, 28, 20, 25}
	fmt.Printf("Behavioral governance raw score: %.2f\n", BehavioralGovernanceScoreRaw(demo))
}
