extends Node2D
@export var start = Vector2(0,0)
@export var startHandle = Vector2(0,0)
@export var end = Vector2(0,0)
@export var endHandle = Vector2(0,0)
var points = []
func _cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)
	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)
	var s = r0.lerp(r1, t)
	return s
# Called when the node enters the scene tree for the first time.
func refresh():
	$seg.clear_points()
	points = []
	for i in Global.bezier_resolution+1:
		var t = float(i)/Global.bezier_resolution
		var point = _cubic_bezier(start, startHandle, endHandle, end, t)
		points.append(point)
		$seg.add_point(point)
