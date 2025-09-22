extends Node3D

@export var the_bob: Node3D
@export var the_tether_pt: Node3D

var t = 0.0

func _ready() -> void:
	$TetherVisual.tether_reference = the_tether_pt
	$TetherVisual.bob_reference = the_bob

func _physics_process(delta: float) -> void:
	t += delta
	the_tether_pt.global_position.x = 6.0 * sin(t)


	# -- move the bob around
	the_bob.global_position.x = 3.0 * cos(t)
	the_bob.global_position.y = 3.0 * sin(t)
