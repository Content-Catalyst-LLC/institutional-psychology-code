package main

import "fmt"

type TrustCase struct {
	Consistency              float64
	Competence               float64
	Fairness                 float64
	Transparency             float64
	Accountability           float64
	Integrity                float64
	RecognitionVoice         float64
	RepairCapacity           float64
	ArbitrarinessPressure    float64
	VisibleViolationPressure float64
	AdministrativeBurden     float64
}

func TrustScoreRaw(x TrustCase) float64 {
	return 0.11*x.Consistency +
		0.12*x.Competence +
		0.14*x.Fairness +
		0.10*x.Transparency +
		0.13*x.Accountability +
		0.12*x.Integrity +
		0.09*x.RecognitionVoice +
		0.09*x.RepairCapacity -
		0.13*x.ArbitrarinessPressure -
		0.11*x.VisibleViolationPressure -
		0.08*x.AdministrativeBurden
}

func main() {
	demo := TrustCase{82, 80, 84, 78, 82, 79, 76, 74, 22, 20, 18}
	fmt.Printf("Institutional trust raw score: %.2f\n", TrustScoreRaw(demo))
}
