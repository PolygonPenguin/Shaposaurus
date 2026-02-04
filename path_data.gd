class_name PathData
var points = []
var closed = false
func _init(points=[], closed=false):
	self.points = points
	self.closed=closed
func add_point(point: JointData):
	points.append(point)
func clear_points():
	points = []

func translate(translation):
	for i in points:
		i.translate(translation)

func scale(factor, about=null):
	for i in points:
		i.scale(factor, about)

func rotate(direction, about=null):
	for i in points:
		i.rotate(direction, about)

func to_svg():
	var svg = "M "+str(points[0].position.x)+" "+str(points[0].position.y)
	for i in len(points)-1:
		svg+="C "+str(points[i].right_handle.x)+" "+str(points[i].right_handle.y)+", "+str(points[i+1].left_handle.x)+" "+str(points[i+1].left_handle.y)+", "+str(points[i+1].position.x)+" "+str(points[i+1].position.y)
	if closed:
		svg+="C "+str(points[-1].right_handle.x)+" "+str(points[-1].right_handle.y)+", "+str(points[0].left_handle.x)+" "+str(points[0].left_handle.y)+", "+str(points[0].position.x)+" "+str(points[0].position.y)
		svg+="Z"
	return "<path d=\""+svg+"\" />"
