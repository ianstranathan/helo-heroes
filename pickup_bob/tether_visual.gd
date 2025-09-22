extends Node3D

var tether_reference: Node3D
var bob_reference: Node3D

@export var num_links: int = 5

# TODO
# make links visual that is reasonable looking
	
func _ready() -> void:
	var meshinstance = MeshInstance3D.new()
	meshinstance.mesh = CylinderMesh.new()
	add_child(meshinstance)

func change_bob( g: RigidBody3D):
	bob_reference = g


func set_up(br,tr):
	tether_reference = tr
	bob_reference = br


func _physics_process(delta: float) -> void:
	var mesh_links = get_children()
	var TMP_THE_MESH = mesh_links[0]
	if (tether_reference and 
		bob_reference    and
		TMP_THE_MESH):
		var relative_pos = bob_reference.global_position - tether_reference.global_position

		TMP_THE_MESH.mesh.height = relative_pos.length()
		TMP_THE_MESH.rotation.z = PI/2. - relative_pos.angle_to(Vector3.RIGHT)
		#rotate_z( relative_pos.angle_to(Vector3.RIGHT))
		TMP_THE_MESH.global_position = tether_reference.global_position + relative_pos / 2.0
