extends Node3D

# NOTE
# -- This is just an interface between other nodes and pickup bob related stuff

@export var anchor: Node3D
# -- this is an intermediary node to provide an interface
# -- for helicopter and the thing it carries
var pickup_bob: Bob
var pickup_bob_scene: PackedScene = preload("res://pickup_bob/pickup_bob.tscn")
var tether_visual_scene: PackedScene = preload("res://pickup_bob/tether_visual.tscn")
var tether_visual: Node3D


@export_group("Pick Up variables")
@export_range(15, 30.0) var balancing_bounds: float = 15.0
@export_range(1.0, 10.0) var light_time: float
@export_range(1.0, 15.0) var medium_time: float
@export_range(1.0, 20.0) var heavy_time: float


func _ready() -> void:
	# -----------------
	assert(anchor)
	# ----------------- Children:
	# ----------------- balancing area, pickup bob & tether visual
	pickup_bob    = pickup_bob_scene.instantiate()
	tether_visual = tether_visual_scene.instantiate()
	tether_visual.set_up(pickup_bob, anchor) # -- 
	add_child(tether_visual)
	add_child(pickup_bob)
	# ----------------- Pickup Bob signals and init
	#signal started_grabbing_item( callback: Callable )
	#signal grabbed_item( item: Grabbable)
	#signal snapped_out_of_grabbing
	pickup_bob.started_grabbing_item.connect( func( weight_enum: int):
		$BalancingArea.start_balancing(anchor.global_position,
									   time_from_grabbable_weight(weight_enum)))
	pickup_bob.snapped_out_of_grabbing.connect( pickup_bob_snapped_out )
	pickup_bob.anchor = anchor
	pickup_bob.global_position = anchor.global_position + Vector3.DOWN * anchor.tether_length
	
	# ----------------- Balancing Area signals and init
	$BalancingArea.balancing_finished.connect(on_balancing_finished)
	$BalancingArea.set_balancing_bounds( balancing_bounds )


func time_from_grabbable_weight(weight_enum: int) -> float:
	match weight_enum:
		0:
			return light_time
		1:
			return medium_time
		2:
			return heavy_time
		_:
			return light_time


func on_balancing_finished(balanced_result: bool):
	if balanced_result:
		pickup_bob.grab_item()
		tether_visual.change_bob( pickup_bob._grabbed_item )
	else:
		pickup_bob.item_started_grabbing = null
		anchor.retract_tether()


func drop_item():
	tether_visual.change_bob(pickup_bob)
	pickup_bob.drop_item()


func shoot_down(shoot_speed: float):
	pickup_bob.apply_central_impulse(150.0 * Vector3.DOWN)


func pickup_bob_snapped_out():
	anchor.retract_tether()
	$BalancingArea.snap_out()
