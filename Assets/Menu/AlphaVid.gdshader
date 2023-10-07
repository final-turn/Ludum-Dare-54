shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float threshold;
uniform vec4 clip_color : source_color;//FF00A9

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if(length(abs(color.xyz - clip_color.xyz)) < threshold){
		discard;
	}
}
