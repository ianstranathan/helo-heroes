extends Area3D

var balanced_result: bool = true

signal balancing_finished( res: bool )

func _ready() -> void:
	toggle_on( false )
	body_shape_exited.connect(  on_body_shape_exited )
	body_shape_entered.connect( on_body_shape_entered )
	$Timer.timeout.connect( on_timeout )

# -- the collision shape and mesh shape agree, the rest is just scaling
func set_balancing_bounds(square_len: float):
	if $CollisionShape3D.shape is CylinderShape3D:
		$CollisionShape3D.shape.height = square_len / 2.0
		$CollisionShape3D.shape.radius = square_len / 2.0
	elif $CollisionShape3D.shape is BoxShape3D:
		$CollisionShape3D.shape.size = Vector3(square_len, square_len, square_len)
	# -- quad visuals
	var _quad_size = Vector2(square_len, square_len)
	$mesh_containers/MeshInstance3D.mesh.size = _quad_size
	$mesh_containers/TimerVisual.mesh.size = 1.1 * _quad_size


func start_balancing(pos: Vector3, time_from_grabbale: float):
	#print($CollisionShape3D.shape.size)
	#print($mesh_containers/MeshInstance3D.mesh.size)
	toggle_on( true )
	global_position = pos
	balanced_result = true
	$Timer.wait_time = time_from_grabbale
	$Timer.start()


func on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int):
	if body is Helicopter:
		balanced_result = true
		$mesh_containers/MeshInstance3D.material_override.set_shader_parameter("within", 1.0)
		pop_size()

func on_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int):
	if body is Helicopter:
		balanced_result = false
		$mesh_containers/MeshInstance3D.material_override.set_shader_parameter("within", 0.0)

func on_timeout():
	emit_signal("balancing_finished", balanced_result)
	toggle_on( false)
	balanced_result = false


func toggle_on(b: bool) -> void:
	visible = b
	$CollisionShape3D.set_deferred("disabled", !b)


func pop_size():
	# -- just some juice
	var tween = get_tree().create_tween()
	tween.tween_property($mesh_containers, "scale", 1.2 * scale, 0.25).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback( func():
		var tween_back = get_tree().create_tween()
		tween_back.tween_property($mesh_containers, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_SINE))


func _timer_time() -> float:
	return 1.0 - ($Timer.time_left /  $Timer.wait_time)


func _physics_process(delta: float) -> void:
	if !$Timer.is_stopped():
		$mesh_containers/TimerVisual.material_override.set_shader_parameter("progress", _timer_time())


func snap_out():
	$Timer.stop()
	toggle_on( false )
