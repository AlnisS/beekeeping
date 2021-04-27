extends Node2D


onready var current_line2D := Line2D.new()
var curve2d : Curve2D
var last_position : Vector2
export var speed = 200
var started = false #stops the pathfollow setting off without a path
var drawing = false

var flowers := []

func _ready():
	add_child(current_line2D)

func _process(delta):
	if $Path2D/BeeLocator.unit_offset < 1 && started:
		$Path2D/BeeLocator.offset += speed * delta
	
	last_position = $Path2D/BeeLocator.position
	
	if Input.is_action_just_pressed("draw") and get_local_mouse_position().distance_to($Path2D/BeeLocator.global_position) < 40.0:
		_start_drawing()
	if Input.is_action_pressed("draw") and drawing:
		_continue_drawing()
	if Input.is_action_just_released("draw") and drawing:
		_finish_drawing()
	
	

func _start_drawing():
	started = false
	curve2d = null
	drawing = true
	current_line2D.points = PoolVector2Array()
	current_line2D.show()

func _continue_drawing():
	if current_line2D.points.size() == 0:
		current_line2D.add_point(last_position)
		var rotation = $Path2D/BeeLocator.rotation
		current_line2D.add_point(last_position + 10.0 * Vector2(cos(rotation), sin(rotation)))
	
	var latest : Vector2 = current_line2D.points[current_line2D.points.size()-1]
	
	if latest.distance_to(get_local_mouse_position()) > 10.0:
		current_line2D.add_point(get_local_mouse_position())

func _finish_drawing():
	curve2d = Curve2D.new()
		
	for i in current_line2D.points.size():
		curve2d.add_point(current_line2D.points[i])
	
	$Path2D.curve = curve2d
	$Path2D/BeeLocator.offset = 0
	current_line2D.hide()
	drawing = false
	started = true

func _on_BeeCollisionArea_area_entered(area):
	print("ran into other bee")


func _on_BeeCollectionArea_area_entered(area):
	print("collection area entered")
	if !flowers.has(area):
		flowers.append(area)
		print("visited new flower")
	else:
		print("visited old flower")


func _on_BeeHiveReturnArea_area_entered(area):
	print("hive entered")
	if area.has_method("register_delivery"):
		area.register_delivery(flowers.size())
	flowers = []
