shader_type canvas_item;

uniform bool apply = true;
uniform float offset = 1.0; //offset in permile
uniform sampler2D offsetTexture: hint_default_black;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(screen_texture, UV);
	
	if (apply){
		float adjustment_amount = offset/1000.0*(1.0-texture(offsetTexture, UV).r);
		color.r = texture(screen_texture, vec2(UV.x+adjustment_amount, UV.y)).r;
		color.b = texture(screen_texture, vec2(UV.x-adjustment_amount, UV.y)).b;
	}
	
	COLOR = color;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
