shader_type canvas_item;
uniform vec4 color: source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR=vec4(((COLOR.r*COLOR.g+color.r*(1.0-COLOR.g))*COLOR.b),((COLOR.r*COLOR.g+color.g*(1.0-COLOR.g))*COLOR.b),((COLOR.r*COLOR.g+color.b*(1.0-COLOR.g))*COLOR.b), COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
