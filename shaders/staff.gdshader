shader_type canvas_item;

uniform float offset_x;
uniform float direction;

const float TAIL_MINIMUM_WIDTH = 0.1;

const float WAVE_AMPLITUDE = 0.05;
const float WAVE_SPEED = 2.0;
const float WAVE_LENGTH = 2.0;

void fragment() {

  float tailed_uv = 0.5 + (UV.y - 0.5) / pow(TAIL_MINIMUM_WIDTH + (1.0 - TAIL_MINIMUM_WIDTH) * smoothstep(0.0, 1.0, UV.x), 0.5);
  float waved_uv = tailed_uv - cos(WAVE_SPEED * TIME + UV.x * 2.0 * PI * WAVE_LENGTH) * WAVE_AMPLITUDE;

  vec2 uv = vec2(UV.x + offset_x, waved_uv);

  if (uv.x < 0.0 || uv.x > 1.0) {
    discard;
  }

	vec4 screen_color = texture(TEXTURE, uv);

	COLOR = screen_color;
}
