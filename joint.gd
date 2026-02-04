extends Node2D
@export var direction_locked = true
@export var length_locked = false
@export var left_pointed = false
@export var right_pointed = false
var lastlocked=false
var lastlenlocked=false
@export var left_handle = Vector2(-10,0)
@export var right_handle = Vector2(10,0)
var dragging = false
var left_ponted
const textures = {
	"000": preload("res://icons/nodes/nd_00.svg"),
	"001": preload("res://icons/nodes/nd_01.svg"),
	"010": preload("res://icons/nodes/nd_10.svg"),
	"011": preload("res://icons/nodes/nd_11.svg"),
	"100": preload("res://icons/nodes/ns_00.svg"),
	"101": preload("res://icons/nodes/ns_01.svg"),
	"110": preload("res://icons/nodes/ns_10.svg"),
	"111": preload("res://icons/nodes/ns_11.svg"),
}
var dragStart = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$handle.grip = left_handle
	$handle2.grip = right_handle
func from_joint_data(data: JointData):
	position = data.position
	left_handle = data.left_handle-data.position
	right_handle = data.right_handle-data.position
	left_pointed = data.left_pointed
	right_pointed = data.right_pointed
	$handle.grip = left_handle
	$handle2.grip = right_handle
func to_joint_data(data = null):
	if data == null:
		data = JointData.new()
		data.position = position
		data.left_handle=position+left_handle
		data.right_handle=position+right_handle
		data.left_pointed=left_pointed
		data.right_pointed=right_pointed
		return data
	else:
		var changed = false
		if data.position != position:
			data.position = position
			changed = true
		if data.left_handle!=position+left_handle:
			data.left_handle=position+left_handle
			changed = true
		if data.right_handle!=position+right_handle:
			data.right_handle=position+right_handle
			changed = true
		if data.left_pointed!=left_pointed:
			data.left_pointed=left_pointed
			changed=true
		if data.right_pointed!=right_pointed:
			data.right_pointed=right_pointed
			changed=true
		return changed
func circle_dist(a, b):
	a=fmod(a, 360)
	b=fmod(b, 360)
	var pre = abs(a-b)
	if pre>180:
		pre = 360-pre
	return pre

func circle_average(a, b):
	a=fmod(a, 360)
	b=fmod(b, 360)
	var pre = (a+b)/2
	if abs(a-b)>180:
		pre+=180
	return pre

func split(a, b):
	a=fmod(a, 360)
	b=fmod(b, 360)
	var avg = circle_average(a, b)
	if circle_dist(a, avg+90)<circle_dist(b, avg+90):
		a=avg+90
		b=avg-90
	else:
		b=avg+90
		a=avg-90
	return [a, b]

func run():
	var selected = self in Global.selected["points"]
	$handle.visible=selected and not left_pointed
	$handle2.visible=selected and not right_pointed
	
	
	if selected:
		$handle.run()
		$handle2.run()
		if direction_locked:
			if !lastlocked:
				var out = split($handle.grip.angle()/PI*180, $handle2.grip.angle()/PI*180)
				$handle.grip = Vector2.from_angle(out[0]/180*PI)*$handle.grip.length()
				$handle2.grip = Vector2.from_angle(out[1]/180*PI)*$handle2.grip.length()
			if $handle.dragging:
				$handle2.grip = $handle.grip.normalized()*(-$handle2.grip.length())
			if $handle2.dragging:
				$handle.grip = $handle2.grip.normalized()*(-$handle.grip.length())
		if length_locked:
			if !lastlenlocked:
				var length = ($handle.grip.length()+$handle2.grip.length())/2.0
				$handle.grip = $handle.grip.normalized()*length
				$handle2.grip = $handle2.grip.normalized()*length
			if $handle.dragging:
				$handle2.grip = $handle2.grip.normalized()*($handle.grip.length())
			if $handle2.dragging:
				$handle.grip = $handle.grip.normalized()*($handle2.grip.length())
		lastlocked = direction_locked
		lastlenlocked = length_locked
	if dragging:
		dragging = Global.ui_poll_item_dragged(self)
	elif $gripdetect.hovered:
		dragging = Global.ui_check_item_dragged(self)
		if dragging:
			dragStart = position
			if not selected:
				if Input.is_action_pressed("addSelect"):
					Global.selected["points"].append(self)
				else:
					Global.selected["points"]=[self]
				selected = true
	
	if dragging:
		position = Global.ui_drag_delta+dragStart
	left_handle = Vector2.ZERO if left_pointed else $handle.grip
	right_handle = Vector2.ZERO if right_pointed else $handle2.grip
	$node.texture = textures[("1"if selected else "0")+("0"if left_pointed else "1")+("0"if right_pointed else "1")]
