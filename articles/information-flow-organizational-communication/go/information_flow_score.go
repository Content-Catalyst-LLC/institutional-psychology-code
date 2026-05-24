package main

import "fmt"

type InformationFlowCase struct {
	SignalQuality          float64
	CommunicationQuality   float64
	InterpretiveIntegration float64
	FeedbackUsability      float64
	MemoryRetention        float64
	Openness               float64
	EscalationAccess       float64
	Trust                  float64
	CommunityVoice         float64
	DigitalTransparency    float64
	DistortionLoss         float64
	Overload               float64
	Siloing                float64
	SuppressionPressure    float64
	MetricTunnelVision     float64
}

func InformationFlowScoreRaw(x InformationFlowCase) float64 {
	return 0.12*x.SignalQuality +
		0.12*x.CommunicationQuality +
		0.12*x.InterpretiveIntegration +
		0.11*x.FeedbackUsability +
		0.10*x.MemoryRetention +
		0.11*x.Openness +
		0.09*x.EscalationAccess +
		0.08*x.Trust +
		0.07*x.CommunityVoice +
		0.07*x.DigitalTransparency -
		0.12*x.DistortionLoss -
		0.09*x.Overload -
		0.08*x.Siloing -
		0.08*x.SuppressionPressure -
		0.07*x.MetricTunnelVision
}

func main() {
	demo := InformationFlowCase{84, 78, 80, 76, 74, 77, 72, 75, 70, 73, 24, 28, 22, 20, 26}
	fmt.Printf("Information flow raw score: %.2f\n", InformationFlowScoreRaw(demo))
}
