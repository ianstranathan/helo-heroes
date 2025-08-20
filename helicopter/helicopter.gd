extends CharacterBody3D

# ==================================================
# -- signals
#signal tether_length_changed( _tether_length )
signal dropped_item
signal rotated( x_dir: float)
# ==================================================
# -- movement
@export_group("Movement")
@export var max_speed_x: float = 40.0

# ==================================================
# -- tether
@export var tether_change_coefficient: float
@export var MAX_TETHER_LENGTH = 100.0
@export var initial_tether_length = 20.0
@onready var tether_length: float = initial_tether_length

# ==================================================
# -- environmental
var wind_velocity: Vector3 = Vector3.ZERO

# ==================================================
# -- turning
@onready var basis_reference : Basis = transform.basis
var is_turning: bool = false
var last_left_stick_x: float
@export var turn_threshold: float = 0.8


func _physics_process(delta: float) -> void:
	var l_stick := Input.get_vector("l-left", "l-right", "l-down", "l-up")
	if abs(l_stick.x) > turn_threshold:
		last_left_stick_x = l_stick.x
	var r_stick := Input.get_axis("r-up", "r-down")
	var transform_basis_quaternion = Quaternion(transform.basis)
	var tilt_quat: Quaternion
	var rot_quat: Quaternion
	
	tilt_quat = Quaternion(basis_reference.rotated(Vector3.FORWARD, sign(r_stick) * PI / 8))
	
	if last_left_stick_x:
		var angle = 0.0 if last_left_stick_x > 0.0 else PI
		rot_quat = Quaternion(basis_reference.rotated(Vector3.UP, angle))
		emit_signal("rotated", -1.0 if angle == PI else 1.0) # -- for camera

	var ret_quat: Quaternion = transform_basis_quaternion.slerp(rot_quat * tilt_quat, delta)
	transform.basis = Basis(ret_quat).orthonormalized()

	# -- velocity proportional to tilt
	# r_stick input in on [-1, 1] -> * 1/2 : [-0.5, 0.5] -> + 0.5 -> [0, 1]
	var tilt_coeff = (0.5 * r_stick) + 0.5
	var x_movement_coeff = l_stick.x * (tilt_coeff + 0.3)

	# -- 
	var target_vel = Vector3.ZERO
	target_vel.x = x_movement_coeff * max_speed_x
	target_vel.y += get_gravity().y
	target_vel += wind_velocity
	# -- how to make velocity changes smooth?
	# -- Option 1. spread force out over time OR
	# -- Option 2. interpolate between velocities
	if Input.is_action_just_pressed("a-btn") and $FlappyTimer.is_stopped():
		$FlappyTimer.start()
		target_vel.y += 1000.0
	
	velocity = Vector3(lerp(velocity.x, target_vel.x, 3. * delta),
					   lerp(velocity.y, target_vel.y, delta),
					   0.)
	
	move_and_slide()

	# -- Tether input
	if Input.is_action_pressed("R2"):
		tether_move_fn(tether_change_coefficient * delta)
	elif Input.is_action_pressed("L2"):
		tether_move_fn(-tether_change_coefficient * delta)


func tether_move_fn(tether_change):
	tether_length += tether_change
	tether_length =  clamp(tether_length, 0., MAX_TETHER_LENGTH)
	#emit_signal("tether_length_changed", tether_length)


func should_turn_around(input_x: float) -> bool:
	var tmp_vec3 = Vector3(input_x, 0., 0.)
	return tmp_vec3.dot(global_transform.basis.x) <= 0 if tmp_vec3 != Vector3.ZERO else false


# -- the middle point between the pickup_bob and helicopter
# -- for camera
#func camera_target_pos():
	#return global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("x-btn"):
		emit_signal("dropped_item")
