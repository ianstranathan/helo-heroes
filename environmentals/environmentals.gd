extends Node


@export var wind: bool
@export var wind_speed: float
@export var wind_direction: Vector2
@onready var wind_velocity = wind_speed * Vector3(wind_direction.x, wind_direction.y, 0.)
# TODO
# The particle effect for the diagenic wind needs to agree via script with
# the chosen, exported wind dir
