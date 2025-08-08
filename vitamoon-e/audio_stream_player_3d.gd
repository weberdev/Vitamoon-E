extends AudioStreamPlayer3D

func _ready():
	var looped_stream = load("res://sounds/sun_and_moon.wav") as AudioStreamWAV
	if looped_stream:
		looped_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream = looped_stream
		play()
	else:
		print("Failed to load WAV stream")
