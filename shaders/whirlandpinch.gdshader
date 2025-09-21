shader_type canvas_item;
render_mode unshaded;

uniform vec2 source_position;

uniform vec2 target_screen_size;

uniform float scale_factor;

uniform float radius;
uniform float whirl;
uniform float pinch;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

varying vec2 source_screen_position;

vec2 rotate(vec2 v, float angle) {
  return vec2(cos(angle) * v.x - sin(angle) * v.y, sin(angle) * v.x + cos(angle) * v.y);
}

void vertex() {
  source_screen_position = (CANVAS_MATRIX * vec4(source_position, 0.0, 1.0)).xy;
}

void fragment() {
  vec2 source_to_target = FRAGCOORD.xy - source_screen_position;

  float factor = 1.0 - smoothstep(0.0, 1.0, length(source_to_target) / radius);

  vec2 direction = normalize(source_to_target);
  vec2 offset = mix(source_to_target, direction * radius, pinch);

  offset = rotate(offset, whirl * 2.0 * PI);

  vec2 new_position = mix(FRAGCOORD.xy, FRAGCOORD.xy - source_to_target + offset, factor);

	vec4 c = texture(screen_texture, new_position * SCREEN_PIXEL_SIZE, 0.0);
	// vec4 c = texture(screen_texture, FRAGCOORD.xy * SCREEN_PIXEL_SIZE, 0.0);
	//vec4 c = texture(screen_texture, SCREEN_UV, 0.0);
  // vec4 c = vec4(step(FRAGCOORD.xy, vec2(512.0, 512.0)), 0.0, 1.0);

  if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;

  // COLOR = vec4(vec2((step(SCREEN_UV.x, 0.9)) * SCREEN_UV.x, (step(SCREEN_UV.y, 0.9)) * SCREEN_UV.y), 0.0, 1.0);
  // COLOR = vec4(vec3(step(source_screen_position.y, 1.0 / SCREEN_PIXEL_SIZE.y)), 1.0);


}