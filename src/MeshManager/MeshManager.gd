extends Spatial

onready var debug_mesh = $MeshInstance

func brush_stroke_started(position, draw_head):
#	print(str(position), ", ", str(draw_head), ", handling signal: stroke_started")
	debug_orb_thing(position, draw_head)

func brush_segment(position, draw_head):
#	print(str(position), ", ", str(draw_head), ", handling signal: segment")
	debug_orb_thing(position, draw_head)

func brush_stroke_ended(position, draw_head):
#	print(str(position), ", ", str(draw_head), ", handling signal: stroke_ended")
	debug_orb_thing(position, draw_head)

func debug_orb_thing(position, draw_head):
	var debug : MeshInstance = debug_mesh.duplicate(0)
	self.add_child(debug)
	debug.set_owner(self)
	debug.set_translation(position)