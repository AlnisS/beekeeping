extends Area2D

signal hive_update

var honey := 10.0
var pollen := 0.0
var bee_count := 2
var bee_total := 2

var time = 0.0
var last_time = 0.0

const BEE = preload("res://entities/bee/bee_manager.tscn")

var queue_next_loop_draw = false

func _process(delta):
	
	honey -= delta * 0.25 * bee_total
	time += delta
	
	if honey > 10.0:
		honey = 10.0
	
	if pollen >= 10:
		pollen -= 10
		bee_count += 1
		bee_total += 1
		# todo: bee tada
	
#	if time - last_time > 1.0:
#		print("honey: ", honey)
#		print("pollen: ", pollen)
#		last_time = time
	
	if queue_next_loop_draw and InputLock.free:
		InputLock.free = false
		print("adding bee")
		var bee = BEE.instance()
		bee.disable_monitoring()
		bee.get_node("Path2D/BeeLocator/AnimatedSprite").hide()
		bee._start_drawing()
		bee.current_line2D.add_point(get_local_mouse_position())
		add_child(bee)
		bee_count -= 1
	
	queue_next_loop_draw = false
	
	
	if (Input.is_action_just_pressed("draw")):
		print(get_global_mouse_position())
	
	if (Input.is_action_just_pressed("draw")
			and get_global_mouse_position().distance_to(global_position) < 80.0
			and bee_count > 0
			and InputLock.free):
		queue_next_loop_draw = true
	
	
	
	emit_signal("hive_update", honey, pollen, bee_count, bee_total)
	

func register_delivery(flowers: int) -> void:
	honey += flowers
	pollen += flowers
	bee_count += 1
	print("honey: ", honey)
	print("pollen: ", pollen)
	print("bee_count: ", bee_count)
	print("bee_total: ", bee_total)	
	
	


