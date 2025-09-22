shader_type spatial;

render_mode unshaded;
void vertex() {
	// Called for every vertex the material is visible on.
}

mat2 rot(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), 
	            vec2(sin(angle), cos(angle)));
}
uniform sampler2D rope_col_texture: repeat_enable;
uniform	float len = 1.0;

void fragment() {
	vec2 sample_uv = 2. * UV - 1.;
	sample_uv *= 0.5;
	sample_uv = rot(PI/2.0) * sample_uv;
	sample_uv.x *= len;
	sample_uv.y = asin(sample_uv.y) - 0.1 * TIME;
	//sample_uv.x *= sprite_res.x/sprite_res.y;
	vec4 rope_col_sample = texture(rope_col_texture, 0.5 * sample_uv);
	ALBEDO = rope_col_sample.xyz * (1. - abs((2. * UV- 1.).x));
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
