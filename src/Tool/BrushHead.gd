extends MeshInstance

signal stroke_started(position, draw_head)
signal segment(position, draw_head)
signal stroke_ended(position, draw_head)

const min_size = Vector2(0.01, 0.01)
const max_size = Vector2(2.0, 2.0)
const edit_speed = Vector2(0.1, 0.1)

var drawing : bool = false
var previous_position : Vector3 = self.get_global_transform().origin

onready var plane_mesh : PlaneMesh = self.mesh
onready var controller : ARVRController
onready var brush : BrushHandle = get_node("../..")

onready var base_size = plane_mesh.get_size()
onready var base_translation = translation
onready var z_offset = - ( - base_size.y / 2 - base_translation.z)

func _process(delta):
	
	if controller == null:
		controller = brush.get_controller()
		return
	
	update_brush_size(delta)
	
	draw_ribbon()

func update_brush_size(delta):
	
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

func draw_ribbon():
	if controller.is_button_pressed(15):
		if drawing:
			# Make the ribbon section as the controller is moved
			# Finalise sections when the controller is moved far enough
			var current_position = self.get_global_transform().origin
			var moved_distance : float = current_position.distance_to(previous_position)
			var brush_length := plane_mesh.get_size().y
			if (moved_distance >= brush_length):
				var move_by := brush_length
				while (move_by + brush_length <= moved_distance):
					move_by += brush_length
				previous_position = previous_position.linear_interpolate(current_position, moved_distance / move_by)
				emit_signal("segment", previous_position, self)
		else:
			# Need to start a drawing mesh when none existent
			previous_position = self.get_global_transform().origin
			emit_signal("stroke_started", previous_position, self)
			drawing = true
			self.set_visible(false)
			
	else:
		if drawing:
			# Draw last section of ribbon
			previous_position = self.get_global_transform().origin
			emit_signal("stroke_ended", previous_position, self)
			drawing = false
			self.set_visible(true)
