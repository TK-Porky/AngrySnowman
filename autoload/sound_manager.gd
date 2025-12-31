extends AudioStreamPlayer

var transition_duration := 1
var transition_type := 1
var music_volume = -5

var tracks : Dictionary = \
	{
		"World1" : "sounds/basic_platformer_music_-_world_1.wav",
		"Main" : "sounds/basic_platformer_music_-_title.wav"
	}

var current_track: String = ""

func _init():
	volume_db = music_volume

func play_track(newSong: String):
	if playing and current_track == newSong or stream_paused:
		return

	current_track = newSong

	if playing:
		fade_out_to(newSong)
	else:
		fade_in(newSong)
		play()

func fade_out():
	# tween music volume down to -80 (muted)
	var tween_out = create_tween()
	tween_out.tween_property(self, "volume_db", -80, transition_duration)
	Tween.interpolate_value(music_volume, 0, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)

func fade_out_to(newSong):
	if playing:
		# tween music volume down to -80 (muted)
		var tween_out = create_tween()
		tween_out.tween_property(self, "volume_db", -80, transition_duration)
		Tween.interpolate_value(music_volume, 0, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween_out.tween_callback(Callable(self, "done_fade_out").bind(newSong))
	else:
		done_fade_out(newSong)

func fade_in(newSong):
	stream = load(str("res://", tracks.get(newSong)))
	print("Playing : ", str("res://", tracks.get(newSong)), " (fade_in)")
	# tween music volume up to music_volume (normal/defined)
	var tween_in = create_tween()
	tween_in.tween_property(self, "volume_db", music_volume, transition_duration)
	Tween.interpolate_value(-80, 0, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)

func pause_music():
	stream_paused = !stream_paused

func mute():
	volume_db = -80

func unmute():
	volume_db = music_volume

func done_fade_out(newSong : String):
	stop()
	stream = load(str("res://", tracks.get(newSong)))
	print("Playing : ", str("res://", tracks.get(newSong)), " (callback fade_out_to)")
	# tween music volume up to music_volume (normal/defined)
	var tween_in = create_tween()
	tween_in.tween_property(self, "volume_db", music_volume, transition_duration)
	Tween.interpolate_value(-80, 0.5, 0, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	unmute()
	play()
