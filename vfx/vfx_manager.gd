extends Node

var pop_effect_scene: PackedScene = preload("res://vfx/grab_pop_effect/grab_pop_effect.tscn")
var pop_effect: Sprite3D


func _ready() -> void:
	pop_effect = pop_effect_scene.instantiate()
	pop_effect.visible = false
	add_child(pop_effect)


func pop_effect_fn(pos: Vector3) -> void:
	pop_effect.global_position = pos
	pop_effect.pop(pos)
