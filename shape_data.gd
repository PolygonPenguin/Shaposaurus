class_name ShapeData

var path = PathData.new()
var fillColor = Color.TRANSPARENT
var strokeColor = Color.BLACK
var strokeWidth = 10

func _init(path=null, fillColor = Color.TRANSPARENT,strokeColor=Color.BLACK, strokeWidth=10) -> void:
	if path:
		self.path=path
	self.fillColor=fillColor
	self.strokeColor=strokeColor
	self.strokeWidth=strokeWidth

func translate(translation):
	path.translate(translation)

func scale(factor, about=null):
	path.scale(factor, about)

func rotate(direction, about=null):
	path.rotate(direction, about)

func to_svg():
	return '<g fill="#'+fillColor.to_html()+'" stroke="#'+strokeColor.to_html()+'" stroke-width="'+str(strokeWidth)+'" stroke-linecap="round" stroke-linejoin="round">'+path.to_svg()+"<g>"
