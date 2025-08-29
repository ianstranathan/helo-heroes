extends Node

# -- TODO:
# -- Move this somewhere else
@export var helicopter_and_camera_turn_threshold = 0.8

func _ready():
	# -- VARS
	$CanvasLayer/Hud.helicopter_reference = $Helicopter # -- radar needs to know about helicopter
	$Helicopter.wind_velocity             = $environmentals.wind_velocity
	$BobManager.anchor                    = $Helicopter
	
	# -- SIGNALS
	$Helicopter.dropped_item.connect( $BobManager.drop_item )
	$Helicopter.fuel_changed.connect(func(fuel_ratio: float):
		$CanvasLayer/Hud.set_fuel(fuel_ratio))
	# connect $Helicopter.fuel_empty to monochromatic or sepia-toned to give game over
	
	$TestScene.object_grabbed.connect( func(pos: Vector3):
		$vfx_manager.pop_effect_fn(pos)
		$Camera3D.shake())
