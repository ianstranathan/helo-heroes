extends Bob

# NOTE
# pickup buffer is hacky, just there to give delay of picking up the same
# thing instaneously after dropping it
# Needs some work / polish to make more ergonomic

signal started_grabbing_item( weight_enum: int)
signal snapped_out_of_grabbing

var grabbed_position: Vector3
var item_started_grabbing: Grabbable
var _grabbed_item: Grabbable = null

func _ready() -> void:
	$Area3D.body_entered.connect( func( body ):
		if body is Grabbable:
			start_grabbing_item(body))
	$PickupBuffer.timeout.connect( func(): 
		$Area3D.get_node("CollisionShape3D").set_deferred("disabled", false))


func _physics_process(delta: float) -> void:
	if item_started_grabbing:
		global_position = grabbed_position
		if ($SnapBuffer.is_stopped() and 
			anchor.global_position.distance_to( global_position) > 1.1 * anchor.tether_length):
			emit_signal("snapped_out_of_grabbing")
			my_disable(false)
	else: # act like a bob
		super(delta)
		linear_velocity.z = 0 # -- CHANGE ME, here to keep it in a plane


func start_grabbing_item(body) -> void:
	if !item_started_grabbing and !_grabbed_item:
		$SnapBuffer.start()
		item_started_grabbing = body
		grabbed_position = body.global_position
		emit_signal( "started_grabbing_item", body.weight)


func my_disable(b: bool) -> void:
	visible = !b
	#item_started_grabbing = null
	#_grabbed_item = null
	$CollisionShape3D.set_deferred("disabled", b)
	#$Area3D.get_node("CollisionShape3D").set_deferred("disabled", b)
	if !b: # -- if we're turning the pickup bob back on, start the pickupbuffer
		$PickupBuffer.start() # -- see timeout signal


func drop_item():
	global_position = _grabbed_item.global_position
	_grabbed_item.unhook_from( self )
	_grabbed_item = null
	my_disable( false )


func grab_item():
	_grabbed_item = item_started_grabbing
	item_started_grabbing = null
	_grabbed_item.tether_to(self)
	my_disable( true )
