extends Node2D

enum State {IDLE, DRAWING, FOLLOWING, RETURNING, BACKUP}

var current_line2D := Line2D.new()
var curve2d : Curve2D
var last_position : Vector2
export var speed = 200

var state = State.IDLE
var time = 0.0

var in_flower = false
var grumpy = false

var flowers := []

func _ready():
	add_child(current_line2D)
	print("initialized")

func _process(delta):
	time += delta
	
	if $Path2D/BeeLocator.unit_offset < 1 && state == State.FOLLOWING:
		$Path2D/BeeLocator.offset += speed * delta
	
	if $Path2D/BeeLocator.unit_offset > 0 && state == State.BACKUP:
		$Path2D/BeeLocator.offset -= speed * delta
	
	if state == State.RETURNING:
		$Path2D/BeeLocator/AnimatedSprite.scale -= Vector2(delta, delta) * .5
		var rotation = $Path2D/BeeLocator.rotation
		$Path2D/BeeLocator.translate(Vector2(cos(rotation), sin(rotation)) * delta * speed)
		if $Path2D/BeeLocator/AnimatedSprite.scale.x < 0:
			queue_free() 
	
	last_position = $Path2D/BeeLocator.position
	
	if (Input.is_action_just_pressed("draw")
			and get_global_mouse_position().distance_to($Path2D/BeeLocator.global_position) < 40.0
			and (state == State.IDLE or state == State.FOLLOWING)
			and InputLock.free):
		InputLock.free = false
		_start_drawing()
	if Input.is_action_pressed("draw") and state == State.DRAWING:
		_continue_drawing()
	if Input.is_action_just_released("draw") and state == State.DRAWING:
		_finish_drawing()
		InputLock.free = true
	
	if state == State.FOLLOWING and $Path2D/BeeLocator.unit_offset == 1.0:
		state = State.IDLE
	
	if (state == State.IDLE or state == State.DRAWING) and in_flower:
		$Path2D/BeeLocator/AnimatedSprite.playing = false
		$Path2D/BeeLocator/AnimatedSprite.frame = 0
	else:
		$Path2D/BeeLocator/AnimatedSprite.playing = true
	
	if $Path2D/BeeLocator/AnimatedSprite.visible:
		enable_monitoring()
	
	if grumpy:
		$Path2D/BeeLocator/Ball.show()
		flowers = []

func disable_monitoring():
	$Path2D/BeeLocator/BeeCollisionArea.monitoring = false
	$Path2D/BeeLocator/BeeCollisionArea.monitorable = false

func enable_monitoring():
	$Path2D/BeeLocator/BeeCollisionArea.monitoring = true
	$Path2D/BeeLocator/BeeCollisionArea.monitorable = true

func _start_drawing():
	curve2d = null
	state = State.DRAWING
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
	state = State.FOLLOWING
	$Path2D/BeeLocator/AnimatedSprite.show()

func _on_BeeCollisionArea_area_entered(area):
	print("ran into other bee")
	if state == State.FOLLOWING:
		state = State.BACKUP
	$BackupTimer.start()
	grumpy = true
	flowers = []


func _on_BeeCollectionArea_area_entered(area):
	print("collection area entered")
	in_flower = true
	if !flowers.has(area):
		flowers.append(area)
		print("visited new flower")
	else:
		print("visited old flower")


func _on_BeeCollectionArea_area_exited(area):
	in_flower = false


func _on_BeeHiveReturnArea_area_entered(area):
	print("hive entered")
	
	# if the bee was just added, ignore the first extra signal
	if time < 0.1:
		return
	
	if area.has_method("register_delivery"):
		area.register_delivery(flowers.size())
		flowers = []
		state = State.RETURNING


func _on_BackupTimer_timeout():
	state = State.IDLE
