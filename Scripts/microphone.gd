extends Node2D

var MicrophoneInputPeakVolume = 0
var samples = []
const SMOOTHNESS = 5
const SCOPE = 7.5
const LOWER_BOUND = -340

func _draw():
	draw_rect(Rect2(1060, 480, 50, -350), Color(0,0,0,1), false)
	
	draw_rect(Rect2(1060, 480, 50, -350+(abs(MicrophoneInputPeakVolume))), Color(1, 1, 1, 1), true)


func _process(delta):
	MicrophoneInputPeakVolume = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0) * SCOPE
	if MicrophoneInputPeakVolume < LOWER_BOUND:
		MicrophoneInputPeakVolume = LOWER_BOUND
	var linear_sample = MicrophoneInputPeakVolume
	samples.push_front(linear_sample)
	
	if samples.size() > SMOOTHNESS:
		samples.pop_back()
	
	MicrophoneInputPeakVolume = average_sample_size()
	queue_redraw()


func average_sample_size():
	var avg = 0
	
	for i in range(samples.size()):
		avg += samples[i]
	avg /= samples.size()
	return avg
