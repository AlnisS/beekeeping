extends Node

var free = true

var music = true setget set_music
var sfx = true setget set_sfx

func set_music(value: bool):
	music = value
	AudioServer.set_bus_mute(1, not value)

func set_sfx(value: bool):
	sfx = value
	AudioServer.set_bus_mute(2, not value)

var high_score = 0.0
