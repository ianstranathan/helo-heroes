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
@export var max_speed_x: float = 40.0
@export var accl_x: float      = 0.50
@export var max_speed_y: float = 20.0
@export var accl_y: float      = 12.5
@export var tilt_angle         = PI / 6.0
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
	var l_stick_input : Vector2 = (Input.get_vector("left", "right", "down", "up")
									if has_fuel
									else Vector2.ZERO)
	var r_stick_input : float   = Input.get_axis("lower-tether", "raise-tether")
	
	if abs(l_stick_input.x) > turn_threshold:
		last_left_stick_x = l_stick_input.x
	
	var transform_basis_quaternion = Quaternion(transform.basis)
	var tilt_quat: Quaternion
	var rot_quat: Quaternion
	
	# -- tilt angle is a function of speed
	tilt_quat = Quaternion(basis_reference.rotated(Vector3.FORWARD, sign(l_stick_input.x ) * tilt_fn()))
	
	if last_left_stick_x:
		var angle = 0.0 if last_left_stick_x > 0.0 else PI
		rot_quat = Quaternion(basis_reference.rotated(Vector3.UP, angle))
		emit_signal("rotated", -1.0 if angle == PI else 1.0) # -- for camera

	var ret_quat: Quaternion = transform_basis_quaternion.slerp(rot_quat * tilt_quat, delta)
	#var ret_quat: Quaternion = transform_basis_quaternion.slerp(rot_quat, delta)
	transform.basis = Basis(ret_quat).orthonormalized()
	
	# -- vector sum of movement
	var target_vel: Vector2 = Vector2(max_speed_x * l_stick_input.x,
									  max_speed_y * l_stick_input.y)
	
	# -- how much acceleration contributes to velocity per frame
	# -- player has to slide / drift to stop
	# -- => accl if abs relative velocity.x is negative
	velocity.x = move_toward(velocity.x, target_vel.x, drifting_vel_fn(target_vel.x, velocity.x))
	if l_stick_input.y != 0:
		velocity.y = move_toward(velocity.y, target_vel.y, accl_y)
	
	velocity.y += delta * get_gravity().y
	# -- collision response here
	move_and_slide()
	
	# -- Tether input
	tether_move_fn(r_stick_input * tether_change_rate * delta)

func tilt_fn() -> float:
	# This must consider the wind velocity. If the x-dir and the wind-dir
	# agree, it's max speed + wind velocity, otherwise it's their difference
	var _max = (max_speed_x + wind_velocity.x 
				if max_speed_x * wind_velocity.x > 0.0 
				else max_speed_x - wind_velocity.x)
	var t = velocity.x / _max
	return t * tilt_angle # this is just (1. - x)a + xb


func drifting_vel_fn(target_vel_x: float, last_vel_x: float) -> float:
	return accl_x if abs(target_vel_x) - abs(last_vel_x) > 0 else accl_x / 5.0 

func tether_move_fn(tether_change):
	tether_length += tether_change
	tether_length =  clamp(tether_length, 0., MAX_TETHER_LENGTH)
	#emit_signal("tether_length_changed", tether_length)


func should_turn_around(input_x: float) -> bool:
	var tmp_vec3 = Vector3(input_x, 0., 0.)
	return tmp_vec3.dot(global_transform.basis.x) <= 0 if tmp_vec3 != Vector3.ZERO else false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drop-item"):
		emit_signal("dropped_item")
		
func refuel( amount: float):
	$Fuel.refuel( amount )
