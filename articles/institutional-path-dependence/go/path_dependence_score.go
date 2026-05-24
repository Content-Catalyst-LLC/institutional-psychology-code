package main

import "fmt"

type PathDependenceCase struct {
	InitialConditions       float64
	BehavioralReinforcement float64
	FeedbackStrength        float64
	IncreasingReturns       float64
	CoordinationEffects     float64
	LearningEffects         float64
	Legitimacy              float64
	SwitchingCosts          float64
	Complementarity         float64
	DisruptionPressure      float64
	ReformCapacity          float64
}

func PathDependenceScoreRaw(x PathDependenceCase) float64 {
	return 0.08*x.InitialConditions +
		0.12*x.BehavioralReinforcement +
		0.12*x.FeedbackStrength +
		0.13*x.IncreasingReturns +
		0.11*x.CoordinationEffects +
		0.10*x.LearningEffects +
		0.12*x.Legitimacy +
		0.12*x.SwitchingCosts +
		0.10*x.Complementarity -
		0.12*x.DisruptionPressure -
		0.05*x.ReformCapacity
}

func main() {
	demo := PathDependenceCase{80, 75, 70, 82, 78, 74, 85, 88, 79, 35, 40}
	fmt.Printf("Institutional path dependence raw score: %.2f\n", PathDependenceScoreRaw(demo))
}
