package main

import "fmt"

type LegitimacyCase struct {
	FormalAuthorityClarity float64
	ProceduralLegitimacy   float64
	OutcomeLegitimacy      float64
	Trust                  float64
	RuleClarity            float64
	SocialRecognition      float64
	Accountability         float64
	RepairCapacity         float64
	Fairness               float64
	ArbitrarinessPressure  float64
	VisibleInconsistency   float64
	UnequalBurden          float64
	OpacityPressure        float64
}

func AuthorityLegitimacyRaw(x LegitimacyCase) float64 {
	return 0.11*x.FormalAuthorityClarity +
		0.14*x.ProceduralLegitimacy +
		0.12*x.OutcomeLegitimacy +
		0.13*x.Trust +
		0.11*x.RuleClarity +
		0.11*x.SocialRecognition +
		0.12*x.Accountability +
		0.10*x.RepairCapacity +
		0.10*x.Fairness -
		0.14*x.ArbitrarinessPressure -
		0.10*x.VisibleInconsistency -
		0.09*x.UnequalBurden -
		0.08*x.OpacityPressure
}

func main() {
	demo := LegitimacyCase{82, 84, 78, 80, 82, 76, 79, 74, 81, 22, 20, 18, 19}
	fmt.Printf("Authority-legitimacy raw score: %.2f\n", AuthorityLegitimacyRaw(demo))
}
