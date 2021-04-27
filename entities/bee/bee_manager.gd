extends Node2D


onready var current_line2D := Line2D.new()
var curve2d : Curve2D
var last_position : Vector2
export var speed = 200
var started = false #stops the pathfollow setting off without a path
var drawing = false

func _ready():
	add_child(current_line2D)
#	last_position = Vector2.ZERO

func _process(delta):
	if $Path2D/BeeLocator.unit_offset < 1 && started:
		$Path2D/BeeLocator.offset += speed * delta
	
	last_position = $Path2D/BeeLocator.position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.position.distance_to($Path2D/BeeLocator.position) < 40.0:
		started = false
		curve2d = null
		drawing = true
		current_line2D.points = PoolVector2Array()
		current_line2D.show()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and drawing:
		# if this is the first point, add the current position and one just ahead
		if current_line2D.points.size() == 0:
			current_line2D.add_point(last_position)
			var rotation = $Path2D/BeeLocator.rotation
			current_line2D.add_point(last_position + 10.0 * Vector2(cos(rotation), sin(rotation)))
		
		var latest : Vector2 = current_line2D.points[current_line2D.points.size()-1]
		
		if event is InputEventMouseMotion and latest.distance_to(event.position) > 10.0:
			current_line2D.add_point(event.position)
	
	# when mouse is released, switch to the new curve
	if event is InputEventMouseButton and !event.pressed and drawing:
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
