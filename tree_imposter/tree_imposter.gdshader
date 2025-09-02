shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D tex;
void fragment() {
	vec2 uv = UV;
	vec4 tex_sample = texture(tex, uv);
	ALBEDO = 0.8 * tex_sample.xyz;
	ALPHA = tex_sample.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
