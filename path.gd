extends Node2D
var path: PathData = PathData.new()
var nodes: Array[Node2D] = []
var segments: Array[Node2D] = []
var closeseg = null
var closed = false
const joint = preload("res://joint.tscn")
const segment = preload("res://path_segment.tscn")
func render():
	for i in nodes:
		i.queue_free()
	for i in segments:
		i.queue_free()
	nodes = []
	segments = []
	closed = path.closed
	for i in len(path.points):
		var jnt = joint.instantiate()
		jnt.z_index=1
		jnt.from_joint_data(path.points[i])
		nodes.append(jnt)
		add_child(jnt)
		if i >0:
			var seg = segment.instantiate()
			seg.start = path.points[i-1].position
			seg.startHandle = path.points[i-1].right_handle
			seg.end = path.points[i].position
			seg.endHandle = path.points[i].left_handle
			add_child(seg)
			segments.append(seg)
			seg.refresh()
	if closed:
		var seg = segment.instantiate()
		seg.start = path.points[-1].position
		seg.startHandle = path.points[-1].right_handle
		seg.end = path.points[0].position
		seg.endHandle = path.points[0].left_handle
		add_child(seg)
		closeseg=seg
		seg.refresh()

func update():
	var changed = false
	for i in len(path.points):
		nodes[i].run()
		changed = nodes[i].to_joint_data(path.points[i]) or changed
	if changed:
		for i in len(path.points):
			if i>0:
				var seg = segments[i-1]
				seg.start = path.points[i-1].position
				seg.startHandle = path.points[i-1].right_handle
				seg.end = path.points[i].position
				seg.endHandle = path.points[i].left_handle
				seg.refresh()
	if closed:
		if closeseg and changed:
			var seg = closeseg
			seg.start = path.points[-1].position
			seg.startHandle = path.points[-1].right_handle
			seg.end = path.points[0].position
			seg.endHandle = path.points[0].left_handle
			seg.refresh()
		elif not closeseg:
			changed=true
			var seg = segment.instantiate()
			seg.start = path.points[-1].position
			seg.startHandle = path.points[-1].right_handle
			seg.end = path.points[0].position
			seg.endHandle = path.points[0].left_handle
			add_child(seg)
			closeseg=seg
			seg.refresh()
	else:
		if closeseg:
			changed=true
			closeseg.queue_free()
			closeseg = null
	return changed
