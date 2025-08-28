shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float hash_vec2(vec2 p){
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}
uniform sampler2D n_tex1: repeat_enable;
//uniform sampler2D tex2: repeat_enable;
uniform sampler2D mask_tex;
uniform float multi: hint_range(0.0, 1.0, 0.1) = 1.0;
void fragment() {
	//float t_1_offset = hash_vec2(vec2(5.));
	//float t_2_offset = hash_vec2(vec2(100.));
	//vec2 scroll_1 = vec2(0., 0.1234 * TIME - t_1_offset);
	//vec2 scroll_2 = vec2(0., 0.1 * TIME + t_2_offset);
	
	vec2 scroll = 0.1 * vec2(0., TIME);
	vec4 n_tex1_sample_1 = texture(n_tex1, multi * UV + scroll);
	vec4 n_tex1_sample_2 = texture(n_tex1, multi * 0.5 * UV + 0.75 * scroll);
	vec4 n_tex1_sample_3 = texture(n_tex1, multi * 2. * UV + 0.85 * scroll);
	float prod = n_tex1_sample_3.r * n_tex1_sample_1.r * n_tex1_sample_2.r * 2.0;
	
	vec4 mask_sample = texture(mask_tex, UV);
	COLOR = vec4(vec3(mask_sample.a * prod), mask_sample.a * prod);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
