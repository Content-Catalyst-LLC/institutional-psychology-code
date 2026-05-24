package main

import "fmt"

type PublicGoodsCase struct {
	ContributionRate        float64
	Legitimacy              float64
	Trust                   float64
	Coordination            float64
	Monitoring              float64
	DistributionalAttention float64
	ScaleComplexity         float64
	CaptureRisk             float64
}

func PublicGoodsProvisionScoreRaw(x PublicGoodsCase) float64 {
	return 0.22*x.ContributionRate +
		0.13*x.Legitimacy +
		0.12*x.Trust +
		0.11*x.Coordination +
		0.10*x.Monitoring +
		0.08*x.DistributionalAttention -
		0.12*x.ScaleComplexity -
		0.08*x.CaptureRisk
}

func main() {
	demo := PublicGoodsCase{70, 78, 75, 72, 80, 74, 35, 25}
	fmt.Printf("Public goods provision raw score: %.2f\n", PublicGoodsProvisionScoreRaw(demo))
}
