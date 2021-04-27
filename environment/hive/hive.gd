extends Area2D

var honey = 10.0
var pollen = 0.0

var time = 0.0
var last_time = 0.0

func _process(delta):
	honey -= delta * 0.5
	time += delta
	if time - last_time > 1.0:
		print("honey: ", honey)
		print("pollen: ", pollen)
		last_time = time

func register_delivery(flowers: int) -> void:
	honey += flowers
	pollen += flowers
	print("honey: ", honey)
	print("pollen: ", pollen)
