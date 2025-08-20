extends Bob

signal grabbed_item( item: Grabbable)
@onready var pickup_area: Area3D = $Area3D

func _ready() -> void:
	pickup_area.body_entered.connect( grab_item )
	$PickupBuffer.timeout.connect( func(): 
		pickup_area.get_node("CollisionShape3D").set_deferred("disabled", false))


func _physics_process(delta: float) -> void:
	super(delta)
	# -- TODO
	# -- This is here to keep the swing in a plane; you shouldn't be chaning the linear velocity
	# -- directly in a physics simulation
	linear_velocity.z = 0


func can_grab_again(): # -- called from manager dropping item callback:: drop_item()
	$PickupBuffer.start()
	visible = true


func grab_item(body: Node3D):
	if body is Grabbable and $PickupBuffer.is_stopped():
		emit_signal("grabbed_item", body)
		pickup_area.get_node("CollisionShape3D").set_deferred("disabled", true)
		visible = false
