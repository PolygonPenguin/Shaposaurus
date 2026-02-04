extends Node2D
var shape: ShapeData = ShapeData.new()
var polygons = []
var hovered = false
# Called when the node enters the scene tree for the first time.

func update(collision=false, fresh=false):
	if fresh:
		$path.path=shape.path
		$path.render()
	var points = []
	for i in $path.segments:
		for j in i.points:
			points.append(j)
	if $path.closeseg:
		for j in $path.closeseg.points:
			points.append(j)
	var poly = (Geometry2D.merge_polygons(points, []))
	var a = []
	var b = []
	var n = 0
	for i in poly:
		var c = []
		for j in i:
			c.append(n)
			a.append(j)
			n+=1
		b.append(c)
	$fill.polygon = a
	$fill.polygons = b
	$stroke.points = points
	$stroke.default_color = shape.strokeColor
	$stroke.width = shape.strokeWidth
	$fill.color = shape.fillColor
	
	$mouse/CollisionShape2D.shape.radius = shape.strokeWidth
	if collision:
		
		for i in max(len(polygons), len(poly)):
			if i>=len(poly):
				polygons[-1].queue_free()
				polygons.remove_at(-1)
			elif i>=len(polygons):
				var child = CollisionPolygon2D.new()
				child.polygon = poly[i]
				$gripdetect.add_child(child)
				if shape.fillColor.a == 0:
					child.build_mode = CollisionPolygon2D.BuildMode.BUILD_SEGMENTS
				else:
					child.build_mode = CollisionPolygon2D.BuildMode.BUILD_SOLIDS
				polygons.append(child)
			else:
				if shape.fillColor.a == 0:
					polygons[i].build_mode = CollisionPolygon2D.BuildMode.BUILD_SEGMENTS
				else:
					polygons[i].build_mode = CollisionPolygon2D.BuildMode.BUILD_SOLIDS
				polygons[i].polygon = poly[i]
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var selected = self in Global.selected["shapes"]
	if $path.visible and not selected:
		update(true)
	$path.visible=selected
	$mouse.position = get_local_mouse_position()
	if selected:
		if $path.update():
			shape.path = $path.path
			update()
	
	elif hovered:
		selected = Global.ui_check_item_clicked(self)
		if selected:
			if Input.is_action_pressed("addSelect"):
				Global.selected["shapes"].append(self)
			else:
				Global.selected["shapes"] = [self]
				Global.selected["points"] = []


func _on_gripdetect_area_entered(area: Area2D) -> void:
	if area == $mouse:
		hovered = true


func _on_gripdetect_area_exited(area: Area2D) -> void:
	if area == $mouse:
		hovered = false
