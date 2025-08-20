extends Sprite3D


@export var _vertex_scale: float = 1.0;

func _ready() -> void:
	material_override.set_shader_parameter("_vertex_scale", _vertex_scale)
	$AnimationPlayer.animation_finished.connect( func( anim_name_str):
		visible = false
	)

func pop(pos: Vector3):
	visible = true
	$AnimationPlayer.play("pop")
