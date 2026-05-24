package main

import "fmt"

type CollectiveActionCase struct {
	IncentiveAlignment    float64
	Trust                 float64
	Legitimacy            float64
	NormStrength          float64
	EnforcementCredibility float64
	CommunicationQuality  float64
	CoordinationQuality   float64
	PerceivedFairness     float64
	FreeRidingPressure    float64
	BurdenInequality      float64
	HypocrisyVisibility   float64
	ScaleComplexity       float64
}

func CollectiveActionScoreRaw(x CollectiveActionCase) float64 {
	return 0.12*x.IncentiveAlignment +
		0.13*x.Trust +
		0.12*x.Legitimacy +
		0.11*x.NormStrength +
		0.10*x.EnforcementCredibility +
		0.11*x.CommunicationQuality +
		0.11*x.CoordinationQuality +
		0.10*x.PerceivedFairness -
		0.12*x.FreeRidingPressure -
		0.07*x.BurdenInequality -
		0.06*x.HypocrisyVisibility -
		0.05*x.ScaleComplexity
}

func main() {
	demo := CollectiveActionCase{78, 76, 74, 72, 70, 80, 75, 73, 30, 25, 20, 35}
	fmt.Printf("Collective action raw score: %.2f\n", CollectiveActionScoreRaw(demo))
}
