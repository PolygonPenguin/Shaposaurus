extends Node2D
var dragging = false
var dragStart = Vector2(0,0)
var grip = Vector2(34, 40)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func run() -> void:
	if dragging:
		dragging = Global.ui_poll_item_dragged(self)
	else:
		if $grip/gripdetect.hovered:
			dragging = Global.ui_check_item_dragged(self)
			if dragging:
				dragStart = grip
	if dragging:
		grip = dragStart+Global.ui_drag_delta

	$grip.position = grip
	$arm.points[-1]=grip
