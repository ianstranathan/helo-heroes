extends MeshInstance3D

func _ready() -> void:
	pass
	var rand_size = Vector2(randf_range(0.8, 1.2), randf_range(0.7, 2.0))
	mesh.size = rand_size
	#material_override.set_shader_parameter("dimensions", rand_size)
