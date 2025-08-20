shader_type spatial;
// Prevent the quad from being affected by lighting and fog. This also improves performance.
render_mode unshaded, fog_disabled;

//uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_tex: hint_screen_texture;
//const float ar =  1152. / 648.;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

uniform sampler2D noise_tex: repeat_enable;

//float energy(vec3 v){
	//return (v.r + v.g + v.b) / 3.;
//}

uniform float wind_dir = -1.;
const vec2 sprite_dims = vec2(128, 128);
void fragment() {
	vec2 ar = 1.0/VIEWPORT_SIZE;
	vec2 uv = 2. * SCREEN_UV - 1.;
	uv.x *= ar.y / ar.x;

	vec4 tex = texture(noise_tex,uv * vec2(0.05, 1.) + vec2(0.1 * TIME, 0.));
	vec4 tex2 = texture(noise_tex, vec2(0.1 * tex.r, tex.g));
	float wind_mask = 0.1 * smoothstep(0.5, 1., tex.r);
	ALBEDO = vec3(tex2.r);//texture(screen_tex, SCREEN_UV).xyz;
}