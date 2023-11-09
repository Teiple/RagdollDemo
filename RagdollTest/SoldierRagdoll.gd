extends Node3D
class_name  SoldierRagdoll

@onready var skeleton : Skeleton3D = get_child(0).get_child(0).get_child(0)
@export var prevent_parent_and_child_collision := true
var pcb_dct : Dictionary

func copy_pose(from_skeleton : Skeleton3D):
	for i in from_skeleton.get_bone_count():
		skeleton.set_bone_global_pose_override(i, from_skeleton.get_bone_global_pose(i), 1.0)
	
func start():
	if prevent_parent_and_child_collision:
		for i in skeleton.get_child_count():
			var pcb = skeleton.get_child(i) as PhysicalBone3D
			if !pcb: continue
			var bone_idx = pcb.get_bone_id()
			pcb_dct[bone_idx] = pcb
			var parent_idx = skeleton.get_bone_parent(bone_idx)
			if parent_idx >= 0 && pcb_dct.has(parent_idx):
				pcb_dct[parent_idx].add_collision_exception_with(pcb)
				pcb.add_collision_exception_with(pcb_dct[parent_idx])
			if parent_idx < 0: continue
			var grand_parent_idx = skeleton.get_bone_parent(parent_idx)
			if grand_parent_idx >= 0 && pcb_dct.has(grand_parent_idx):
				pcb_dct[grand_parent_idx].add_collision_exception_with(pcb)
				pcb.add_collision_exception_with(pcb_dct[grand_parent_idx])
			
	skeleton.physical_bones_start_simulation()
	
	var mesh = skeleton.get_child(0) as MeshInstance3D
	if mesh.material_overlay != null:
		mesh.material_overlay["albedo_color"] = Color.RED
		var tween = create_tween()
		tween.tween_property(mesh.material_overlay, "albedo_color", Color.TRANSPARENT, 0.5)
