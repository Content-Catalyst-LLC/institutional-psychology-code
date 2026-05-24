package main

import "fmt"

type InstitutionalIncentiveCase struct {
	ValueAlignment     float64
	Fairness           float64
	InformationQuality float64
	Legitimacy         float64
	LearningSupport    float64
	Accountability     float64
	BiasPressure       float64
	MetricSubstitution float64
	ReportingDistortion float64
	BehavioralBurden   float64
	ShortTermism       float64
	StatusInequality   float64
	MotivationCrowding float64
}

func InstitutionalIncentiveScoreRaw(x InstitutionalIncentiveCase) float64 {
	return 0.14*x.ValueAlignment +
		0.12*x.Fairness +
		0.13*x.InformationQuality +
		0.12*x.Legitimacy +
		0.12*x.LearningSupport +
		0.10*x.Accountability -
		0.10*x.BiasPressure -
		0.12*x.MetricSubstitution -
		0.09*x.ReportingDistortion -
		0.08*x.BehavioralBurden -
		0.07*x.ShortTermism -
		0.06*x.StatusInequality -
		0.05*x.MotivationCrowding
}

func main() {
	demo := InstitutionalIncentiveCase{82, 76, 80, 78, 75, 72, 25, 22, 20, 28, 24, 18, 21}
	fmt.Printf("Institutional incentive raw score: %.2f\n", InstitutionalIncentiveScoreRaw(demo))
}
