extends Node

@onready var rng = RandomNumberGenerator.new()
var wind_gust_visual: PackedScene = preload("res://vfx/wind_gust_visual.tscn")

func make_wind():
	# -- hardcoding area extens
	# -- should probably use a data sdtructure to just queue these around instead
	# -- of the data churn, w/e
	var wind_instance = wind_gust_visual.instantiate()
	add_child(wind_instance)
	wind_instance.global_position.x = rng.randf_range(-1.0, 1.0) * 10.
	wind_instance.global_position.y = rng.randf_range(0.2, 1.) * 5.


func _ready() -> void:
	$Timer.wait_time = rng.randf() * 3.0
	$Timer.timeout.connect(func():
		make_wind()
		rng.randomize()
		$Timer.wait_time = rng.randf() * 3.0)
	$Timer.start()
