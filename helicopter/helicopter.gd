extends CharacterBody3D

class_name Helicopter
# ==================================================
# -- signals
#signal tether_length_changed( _tether_length )
signal dropped_item
signal rotated( x_dir: float)
signal fuel_changed( fuel_ratio: float)
signal fuel_empty

# ==================================================
# -- movement
@export_group("Movement")
@export var max_speed_x: float = 220.0
@export var max_speed_y: float = 25.0
@export var tilt_angle         = PI / 6.0
@export var drag_coefficient   = 0.05
# ==================================================
# -- tether
@export var tether_change_rate: float
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

var has_fuel = true
func _ready() -> void:
	$Fuel.fuel_changed.connect( func(fuel_ratio: float):
		emit_signal("fuel_changed", fuel_ratio))
	$Fuel.fuel_empty.connect( func():
		has_fuel = false
		$SmokeParticle1.emitting = true
		# TODO:
		emit_signal("fuel_empty"))
	$Fuel.refueled.connect( func():
		has_fuel = true)


func _physics_process(delta: float) -> void:
	# -- TODO
	# -- Per Keith: the point of the game is PRECISE STICK CONTROLS
	# --   l-stick: controls left, right, up, down motion
	# --   r-stick: controls tether
	# --   tilt will be an interpolation of max speed ( does the player think
	# --   he's going as fast as possible
	# --   This must consider the wind velocity. If the x-dir and the wind-dir
	# --   agree, it's max speed + wind velocity, otherwise it's their difference
	#var l_stick_input : Vector2 = (Input.get_vector("left", "right", "down", "up")
									#if has_fuel
									#else Vector2.ZERO)
	var l_stick_input : float = (Input.get_axis("left", "right")
									if has_fuel
									else 0.0)
	var r_stick_input : float = Input.get_axis("down", "up")
	
	if abs(l_stick_input) > turn_threshold:
		last_left_stick_x = l_stick_input
	
	var transform_basis_quaternion = Quaternion(transform.basis)
	var tilt_quat: Quaternion
	var rot_quat:  Quaternion
	
	# -- tilt angle is a function of speed
	tilt_quat = Quaternion(basis_reference.rotated(Vector3.FORWARD, tilt_interpolation(l_stick_input)))
	
	if last_left_stick_x:
		var angle = 0.0 if last_left_stick_x > 0.0 else PI
		rot_quat = Quaternion(basis_reference.rotated(Vector3.UP, angle))
		emit_signal("rotated", -1.0 if angle == PI else 1.0) # -- for camera

	var ret_quat: Quaternion = transform_basis_quaternion.slerp(rot_quat * tilt_quat, delta)
	#var ret_quat: Quaternion = transform_basis_quaternion.slerp(rot_quat, delta)
	transform.basis = Basis(ret_quat).orthonormalized()
	
	# --
	velocity_resolution(delta, l_stick_input, r_stick_input)
	# -- Tether input
	#tether_move_fn(r_stick_input * tether_change_rate * delta)
	if !is_zero_approx(global_position.z):
		global_position.z = lerp(global_position.z, 0., delta)
	
func rotation_resolution() -> void:
	# TODO
	# tidy up rotation stuff and put it here
	pass

func velocity_resolution(delta: float, l_stick_input_x: float, r_stick_input_y: float) -> void:
	# the speed has to approach a limit
	velocity += delta * (Vector3(max_speed_x * l_stick_input_x + wind_velocity.x,
								max_speed_y * r_stick_input_y + get_gravity().y,
								0.0) + 
						-velocity.normalized() * drag_coefficient * velocity.length_squared())
	move_and_slide()
	

func tilt_interpolation(stick_input: float) -> float:
	var t = abs(velocity.x / (max_speed_x + wind_velocity.x))
	t = clamp(2. * t, 0., 1.) if stick_input != 0.0 else 0.0
	return t * tilt_angle # this is just (1. - x)a + xb


func tether_move_fn(tether_change):
	tether_length += tether_change
	tether_length =  clamp(tether_length, 0., MAX_TETHER_LENGTH)


func should_turn_around(input_x: float) -> bool:
	var tmp_vec3 = Vector3(input_x, 0., 0.)
	return tmp_vec3.dot(global_transform.basis.x) <= 0 if tmp_vec3 != Vector3.ZERO else false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drop-item"):
		emit_signal("dropped_item")
		
func refuel( amount: float):
	$Fuel.refuel( amount )
