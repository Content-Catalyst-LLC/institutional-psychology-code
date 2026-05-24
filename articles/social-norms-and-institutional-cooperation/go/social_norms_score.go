package main

import "fmt"

type SocialNormsCase struct {
	DescriptiveNorm          float64
	InjunctiveNorm           float64
	Trust                    float64
	Legitimacy               float64
	SanctionIntensity        float64
	TransmissionStrength     float64
	InstitutionalReinforcement float64
	NormConflict             float64
	HypocrisyVisibility      float64
	UnequalEnforcement       float64
	PerformativeCompliance   float64
	DistributionalAttention  float64
}

func SocialNormsCooperationScoreRaw(x SocialNormsCase) float64 {
	return 0.14*x.DescriptiveNorm +
		0.14*x.InjunctiveNorm +
		0.13*x.Trust +
		0.12*x.Legitimacy +
		0.10*x.SanctionIntensity +
		0.11*x.TransmissionStrength +
		0.12*x.InstitutionalReinforcement -
		0.13*x.NormConflict -
		0.08*x.HypocrisyVisibility -
		0.07*x.UnequalEnforcement -
		0.05*x.PerformativeCompliance +
		0.04*x.DistributionalAttention
}

func main() {
	demo := SocialNormsCase{80, 78, 75, 72, 60, 74, 82, 30, 25, 20, 25, 70}
	fmt.Printf("Social norms cooperation raw score: %.2f\n", SocialNormsCooperationScoreRaw(demo))
}
