extends MeshInstance

onready var plane_mesh : PlaneMesh = self.mesh
onready var controller : ARVRController
onready var brush : BrushHandle = get_node("../..")

onready var base_size = plane_mesh.get_size()
onready var base_translation = translation
onready var z_offset = - ( - base_size.y / 2 - base_translation.z)

const min_size = Vector2(0.01, 0.01)
const max_size = Vector2(2.0, 2.0)
const edit_speed = Vector2(0.1, 0.1)

func _process(delta):
	
	if controller == null:
		controller = brush.get_controller()
		return
	
	var new_size = plane_mesh.get_size()
	
	if controller.get_joystick_axis(0):
		new_size.x += controller.get_joystick_axis(0) * delta * edit_speed.x
		new_size.x = max(min_size.x, new_size.x)
		new_size.x = min(max_size.x, new_size.x)
		
	if controller.get_joystick_axis(1):
		new_size.y += controller.get_joystick_axis(1) * delta * edit_speed.y
		new_size.y = max(min_size.y, new_size.y)
		new_size.y = min(max_size.y, new_size.y)
		
	if new_size: 
		plane_mesh.set_size(new_size)
		translation.z = z_offset - new_size.y / 2
	