extends RigidBody3D

class_name Bob

var anchor: Node3D
@onready var gravity = get_gravity()
var impulse_based: bool = false

func _physics_process(delta):
	if anchor == null:
		return

	if impulse_based:
		var to_bob: Vector3 = global_position - anchor.global_position
		var distance: float = to_bob.length()
		if is_zero_approx(distance):
			return

		var direction: Vector3 = to_bob.normalized()

		# radial velocity component
		var radial_velocity: Vector3 = direction.dot(linear_velocity) * direction

		# cancel that velocity via impulse if stretch
		var stretch = distance - anchor.tether_length
		if stretch > 0.1:
			# remove radial component to enforce constraint
			var impulse: Vector3 = -radial_velocity * mass
			apply_impulse(impulse)

			# Optional: also apply position correction to limit stretch
			var stiffness: float = 10.0
			global_position -= direction * stretch * stiffness * delta

		# force of gravity
		apply_central_force(gravity * mass)
	
	else:
		var to_bob = global_position - anchor.global_position
		var distance = to_bob.length()
		if is_zero_approx(distance):
			return
			
		# Enforce constraint: move bob back to correct distance
		var direction: Vector3  = to_bob.normalized()
		var correction: Vector3 = direction * (distance - anchor.tether_length)

		# Velocity's projection along rope
		var radial_velocity = direction.dot(linear_velocity) * direction
		var tangential_velocity = linear_velocity - radial_velocity
		
		# damping
		var damping_strength = 0.5
		tangential_velocity *= exp(-damping_strength * delta)
		
		# Correct velocity to remove radial component (enforce rigid rope)
		linear_velocity = tangential_velocity

		# Apply position correction (to fix drift)
		global_position -= correction

		# Optionally add gravity manually, since we are overriding velocity
		linear_velocity +=  0.5 * gravity * delta * delta
	
