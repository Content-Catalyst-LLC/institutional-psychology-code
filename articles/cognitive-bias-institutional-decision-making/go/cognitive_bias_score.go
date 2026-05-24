package main

import "fmt"

type BiasDecisionCase struct {
	Overconfidence      float64
	ConformityPressure float64
	FilteringDistortion float64
	PathLockIn          float64
	MetricTunnelVision  float64
	PowerProtection     float64
	DissentCapacity     float64
	CorrectiveReview    float64
	InformationQuality  float64
	FeedbackOpenness    float64
	PsychologicalSafety float64
	JusticeVoice        float64
}

func DecisionQualityRaw(x BiasDecisionCase) float64 {
	return 0.14*x.DissentCapacity +
		0.14*x.CorrectiveReview +
		0.14*x.InformationQuality +
		0.13*x.FeedbackOpenness +
		0.11*x.PsychologicalSafety +
		0.10*x.JusticeVoice -
		0.13*x.Overconfidence -
		0.13*x.ConformityPressure -
		0.14*x.FilteringDistortion -
		0.12*x.PathLockIn -
		0.10*x.MetricTunnelVision -
		0.09*x.PowerProtection
}

func main() {
	demo := BiasDecisionCase{22, 25, 24, 28, 20, 21, 82, 80, 84, 78, 76, 72}
	fmt.Printf("Institutional decision quality raw score: %.2f\n", DecisionQualityRaw(demo))
}
