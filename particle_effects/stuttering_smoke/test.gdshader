shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

//render_mode unshaded;
uniform sampler2D surface_noise_tex: repeat_enable;

uniform float Light_attenuation = 1.3;
uniform float Shadow_roundness = 1.0;
uniform sampler2D Color_1D_Gradient : source_color, hint_default_black;

void fragment() {
	float _lifetime = COLOR.a;
	float _t = pow(_lifetime, 2.0);
	vec4 noise_sample = texture(surface_noise_tex, UV - vec2(0., _t));
	float _threshold = 1. - smoothstep(_t, _t + 0.01, noise_sample.r);
	ALPHA = _threshold * COLOR.a;//COLOR.a;
}

//void light(){
	//float dot_result = dot(NORMAL, LIGHT);
	//float add_some_math = (clamp(dot_result, -0.90, 0.90) + 1.0)*0.47*Light_attenuation;
	//float fresnel = pow(clamp(dot(NORMAL, VIEW), 0.0, 1.0), Shadow_roundness);
	//float round_cell_shade = clamp(add_some_math,0.04, 0.98) * fresnel;
	//vec4 color_1D_gradient = texture(Color_1D_Gradient, vec2(round_cell_shade));
	//DIFFUSE_LIGHT = clamp(LIGHT_COLOR * vec3(color_1D_gradient.xyz), vec3(0), vec3(1));
//}