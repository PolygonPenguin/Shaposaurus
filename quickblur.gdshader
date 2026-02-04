shader_type canvas_item;

uniform float radius = 4.0;
uniform int quality = 8;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

/* =========================
   Hash / RNG (good stuff)
   ========================= */

float hash12(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 78.233);
	return fract(p.x * p.y);
}

vec2 hash22(vec2 p) {
	p = fract(p * vec2(5.3983, 5.4427));
	p += dot(p, p + 21.5351);
	return fract(vec2(p.x * p.y, p.x + p.y));
}

/* =========================
   Random disk sampling
   ========================= */

vec2 random_disk(vec2 seed) {
	vec2 h = hash22(seed);
	float r = sqrt(h.x);
	float theta = 6.2831853 * h.y;
	return r * vec2(cos(theta), sin(theta));
}

/* =========================
   Blur
   ========================= */

vec4 box_blur(vec2 uv, sampler2D tex, vec2 ratio, int samples) {
	if (samples < 1) {
		return texture(tex, uv);
	}

	vec3 accum = vec3(0.0);

	for (int i = 0; i < samples; i++) {
		// Decorrelate per-sample
		vec2 seed = uv * float(i + 1) + (float(i)) * 17.0;
		seed = random_disk(seed);

		// Random but evenly distributed offset
		vec2 offset = random_disk(seed) * radius * ratio;

		accum += texture(tex, uv + offset).rgb;
	}

	return vec4(accum / float(samples), 1.0);
}

/* =========================
   Fragment
   ========================= */

void fragment() {
	vec4 col = box_blur(
		SCREEN_UV,
		SCREEN_TEXTURE,
		SCREEN_PIXEL_SIZE,
		quality
	);

	// Match your original brightness tweak
	COLOR = col / 4.0 + vec4(0.15);
	COLOR.a = 1.0;
}
