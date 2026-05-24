package main

import "fmt"

type NormCase struct {
	NormRepetition          float64
	ExpectationConvergence  float64
	Internalization         float64
	SocialEnforcement       float64
	LegitimacyAlignment     float64
	TrustReinforcement      float64
	RoleClarity             float64
	LearningCapacity        float64
	FragmentationPressure   float64
	UnequalNormativeBurden  float64
	SuppressivePressure     float64
}

func NormativeStabilityRaw(x NormCase) float64 {
	return 0.13*x.NormRepetition +
		0.14*x.ExpectationConvergence +
		0.13*x.Internalization +
		0.11*x.SocialEnforcement +
		0.13*x.LegitimacyAlignment +
		0.11*x.TrustReinforcement +
		0.09*x.RoleClarity +
		0.08*x.LearningCapacity -
		0.13*x.FragmentationPressure -
		0.10*x.UnequalNormativeBurden -
		0.08*x.SuppressivePressure
}

func main() {
	demo := NormCase{82, 84, 78, 76, 80, 79, 77, 74, 22, 20, 18}
	fmt.Printf("Normative stability raw score: %.2f\n", NormativeStabilityRaw(demo))
}
