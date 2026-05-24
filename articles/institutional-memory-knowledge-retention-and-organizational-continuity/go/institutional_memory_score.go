package main

import "fmt"

type InstitutionalMemoryCase struct {
	DocumentedRetention    float64
	TacitTransfer          float64
	Accessibility          float64
	InterpretiveUse        float64
	Revisability           float64
	TechnicalContinuity    float64
	MetadataQuality        float64
	DistributedIntegration float64
	MemoryJustice          float64
	PathDependencePressure float64
	LossFragmentation      float64
	SelectiveNarration     float64
	TurnoverPressure       float64
	KeyPersonDependency    float64
}

func InstitutionalMemoryScoreRaw(x InstitutionalMemoryCase) float64 {
	return 0.12*x.DocumentedRetention +
		0.12*x.TacitTransfer +
		0.12*x.Accessibility +
		0.12*x.InterpretiveUse +
		0.11*x.Revisability +
		0.09*x.TechnicalContinuity +
		0.08*x.MetadataQuality +
		0.08*x.DistributedIntegration +
		0.08*x.MemoryJustice -
		0.11*x.PathDependencePressure -
		0.11*x.LossFragmentation -
		0.08*x.SelectiveNarration -
		0.07*x.TurnoverPressure -
		0.06*x.KeyPersonDependency
}

func main() {
	demo := InstitutionalMemoryCase{84, 78, 80, 76, 74, 79, 82, 72, 70, 24, 22, 20, 26, 28}
	fmt.Printf("Institutional memory raw score: %.2f\n", InstitutionalMemoryScoreRaw(demo))
}
