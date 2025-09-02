extends Area3D

@export var fuel_amount = 100.0

func _ready() -> void:
	body_entered.connect( func(body):
		if body is Helicopter:
			body.refuel( fuel_amount ))
