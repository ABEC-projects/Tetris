shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, UV);
	vec2 tile_UV = vec2(UV.x*8.0-floor(UV.x*8.0), UV.y*8.0-floor(UV.y*8.0));
	tile_UV = vec2(tile_UV.x/2.0 + 0.5, tile_UV.y/2.0 + 0.5);
	COLOR = vec4(tile_UV.r*COLOR.r, tile_UV.r*COLOR.g, tile_UV.r*COLOR.b, COLOR.a);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
