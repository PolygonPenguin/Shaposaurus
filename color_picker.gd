extends Control
var h = 0.0
var s = 100.0
var v= 100.0
var a = 100.0
var color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
func update():
	$picker/hi.text = str(round(h*10)/10)
	$picker/si.text = str(round(s*10)/10)
	$picker/vi.text = str(round(v*10)/10)
	$picker/ai.text = str(round(a*10)/10)
	$picker/hs.value = h
	$picker/ss.value = s
	$picker/vs.value = v
	$picker/as.value = a
	color = Color.from_hsv(h/360, s/100, v/100, a/100)
	$picker/hex.text = "#"+color.to_html()
	$picker/h.material.set_shader_parameter("color", Vector3(h/360, s/100, v/100))
	$picker/s.material.set_shader_parameter("color", Vector3(h/360, s/100, v/100))
	$picker/v.material.set_shader_parameter("color", Vector3(h/360, s/100, v/100))
	$picker/a.material.set_shader_parameter("color", Vector3(h/360, s/100, v/100))
	$picker/hs.material.set_shader_parameter("color", Color(color, 1.0))
	$ColorRect.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if $gripdetect.hovered:
		if Global.ui_check_item_clicked(self):
			if $picker.visible:
				Global.selected["ui"] = []
			else:
				Global.selected["ui"] = [self]
	$picker.visible=self in Global.selected["ui"]


func _on_hi_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		h= fmod(float(new_text), 360)
	update()


func _on_si_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		s= fmod(float(new_text), 360)
	update()


func _on_vi_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		v= fmod(float(new_text), 360)
	update()


func _on_ai_text_submitted(new_text: String) -> void:
	if new_text.is_valid_float():
		a= fmod(float(new_text), 360)
	update()


func _on_hex_text_submitted(new_text: String) -> void:
	var color = Color.from_string(new_text, Color.from_hsv(h/360, s/100, v/100, a/100))
	h = color.h*360
	s = color.s*100
	v = color.v*100
	a = color.a*100
	update()


func _on_hs_value_changed(value: float) -> void:
	h=value
	update()



func _on_ss_value_changed(value: float) -> void:
	s=value
	update()


func _on_vs_value_changed(value: float) -> void:
	v=value
	update()


func _on_as_value_changed(value: float) -> void:
	a=value
	update()	
