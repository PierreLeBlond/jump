shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 target_screen_position;
uniform float mask_radius;

void fragment() {
	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

	float distance_to_target = length(FRAGCOORD.xy - target_screen_position);

	if (distance_to_target > mask_radius) {
		screen_color = vec4(0.0, 0.0, 0.0, 1.0);
	}

	COLOR = screen_color;
}
