shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;
global uniform float ratio = 1.77777777777777777777777777777777777777777777777778;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 blue_abberation = texture(screen_texture, vec2(SCREEN_UV.x-0.002, SCREEN_UV.y-0.002*ratio));
	blue_abberation.b *= 2.0;
	blue_abberation.a = 0.1;
	COLOR = blue_abberation;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
