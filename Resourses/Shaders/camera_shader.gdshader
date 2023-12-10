shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear;

void fragment() {
	//vec2 new_UV = vec2(SCREEN_UV.x, (SCREEN_UV.y+sin(TIME*SCREEN_UV.x/1.0)/100.0) - floor(SCREEN_UV.y+sin(TIME*SCREEN_UV.x/1.0)/100.0));
	vec2 new_UV = vec2(SCREEN_UV.x, (SCREEN_UV.y+sin(TIME+SCREEN_UV.x*2.0)/150.0));
    vec4 c = textureLod(screen_texture, new_UV, 0.0);
    if (c.a > 0.0001) {
        c.rgb /= c.a;
    }
    COLOR *= c;
	COLOR.a = new_UV.x>1.0 || new_UV.x<0.0 || new_UV.y>1.0 || new_UV.y<0.0 ? 0.0 : COLOR.a;
}
