package main

import "fmt"

type InstitutionCase struct {
	NormativeStability     float64
	LegitimacyStrength     float64
	IncentiveAlignment     float64
	InformationQuality     float64
	MemoryRetention        float64
	LearningCapacity       float64
	TrustReinforcement     float64
	RoleClarity            float64
	RepairCapacity         float64
	FragmentationPressure  float64
	OpacityPressure        float64
	AdministrativeBurden   float64
	HistoricalHarmPressure float64
}

func InstitutionalStrengthRaw(x InstitutionCase) float64 {
	return 0.13*x.NormativeStability +
		0.14*x.LegitimacyStrength +
		0.11*x.IncentiveAlignment +
		0.12*x.InformationQuality +
		0.11*x.MemoryRetention +
		0.13*x.LearningCapacity +
		0.12*x.TrustReinforcement +
		0.08*x.RoleClarity +
		0.08*x.RepairCapacity -
		0.12*x.FragmentationPressure -
		0.08*x.OpacityPressure -
		0.08*x.AdministrativeBurden -
		0.07*x.HistoricalHarmPressure
}

func main() {
	demo := InstitutionCase{82, 84, 78, 80, 76, 79, 81, 77, 74, 22, 20, 18, 16}
	fmt.Printf("Institutional strength raw score: %.2f\n", InstitutionalStrengthRaw(demo))
}
