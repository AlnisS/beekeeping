extends Area2D

var honey = 10.0
var pollen = 0.0

var time = 0.0
var last_time = 0.0

const BEE = preload("res://entities/bee/bee_manager.tscn")

func _process(delta):
	honey -= delta * 0.5
	time += delta
	if time - last_time > 1.0:
		print("honey: ", honey)
		print("pollen: ", pollen)
		last_time = time
	
	if (Input.is_action_just_pressed("draw")
			and get_local_mouse_position().distance_to(global_position) < 80.0):
		var bee = BEE.instance()
		bee.get_node("Path2D/BeeLocator/AnimatedSprite").hide()
		bee._start_drawing()
		bee.current_line2D.add_point(get_local_mouse_position())
		add_child(bee)

func register_delivery(flowers: int) -> void:
	honey += flowers
	pollen += flowers
	print("honey: ", honey)
	print("pollen: ", pollen)


