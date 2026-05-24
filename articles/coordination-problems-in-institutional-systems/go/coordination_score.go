package main

import "fmt"

type CoordinationCase struct {
	Trust                 float64
	InformationQuality    float64
	CommunicationClarity  float64
	FocalSalience         float64
	AuthoritySignal       float64
	NormStrength          float64
	LearningCapacity      float64
	Uncertainty           float64
	AdaptationBurden      float64
	CompetingStandards    float64
	CompetingAuthority    float64
	DistributionalAttention float64
}

func CoordinationScoreRaw(x CoordinationCase) float64 {
	return 0.14*x.Trust +
		0.14*x.InformationQuality +
		0.13*x.CommunicationClarity +
		0.12*x.FocalSalience +
		0.10*x.AuthoritySignal +
		0.10*x.NormStrength +
		0.09*x.LearningCapacity -
		0.13*x.Uncertainty -
		0.07*x.AdaptationBurden -
		0.06*x.CompetingStandards -
		0.05*x.CompetingAuthority +
		0.04*x.DistributionalAttention
}

func main() {
	demo := CoordinationCase{80, 78, 82, 76, 74, 70, 72, 30, 35, 25, 20, 68}
	fmt.Printf("Institutional coordination raw score: %.2f\n", CoordinationScoreRaw(demo))
}
