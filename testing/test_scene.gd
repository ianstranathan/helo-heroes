extends Node3D

var s_blocK_scene: PackedScene = preload("res://levels/tetriminos/S_block/s_block_grabbable.tscn")
var o_blocK_scene: PackedScene = preload("res://levels/tetriminos/0_block/O_block_grabbable.tscn")
var l_block_scene: PackedScene = preload("res://levels/tetriminos/L_block/l_block_grabbable.tscn")
var t_block_scene: PackedScene = preload("res://levels/tetriminos/T_block/T_block_grabbable.tscn")
var z_block_scene: PackedScene = preload("res://levels/tetriminos/Z_block/Z_block_grabbable.tscn")
@onready var tetrimo_scenes: Array[PackedScene] = [s_blocK_scene, o_blocK_scene, l_block_scene,
												   t_block_scene, z_block_scene]
@export var number_of_tetriminos: int
@export var extents: Vector2
signal object_grabbed( pos: Vector3)

func _ready() -> void:
	assert(number_of_tetriminos)
	# make a bunch of randomly sized tetriminos for demo purposes
	for i in range( number_of_tetriminos):
		# -- a random tetrimino
		tetrimo_scenes.shuffle()
		var tetrimino: Grabbable = tetrimo_scenes[randi_range(0, tetrimo_scenes.size() - 1)].instantiate()

		# -- add signals
		tetrimino.grabbed.connect( func(pos: Vector3):
			emit_signal("object_grabbed", pos) )

		# -- add to scene to initialize position
		add_child(tetrimino)
		
		var s = MyUtils.rng.randi_range(1, 3.5)
		# -- scale to random
		tetrimino.get_children().map( func(child_node):
			child_node.scale = Vector3(s,s,s)
			child_node.position *= s)
		
		# -- a random position in plane
		tetrimino.global_position = 0.8 * Vector3(MyUtils.rng.randi_range(-extents.x / 2.0, extents.x / 2.0), # to be around origin
										 MyUtils.rng.randi_range(10., extents.y), # -- arbitrary, from measuring util in editor
										 0. )
		# -- a random rotation in plane
		tetrimino.rotate_z(2 * PI * float(randi_range(0, 2)))
