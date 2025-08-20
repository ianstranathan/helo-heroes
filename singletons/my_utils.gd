extends Node

@onready var rng = RandomNumberGenerator.new()
@onready var _noise = FastNoiseLite.new()

func _ready() -> void:
	rng.randomize()

func rnd_vec3(_range: float = 1.0) -> Vector3:
	rng.randomize()
	return _range * Vector3(rng.randi(), rng.randi(), rng.randi())

func rnd_col(_alpha=1.0) -> Color:
	var a_rnd_vec3: Vector3 = rnd_vec3()
	return Color(a_rnd_vec3.x, a_rnd_vec3.y, a_rnd_vec3.z, _alpha)

func easeInBack(x: float) -> float:
	var c1 = 1.70158;
	var c3 = c1 + 1;
	return (c3 * x * x * x - c1 * x * x)

func some_random_custom_easing(x: float):
	return sin(PI * x * x)

func normalized_timer(_timer: Timer) -> float:
	return (_timer.wait_time - _timer.time_left)/ _timer.wait_time
