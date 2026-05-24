package main

import "fmt"

type RegulatoryAccountabilityCase struct {
	OversightStrength     float64
	Legitimacy           float64
	IncentiveAlignment   float64
	EnforcementCredibility float64
	InformationQuality   float64
	AdaptiveLearning     float64
	AccountabilityReach  float64
	CapturePressure      float64
	RegulatoryBurden     float64
	EvasionPressure      float64
	HypocrisyVisibility  float64
	UnequalAccountability float64
}

func RegulatoryAccountabilityScoreRaw(x RegulatoryAccountabilityCase) float64 {
	return 0.13*x.OversightStrength +
		0.13*x.Legitimacy +
		0.11*x.IncentiveAlignment +
		0.12*x.EnforcementCredibility +
		0.13*x.InformationQuality +
		0.11*x.AdaptiveLearning +
		0.11*x.AccountabilityReach -
		0.12*x.CapturePressure -
		0.08*x.RegulatoryBurden -
		0.07*x.EvasionPressure -
		0.06*x.HypocrisyVisibility -
		0.06*x.UnequalAccountability
}

func main() {
	demo := RegulatoryAccountabilityCase{82, 76, 74, 72, 80, 75, 70, 25, 30, 22, 18, 24}
	fmt.Printf("Regulatory accountability raw score: %.2f\n", RegulatoryAccountabilityScoreRaw(demo))
}
