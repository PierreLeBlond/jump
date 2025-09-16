shader_type canvas_item;
render_mode unshaded;

uniform vec2 source_screen_position;

uniform vec2 target_screen_size;

uniform float radius;
uniform float whirl;
uniform float pinch;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

varying vec2 position;

vec2 rotate(vec2 v, float angle) {
  return vec2(cos(angle) * v.x - sin(angle) * v.y, sin(angle) * v.x + cos(angle) * v.y);
}

void fragment() {

  vec2 source_texture_position = source_screen_position / target_screen_size;
  float texture_radius = radius / length(target_screen_size);

  float texture_distance = length(SCREEN_UV - source_texture_position);

  float factor = 1.0 - smoothstep(0.0, 1.0, texture_distance / texture_radius);

  vec2 source_to_target = SCREEN_UV - source_texture_position;

  vec2 whirled_vector = rotate(source_to_target, factor * whirl) - source_to_target;

  vec2 direction = normalize(source_to_target);
  vec2 target_to_radius = direction * (texture_radius - length(source_to_target));
  vec2 pinch_vector = target_to_radius / pow(2.0, 1.0/pinch);

  vec2 new_texture_position = mix(SCREEN_UV, SCREEN_UV + whirled_vector + pinch_vector, factor);

	vec4 c = texture(screen_texture, new_texture_position, 0.0);

  if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;

  // COLOR = vec4(vec3(step(texture_distance, texture_radius)), 1.0);
  // COLOR = vec4(vec2(factor), 0.0, 1.0);

}