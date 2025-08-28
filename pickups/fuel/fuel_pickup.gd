extends Node3D

@export var fuel_amount = 5.0
@export var y_osccilation_amplitude = 4.0

func _ready() -> void:
	$Area3D.body_entered.connect( func(body):
		if body is Helicopter:
			body.refuel( fuel_amount )
			queue_free())

var t: float = 0
#func _physics_process(delta: float) -> void:
	#t += delta
	#global_position.y += y_osccilation_amplitude * sin(t)
