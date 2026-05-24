package main

import (
	"fmt"
	"math"
)

type CrisisReformCase struct {
	CrisisSeverity          float64
	FeedbackBreakdown      float64
	LegitimacyFailure      float64
	AdaptiveCapacity       float64
	ReformWindow           float64
	CoalitionStrength      float64
	CoordinationQuality    float64
	LearningRate           float64
	GovernanceAlignment    float64
	PowerConcentration     float64
	CaptureRisk            float64
	DistributionalAttention float64
}

func TransformationScoreRaw(x CrisisReformCase) float64 {
	return 0.15*x.CrisisSeverity +
		0.11*x.FeedbackBreakdown +
		0.14*x.LegitimacyFailure +
		0.10*x.AdaptiveCapacity +
		0.12*x.ReformWindow +
		0.12*x.CoalitionStrength +
		0.08*x.CoordinationQuality +
		0.06*x.LearningRate +
		0.06*x.GovernanceAlignment +
		0.05*x.DistributionalAttention -
		0.07*x.CaptureRisk -
		0.04*math.Abs(x.PowerConcentration-50.0)
}

func main() {
	demo := CrisisReformCase{85, 78, 80, 70, 75, 68, 72, 65, 74, 55, 35, 80}
	fmt.Printf("Institutional transformation raw score: %.2f\n", TransformationScoreRaw(demo))
}
