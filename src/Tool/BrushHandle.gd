class_name BrushHandle
extends Spatial
"""Should present a brush 'tool' and provide signals to indicate drawing events produced by the brush"""

signal brush_stroke_started(position, draw_head)
signal brush_segment(position, draw_head)
signal brush_stroke_ended(position, draw_head)

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

func stroke_started(position, draw_head):
	emit_signal("brush_stroke_started", position, draw_head)

func segment(position, draw_head):
	emit_signal("brush_segment", position, draw_head)

func stroke_ended(position, draw_head):
	emit_signal("brush_stroke_ended", position, draw_head)
