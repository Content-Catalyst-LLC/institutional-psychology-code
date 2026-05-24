package main

import "fmt"

type InstitutionalEnforcementCase struct {
	MonitoringQuality    float64
	Legitimacy           float64
	IncentiveAlignment   float64
	SanctionCredibility  float64
	InformationQuality   float64
	AdaptiveLearning     float64
	AccountabilityReach  float64
	ComplianceBurden     float64
	SelectiveEnforcement float64
	EvasionPressure      float64
	HypocrisyVisibility  float64
	DefensiveCompliance  float64
}

func InstitutionalEnforcementScoreRaw(x InstitutionalEnforcementCase) float64 {
	return 0.13*x.MonitoringQuality +
		0.13*x.Legitimacy +
		0.12*x.IncentiveAlignment +
		0.12*x.SanctionCredibility +
		0.13*x.InformationQuality +
		0.11*x.AdaptiveLearning +
		0.10*x.AccountabilityReach -
		0.08*x.ComplianceBurden -
		0.08*x.SelectiveEnforcement -
		0.12*x.EvasionPressure -
		0.06*x.HypocrisyVisibility -
		0.06*x.DefensiveCompliance
}

func main() {
	demo := InstitutionalEnforcementCase{82, 76, 74, 72, 80, 75, 70, 30, 24, 22, 18, 20}
	fmt.Printf("Institutional enforcement raw score: %.2f\n", InstitutionalEnforcementScoreRaw(demo))
}
