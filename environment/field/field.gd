extends Node2D

var factory_string = (
"""Oh no! Your hive ran out of honey!

You survived for %s and managed a peak of %d worker bees.

High score: %s%s"""
)

func _on_Hive_gameover(time: float, bee_total: int):
	var high_score_info = ""
	
	if time > InputLock.high_score:
		InputLock.high_score = time
		high_score_info = "\n\nNew high score!"
	
	$Endgame/MarginContainer/Label.text = (
		factory_string % [format_time(time), bee_total, format_time(InputLock.high_score), high_score_info]
	)
	
	$Endgame.popup_centered()
	


func format_time(time: float):
	return "%02d:%06.3f" % [time / 60.0, fmod(time, 60.0)]


func _on_Endgame_popup_hide():
	get_tree().change_scene("res://main_menu.tscn")


