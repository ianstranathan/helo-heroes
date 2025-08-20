extends Node3D

@export var anchor: Node3D
# -- this is an intermediary node to provide an interface
# -- for helicopter and the thing it carries
var pickup_bob: Bob
var pickup_bob_scene: PackedScene = preload("res://pickup_bob/pickup_bob.tscn")
var grabbed_item: Grabbable


func _ready() -> void:
	pickup_bob = pickup_bob_scene.instantiate()
	add_child(pickup_bob)
	pickup_bob.grabbed_item.connect( pickup_bob_grabbed_item )
	pickup_bob.anchor = anchor
	set_to_initial_pos()


func pickup_bob_grabbed_item(g: Grabbable):
	grabbed_item = g
	grabbed_item.tether_to( pickup_bob )


func drop_item():
	if grabbed_item:
		pickup_bob.can_grab_again()
		grabbed_item.unhook_from( pickup_bob )
		grabbed_item = null


func set_to_initial_pos() -> void:
	pickup_bob.global_position = anchor.global_position + Vector3.DOWN * 0.1 * anchor.tether_length
