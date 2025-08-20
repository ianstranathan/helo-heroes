extends Sprite3D

func _ready() -> void:
	$Timer.timeout.connect( func():
		queue_free())
