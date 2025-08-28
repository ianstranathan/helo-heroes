extends Control


var helicopter_reference: CharacterBody3D

func _physics_process(_delta: float) -> void:
	# -- let radar shader know about the rotation of the helicopter
	$Radar.material.set_shader_parameter("angle", -helicopter_reference.global_rotation.y)

func set_fuel(normalized_fuel_ratio: float):
	$Radar.material.set_shader_parameter("progress", normalized_fuel_ratio)
