extends Spatial

onready var debug_mesh = $MeshInstance

var surf_tool_front : SurfaceTool = null
var surf_tool_back : SurfaceTool = null
var mesh_front : Mesh = null
var mesh_back : Mesh = null
var mesh_instance_front : MeshInstance = null
var mesh_instance_back : MeshInstance = null

var last_line : AABB = AABB()

func brush_stroke_started(position, draw_head):
#	debug_orb_thing(position, draw_head)
	
	surf_tool_front = SurfaceTool.new()
	surf_tool_back = SurfaceTool.new()
	mesh_front = Mesh.new()
	mesh_back = Mesh.new()
	mesh_instance_front = MeshInstance.new()
	mesh_instance_back = MeshInstance.new()
	
	surf_tool_front.add_color(Color(1.0, 1.0, 1.0, 1.0))
	surf_tool_back.add_color(Color(1.0, 1.0, 1.0, 1.0))
	
	surf_tool_front.begin(Mesh.PRIMITIVE_TRIANGLES)
	surf_tool_back.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Create the first point - kinda debug, but we'll see how it looks
	last_line = get_current_line(draw_head)
	
	update_strips(last_line)
	
	self.add_child(mesh_instance_front)
	self.add_child(mesh_instance_back)
	mesh_instance_front.set_owner(self)
	mesh_instance_back.set_owner(self)
	

func brush_segment(position, draw_head):
#	debug_orb_thing(position, draw_head)
	update_strips(get_current_line(draw_head))
	

func brush_stroke_ended(position, draw_head):
#	debug_orb_thing(position, draw_head)
	update_strips(get_current_line(draw_head))
	
	self.add_child(mesh_instance_front)
	self.add_child(mesh_instance_back)
	mesh_instance_front.set_owner(self)
	mesh_instance_back.set_owner(self)
	
	surf_tool_front = null
	surf_tool_back = null
	mesh_front = null
	mesh_back = null
	mesh_instance_front = null
	mesh_instance_back = null

func debug_orb_thing(position, draw_head):
	print(str(position), ", ", str(draw_head))

	var mesh_inst : MeshInstance = draw_head
	var verts : PoolVector3Array = mesh_inst.mesh.get_faces()

#	var debug_face_1 : MeshInstance = mesh_inst.duplicate(0)
	var debug_face_1 : MeshInstance = debug_mesh.duplicate(0)

	self.add_child(debug_face_1)
	debug_face_1.set_owner(self)
	debug_face_1.set_translation(position)
	debug_face_1.transform = mesh_inst.get_global_transform()
	
func get_current_line(draw_head) -> AABB:
	var trans : Transform = draw_head.get_global_transform()
	var mesh_inst : MeshInstance = draw_head.duplicate(0)
	var verts : PoolVector3Array = mesh_inst.mesh.get_faces()
	
	
	var brush_size : PlaneMesh = draw_head.mesh.get_size()
	var corner : Vector3 = Vector3(-brush_size.x / 2.0, 0, brush_size.y / 2.0)
	var width : Vector3 = Vector3(brush_size.x, 0, 0)
	
	
	# Get the 2 vertices closest to the tool as the draw line, rotate and translate to the world coords
	var aabb : AABB = AABB(corner, width)
	return trans.xform(aabb)
	
func update_strips(line : AABB):
	
	# A-----B    A: last_line.position
	# | \   |    B: last_line.end
	# |   \ |    C: line.position
	# C-----D    D: line.end
	
	print ("last line: " + str(last_line))
	print ("this line: " + str(line))
	
	# Clockwise for front
	surf_tool_front.add_vertex(last_line.position)
	surf_tool_front.add_vertex(last_line.end)
	surf_tool_front.add_vertex(line.end)
	surf_tool_front.add_vertex(last_line.position)
	surf_tool_front.add_vertex(line.end)
	surf_tool_front.add_vertex(line.position)
	
	surf_tool_back.add_vertex(last_line.position)
	surf_tool_back.add_vertex(line.end)
	surf_tool_back.add_vertex(last_line.end)
	surf_tool_back.add_vertex(last_line.position)
	surf_tool_back.add_vertex(line.position)
	surf_tool_back.add_vertex(line.end)
	
	surf_tool_front.generate_normals()
	surf_tool_back.generate_normals()
	
	surf_tool_front.commit(mesh_front)
	surf_tool_back.commit(mesh_back)
	
	mesh_instance_front.set_mesh(mesh_front)
	mesh_instance_back.set_mesh(mesh_back)
	
	last_line = line
	