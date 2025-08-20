extends Camera3D

@export var playing_plane_distance = 32.0
@export var vertical_distance = 9.0
@export var look_offset_dist = 160.0
@export var target_reference: CharacterBody3D
var target_offset: Vector3 = Vector3.ZERO


func _ready() -> void:
	assert(target_reference)
	assert(target_reference.turn_threshold)
	# -- callback function from when helicopter turns
	target_reference.rotated.connect( func( x_dir: float):
		target_offset = look_offset_dist * Vector3.RIGHT * -1.0)

	assert($ShakeTimer)

func _physics_process(delta: float) -> void:
	global_position = (target_reference.global_position + 
					   Vector3.UP * vertical_distance   +
					   playing_plane_distance * Vector3.BACK)
	global_position = lerp(global_position, global_position + target_offset, delta)

	if !$ShakeTimer.is_stopped():
		global_position += shake_dir * MyUtils.some_random_custom_easing( MyUtils.normalized_timer( $ShakeTimer))

@export var shake_amplitude = 4.0
var shake_dir = Vector3.ZERO
func shake():
	shake_dir = MyUtils.rnd_vec3().normalized() * shake_amplitude
	$ShakeTimer.start()

#func shake() -> void:
	## -- TODO
	## -- This should match whatever visual indicator is used (e.g. pop effect currently)
	## -- pop effect currently dissipated around 0.25 seconds
	#
	## -- DECAY
	## -- hit it with an exponential?
	## -- map it to a sinusoid that is zero
	#
	#global_positio
