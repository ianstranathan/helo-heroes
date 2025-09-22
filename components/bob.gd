extends RigidBody3D

class_name Bob

var anchor: Node3D
@onready var gravity = get_gravity()
var impulse_based: bool = false

@export var damping_strength: float = 2.0
@export var spring_constant: float = 50.0

func _physics_process(delta):
	if anchor == null:
		return
	else:
		apply_central_force(gravity * mass)
		
		var rel_pos = global_position - anchor.global_position
		var dist = rel_pos.length()

		if dist > anchor.tether_length:
			spring_force(rel_pos, dist)
			linear_velocity *= exp(-damping_strength * delta)
			
		# the bob, if told that it can fall or should shoot down
		# should do a spring calculation or constrain calculation until it's cross
		# the new threshold


func spring_force(rel_pos: Vector3, distance: float) -> void:
	var stretch = distance - anchor.tether_length
	# Apply a spring force if the bob is pulled beyond the tether's length
	var direction: Vector3 = rel_pos.normalized()
	var spring_force = -direction * stretch * spring_constant
	apply_central_force(spring_force)

# ----------------------------------------------------------
# -- Previous constraint solving conditions
#if impulse_based:
		#var to_bob: Vector3 = global_position - anchor.global_position
		#var distance: float = to_bob.length()
		#if is_zero_approx(distance):
			#return
#
		#var direction: Vector3 = to_bob.normalized()
#
		## radial velocity component
		#var radial_velocity: Vector3 = direction.dot(linear_velocity) * direction
#
		## cancel that velocity via impulse if stretch
		#var stretch = distance - anchor.tether_length
		#if stretch > 0.1:
			## remove radial component to enforce constraint
			#var impulse: Vector3 = -radial_velocity * mass
			#apply_impulse(impulse)
#
			## Optional: also apply position correction to limit stretch
			#var stiffness: float = 10.0
			#global_position -= direction * stretch * stiffness * delta
#
		## force of gravity
		#apply_central_force(gravity * mass)
