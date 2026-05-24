package main

import "fmt"

type InstitutionalLearningCase struct {
	FeedbackQuality      float64
	MemoryRetention     float64
	CommunicationOpenness float64
	InterpretiveQuality float64
	DecisionRevisability float64
	PsychologicalSafety float64
	AccountabilityReach float64
	DisconfirmingEvidence float64
	InstitutionalInertia float64
	SignalDistortion    float64
	MemoryDecay         float64
	DefensiveRoutines   float64
	PowerProtection     float64
	FeedbackDelay       float64
}

func InstitutionalLearningScoreRaw(x InstitutionalLearningCase) float64 {
	return 0.13*x.FeedbackQuality +
		0.12*x.MemoryRetention +
		0.12*x.CommunicationOpenness +
		0.12*x.InterpretiveQuality +
		0.12*x.DecisionRevisability +
		0.12*x.PsychologicalSafety +
		0.10*x.AccountabilityReach +
		0.06*x.DisconfirmingEvidence -
		0.12*x.InstitutionalInertia -
		0.10*x.SignalDistortion -
		0.08*x.MemoryDecay -
		0.08*x.DefensiveRoutines -
		0.08*x.PowerProtection -
		0.07*x.FeedbackDelay
}

func main() {
	demo := InstitutionalLearningCase{84, 78, 76, 80, 74, 77, 72, 68, 25, 22, 18, 20, 24, 21}
	fmt.Printf("Institutional learning raw score: %.2f\n", InstitutionalLearningScoreRaw(demo))
}
