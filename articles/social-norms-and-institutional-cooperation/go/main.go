package main

import "fmt"

func institutionalEffectiveness(legitimacy, norms, trust, cognition, infoFlow, memory, learning, fragmentation float64) float64 {
	return 0.14*legitimacy + 0.14*norms + 0.13*trust + 0.12*cognition + 0.12*infoFlow + 0.12*memory + 0.13*learning - 0.16*fragmentation
}

func main() {
	score := institutionalEffectiveness(0.72, 0.68, 0.64, 0.70, 0.66, 0.58, 0.62, 0.30)
	fmt.Printf("Institutional effectiveness score: %.3f\n", score)
}
