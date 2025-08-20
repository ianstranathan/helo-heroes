extends Node

# -- TODO:
# -- Move this somewhere else
@export var helicopter_and_camera_turn_threshold = 0.8

func _ready():
	# -- radar needs to know about helicopter
	$CanvasLayer/Hud.helicopter_reference = $Helicopter
	$Helicopter.wind_velocity = $environmentals.wind_velocity
	#$Camera3D.target_reference = $Helicopter
	$BobManager.anchor = $Helicopter
	$Helicopter.dropped_item.connect( $BobManager.drop_item )
	
	$TestScene.object_grabbed.connect( func(pos: Vector3):
		$vfx_manager.pop_effect_fn(pos)
		$Camera3D.shake())
