extends Spatial

class_name BrushHandle

export (NodePath) var initial_owner = null

var pick_area : Area = null
var controller : ARVRController = null

func _ready():
	# Just want to add the tool to the players hand from the beginning
	pick_area = get_node(initial_owner)
	controller = pick_area.get_parent()
	$PickableObject.pick_up(pick_area)
	
func get_controller() -> ARVRController:
	return controller