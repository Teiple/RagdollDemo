extends Control
class_name UI

func _process(delta):
	if get_tree().get_nodes_in_group("enemy").size() <= 0:
		hide()
		set_process(false)
