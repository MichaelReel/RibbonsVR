extends Spatial

signal brush_stroke_started(position, draw_head)
signal brush_segment(position, draw_head)
signal brush_stroke_ended(position, draw_head)

func brush_stroke_started(position, draw_head):
	emit_signal("brush_stroke_started", position, draw_head)

func brush_segment(position, draw_head):
	emit_signal("brush_segment", position, draw_head)

func brush_stroke_ended(position, draw_head):
	emit_signal("brush_stroke_ended", position, draw_head)
