class_name JointData
var left_handle = Vector2.ZERO
var position = Vector2.ZERO
var right_handle = Vector2.ZERO
var left_pointed = false
var right_pointed = false

func _init(position=Vector2.ZERO, left_handle=null, right_handle=null):
	self.position = position
	if left_handle:
		self.left_handle = left_handle+position
	else:
		left_pointed=true
	if right_handle:
		self.right_handle = right_handle+position
	else:
		right_pointed=true

func translate(translation: Vector2):
	left_handle+=translation
	right_handle+=translation
	position+=translation

func scale(factor, about=null):
	if about:
		translate(-about)
	position*=factor
	left_handle*=factor
	right_handle*=factor
	if about:
		translate(about)

func rotate(direction, about=null):
	if about:
		translate(-about)
	var cod = cos(direction)
	var snd = sin(direction)
	position = Vector2(position.x*cod-position.y*snd, position.x*snd+position.y*cod)
	left_handle = Vector2(left_handle.x*cod-left_handle.y*snd, left_handle.x*snd+left_handle.y*cod)
	right_handle = Vector2(right_handle.x*cod-right_handle.y*snd, right_handle.x*snd+right_handle.y*cod)
	if about:
		translate(about)
