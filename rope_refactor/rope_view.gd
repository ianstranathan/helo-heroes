extends MeshInstance3D


func extend(amt: float):
	mesh.size.y += amt
	material_override.set_shader_parameter("len", mesh.size.y)
