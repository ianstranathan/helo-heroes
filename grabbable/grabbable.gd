extends Bob

"""
"""

class_name Grabbable

signal grabbed( pos )
signal unhooked

enum WeightEnum{
	LIGHT,
	MEDIUM,
	HEAVY
}

# -- TODO
# -- Need to make mass agree with weight abstraction
# -- floor(mass / mass_intervals)
# -- mass_intervals: MAX_MASS - MIN_MASS / 3 (i.e. number of enums)

@export var weight: WeightEnum = WeightEnum.LIGHT

func tether_to( pickup_bob: Bob):
	#global_position = pickup_bob.global_position
	anchor = pickup_bob.anchor
	emit_signal("grabbed", global_position)


func unhook_from( _pickup_bob: Bob ):
	emit_signal("unhooked")
	anchor = null
