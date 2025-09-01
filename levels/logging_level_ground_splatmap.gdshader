shader_type spatial;


uniform sampler2D tex1: repeat_enable;
uniform sampler2D tex2: repeat_enable;
uniform sampler2D tex3: repeat_enable;
uniform sampler2D noise_tex: repeat_enable;

const float AR = 40.0 / 125.0; // HARDCODED FROM QUAD SIZE, FIX ME PLS
void fragment() {
	vec2 uv = 2. * UV - 1.;
	uv.y *= 1. / AR;
	vec4 noise_sample = texture(noise_tex, 0.513 * uv - 1234.567);
	vec4 noise_sample2 = texture(noise_tex, 2.2 * uv - 3210.765);
	float t = 2. * noise_sample2.r * noise_sample.r;
	vec4 grass_sample = texture(tex1, 1. * uv);
	vec4 dirt_sample = texture(tex2, 4. * uv);
	vec4 rock_sample = texture(tex3, 2. * uv);
	
	float grass_mask= smoothstep(0.3, 0.35, t);
	float rock_mask = 1. - smoothstep(-0.05, -0.04, uv.x * t);
	
	vec3 col = (1. - rock_mask) * 
	           grass_mask * grass_sample.xyz + (1. - grass_mask) * dirt_sample.xyz
			   + rock_mask * rock_sample.xyz;
	ALBEDO = col;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
