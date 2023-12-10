shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float offset = sin(TIME*7.0+UV.y*15.0)/1000.0+sin(TIME*1.3+UV.y*18.0+UV.x*10.0)/450.0-sin(TIME+UV.y*30.0+UV.x*10.0)/500.0;
	offset /= 2.0;
	vec2 new_UV = UV+offset;
	int tile = int(UV.x*8.0);
	
	if (new_UV.x-0.001 < float(tile)/8.0){
		COLOR = texture(TEXTURE, vec2(float(tile)/8.0+0.002, UV.y));
	}else if (new_UV.x+0.002 > float(tile)/8.0+1.0/8.0){
		COLOR = texture(TEXTURE, vec2(float(tile)/8.0+1.0/8.0-0.002, UV.y));
	}else{
		COLOR = texture(TEXTURE, new_UV);
	}
	
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
