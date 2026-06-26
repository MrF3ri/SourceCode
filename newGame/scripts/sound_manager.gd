extends Node

@onready var music_player = $MusicPlayer
@onready var effect_player = $EffectPlayer

var music_on = true

func _ready():
	play_music()

func play_music():
	if music_on and not music_player.playing:
		music_player.play()

func play_effect(stream):
	if stream:
		effect_player.stream = stream
		effect_player.play()
