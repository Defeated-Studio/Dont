extends Control

var MicrophoneInputPeakVolume = 0
const SCOPE = 7.5
const LOWER_BOUND = -340
const UPPER_BOUND = 0
var sensitity = 1.8
var smoothed_size_y = 10.0
var smoothed_position_y = 205.0
var smoothed_color = Color(1, 1, 1, 0.8)
var interpolation_speed = 5000

@onready var volume = $outline/volume

func _process(delta):
	MicrophoneInputPeakVolume = AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0) * SCOPE
	
	var microphone_volume = abs(MicrophoneInputPeakVolume + 340) / 340
	if MicrophoneInputPeakVolume < LOWER_BOUND:
		MicrophoneInputPeakVolume = LOWER_BOUND
	if MicrophoneInputPeakVolume > UPPER_BOUND:
		MicrophoneInputPeakVolume = UPPER_BOUND

	var target_size_y = 10 + microphone_volume * (200 * sensitity)
	var target_position_y = 205 - microphone_volume * (200 * sensitity)
	
	if target_size_y >= 211:
		target_size_y = 210.0
	if target_position_y <= 4:
		target_position_y = 5.0
		
	var target_color = Color(1, 1, 1, 0.8)
	if target_size_y > 164 and target_position_y < 50:
		target_color = Color(1, 0, 0, 0.8)  
	elif target_size_y > 83 and target_position_y < 130:
		target_color = Color(1, 1, 0, 0.8) 
	
	var factor = 1.0 - pow(1.0 - 0.003, delta * interpolation_speed)

	smoothed_size_y = lerp(smoothed_size_y, target_size_y, factor)
	smoothed_position_y = lerp(smoothed_position_y, target_position_y, factor)

	smoothed_color.r = lerp(smoothed_color.r, target_color.r, factor)
	smoothed_color.g = lerp(smoothed_color.g, target_color.g, factor)
	smoothed_color.b = lerp(smoothed_color.b, target_color.b, factor)
	smoothed_color.a = lerp(smoothed_color.a, target_color.a, factor)

	volume.size.y = smoothed_size_y
	volume.position.y = smoothed_position_y
	volume.color = smoothed_color
