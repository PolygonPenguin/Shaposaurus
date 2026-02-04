extends Node2D
var bezier_resolution = 100
var ui_dragging = false
var ui_hoverblock = false
var ui_mouse_blocked=false
var selected = {"points":[], "shapes":[], "ui":[]}
var ui_drag_delta = Vector2(0,0)
var _start_mouse_position = Vector2(0,0)
func _process(_delta: float) -> void:
	ui_drag_delta = get_global_mouse_position()-_start_mouse_position
	if not ui_hoverblock and Input.is_action_just_pressed("lclick"):
		selected = {"points":[], "shapes":[], "ui":[]}
	ui_hoverblock=ui_mouse_blocked
func ui_check_item_clicked(caller, right=false):
	if (ui_dragging or ui_hoverblock):
		return false
	else:
		var clicked = false
		if right:
			clicked= Input.is_action_just_pressed("rclick")
		else:
			clicked= Input.is_action_just_pressed("lclick")
		ui_hoverblock=true
		return clicked

func ui_check_item_hovered(caller):
	if (ui_dragging or ui_hoverblock):
		return false
	else:
		ui_hoverblock=true
		return true

func ui_check_item_dragged(caller, right=false):
	if (ui_dragging or ui_hoverblock):
		return false
	else:
		var clicked = false
		if right:
			clicked= Input.is_action_just_pressed("rclick")
		else:
			clicked= Input.is_action_just_pressed("lclick")
		ui_dragging=clicked
		ui_hoverblock=true
		if clicked:
			_start_mouse_position = get_global_mouse_position()
			ui_drag_delta=Vector2.ZERO
			if caller in selected["points"]:
				for i in selected["points"]:
					i.dragging = true
					i.dragStart = i.position
			elif caller in selected["shapes"]:
				for i in selected["shapes"]:
					i.dragging = true
					i.dragStart = i.position
		return clicked

func ui_poll_item_dragged(caller, right=false):
	if (!ui_dragging):
		return false
	else:
		var clicked = false
		if right:
			clicked= Input.is_action_pressed("rclick")
		else:
			clicked= Input.is_action_pressed("lclick")
		ui_dragging=clicked
		return clicked
