shader_type canvas_item;
uniform vec3 color;
uniform int display: hint_enum("Hue", "Saturation", "Value", "Opacity");
vec3 hsv_to_rgb(vec3 hsv) {
	if (hsv.y == 0.0) {
		return vec3(hsv.z);
	}
	int i = int(hsv.x*6.0);
	float f = (hsv.x*6.0)-float(i);
	float p = (hsv.z * (1.0-hsv.y));
	float q = (hsv.z * (1.0-hsv.y * f));
	float t = (hsv.z * (1.0-hsv.y * (1.0-f)));
	i = int(mod(float(i), 6.0));
	
	if (i==0) {
		return vec3(hsv.z, t, p);
	} else if (i==1) {
		return vec3(q, hsv.z, p);
	} else if (i==2) {
		return vec3(p, hsv.z, t);
	} else if (i==3) {
		return vec3(p, q, hsv.z);
	} else if (i==4) {
		return vec3(t, p, hsv.z);
	} else {
		return vec3(hsv.z, p ,q);
	}
}
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (display == 0) {
		COLOR.rgb *= hsv_to_rgb(vec3(UV.x, color.y, color.z));
	} else if (display == 1) {
		COLOR.rgb *= hsv_to_rgb(vec3(color.x, UV.x, color.z));
	} else if (display == 2) {
		COLOR.rgb *= hsv_to_rgb(vec3(color.x, color.y, UV.x));
	} else if (display == 3) {
		COLOR.rgb *= hsv_to_rgb(vec3(color.x, color.y, color.z));
		COLOR.a *= UV.x;
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
