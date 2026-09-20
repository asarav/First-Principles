class_name FeedbackAudio
extends Node

const MIX_RATE := 44100.0

var player: AudioStreamPlayer
var playback: AudioStreamGeneratorPlayback


func _ready() -> void:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = MIX_RATE
	stream.buffer_length = 0.5
	player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()
	playback = player.get_stream_playback() as AudioStreamGeneratorPlayback


func play_feedback(kind: String = "click") -> void:
	if playback == null:
		return
	var frequency := 440.0
	var duration := 0.06
	var volume := 0.10
	match kind:
		"success":
			frequency = 660.0
			duration = 0.16
			volume = 0.16
		"error":
			frequency = 170.0
			duration = 0.13
			volume = 0.14
		"toggle":
			frequency = 520.0
			duration = 0.045
			volume = 0.08
	var frame_count := int(MIX_RATE * duration)
	for frame in frame_count:
		var envelope := 1.0 - float(frame) / float(frame_count)
		var sample := sin(TAU * frequency * float(frame) / MIX_RATE) * volume * envelope
		playback.push_frame(Vector2(sample, sample))