extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var path = PathData.new([
		JointData.new(Vector2(0,0), Vector2(-10,0), Vector2(10,0)),
		JointData.new(Vector2(20,10), Vector2(-10,0), Vector2(10,0)),
		JointData.new(Vector2(40,5), Vector2(-10,0), Vector2(10,0)),
		JointData.new(Vector2(60,10), Vector2(-10,0), Vector2(10,0)),
		JointData.new(Vector2(80,0), Vector2(-10,0), Vector2(10,0)),
		], true)
	$shape.shape = ShapeData.new(path, Color.RED)
	$shape.update(true, true)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print($shape.shape.to_svg())


func _on_area_2d_mouse_entered() -> void:
	Global.ui_mouse_blocked = false


func _on_area_2d_mouse_exited() -> void:
	Global.ui_mouse_blocked = true
