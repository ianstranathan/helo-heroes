extends Node

@export var MAX_FUEL_SECONDS: float = 15.0
@onready var fuel_time: Timer = $Timer

signal fuel_changed( fuel_ratio )
signal fuel_empty()
signal refueled

func _ready() -> void:
	fuel_time.wait_time = MAX_FUEL_SECONDS
	fuel_time.timeout.connect( func():
		emit_signal("fuel_empty"))
	assert( fuel_time )

func refuel(amount: float):
	# add to time left, capped to timer bounds
	fuel_time.start( clamp(fuel_time.time_left + amount, 0., fuel_time.wait_time ))
	emit_signal("refueled")
	
@onready var time_fn: Callable = MyUtils.normalized_timer
func _physics_process(delta: float) -> void:
	if !fuel_time.is_stopped():
		emit_signal("fuel_changed", fuel_ratio_fn())

func fuel_ratio_fn() -> float:
	return fuel_time.time_left / MAX_FUEL_SECONDS
