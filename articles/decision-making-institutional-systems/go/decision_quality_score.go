package main

import "fmt"

type DecisionQualityCase struct {
	BoundedRationalityPressure     float64
	OrganizationalStructureQuality float64
	IncentiveAlignment             float64
	InformationFlowEffectiveness   float64
	Legitimacy                     float64
	UncertaintyManagement          float64
	CorrectiveCapacity             float64
	JusticeVoice                   float64
	MemoryQuality                  float64
	FeedbackOpenness               float64
	BiasDistortion                 float64
	PowerProtection                float64
	MetricFixation                 float64
	Siloing                        float64
	PrematureClosure               float64
}

func DecisionQualityRaw(x DecisionQualityCase) float64 {
	return 0.12*x.OrganizationalStructureQuality +
		0.12*x.IncentiveAlignment +
		0.13*x.InformationFlowEffectiveness +
		0.11*x.Legitimacy +
		0.11*x.UncertaintyManagement +
		0.13*x.CorrectiveCapacity +
		0.09*x.JusticeVoice +
		0.08*x.MemoryQuality +
		0.08*x.FeedbackOpenness -
		0.13*x.BoundedRationalityPressure -
		0.11*x.BiasDistortion -
		0.09*x.PowerProtection -
		0.08*x.MetricFixation -
		0.07*x.Siloing -
		0.07*x.PrematureClosure
}

func main() {
	demo := DecisionQualityCase{24, 82, 78, 84, 80, 76, 82, 72, 74, 78, 22, 20, 24, 18, 21}
	fmt.Printf("Institutional decision quality raw score: %.2f\n", DecisionQualityRaw(demo))
}
