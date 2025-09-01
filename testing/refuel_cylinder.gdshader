shader_type spatial;

render_mode unshaded, cull_disabled;
//varying float top_switch;
//void vertex() {
	//top_switch = 1. - step(0., dot(NORMAL, vec3(0., 1., 0.)));
//}

uniform sampler2D noise: repeat_enable;
void fragment() {
	vec4 noise_sample = texture(noise, UV * vec2(1., .01) - vec2(0., 0.05 * TIME));
	ALBEDO = vec3(0., 2., 0.) * noise_sample.xyz;
	ALPHA = 0.5 * UV.y;
	//ALPHA = dot(NORMAL, vec3(0., -1, 0.)) < 0. ? 0. : 1.0; 
	//ALPHA *= 1. - smoothstep(0.2, 0.21, UV.y);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
