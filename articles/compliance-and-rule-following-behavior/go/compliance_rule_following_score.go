package main

import "fmt"

type ComplianceCase struct {
	Legitimacy              float64
	Fairness                float64
	IncentiveAlignment      float64
	NormSupport             float64
	EnforcementCredibility  float64
	CommunicationQuality    float64
	CognitiveClarity        float64
	Trust                   float64
	AdaptiveLearning        float64
	ComplianceBurden        float64
	SelectiveRuleApplication float64
	DefensiveCompliance     float64
	HypocrisyVisibility     float64
	NormFailure             float64
}

func ComplianceQualityScoreRaw(x ComplianceCase) float64 {
	return 0.13*x.Legitimacy +
		0.13*x.Fairness +
		0.11*x.IncentiveAlignment +
		0.11*x.NormSupport +
		0.10*x.EnforcementCredibility +
		0.11*x.CommunicationQuality +
		0.12*x.CognitiveClarity +
		0.11*x.Trust +
		0.09*x.AdaptiveLearning -
		0.11*x.ComplianceBurden -
		0.08*x.SelectiveRuleApplication -
		0.06*x.DefensiveCompliance -
		0.05*x.HypocrisyVisibility -
		0.05*x.NormFailure
}

func main() {
	demo := ComplianceCase{76, 78, 72, 74, 70, 80, 82, 75, 73, 28, 24, 20, 18, 22}
	fmt.Printf("Compliance quality raw score: %.2f\n", ComplianceQualityScoreRaw(demo))
}
