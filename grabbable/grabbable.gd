extends Bob

"""
"""

class_name Grabbable

signal grabbed( pos )

func tether_to( pickup_bob: Bob):
	global_position = pickup_bob.global_position
	anchor = pickup_bob.anchor
	emit_signal("grabbed", global_position)

func unhook_from( _pickup_bob: Bob ):
	anchor = null
