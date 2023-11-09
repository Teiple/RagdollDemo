extends Node3D
class_name Soldier

@export var ragdoll_scene : PackedScene
var is_dead := false
@onready var skeleton : Skeleton3D = get_child(0).get_child(0).get_child(0)

func _unhandled_input(event):
	if !is_dead && event.is_action_pressed("ui_accept"):
		is_dead = true
		var ragdoll = ragdoll_scene.instantiate()  as SoldierRagdoll
		ragdoll.visible = false
		owner.add_child(ragdoll)
		ragdoll.global_transform = global_transform
		
		ragdoll.copy_pose(skeleton)
		ragdoll.start()
		
		# Wait for several fractions of a second to make sure the ragdoll pose is updated.
		# Without the waiting, the ragdoll will play a default pose for a few frames at the start
		await get_tree().create_timer(0.05, false).timeout
		ragdoll.visible = true
		call_deferred("queue_free")
