shader_type spatial;

render_mode unshaded;
uniform sampler2D surface_noise_tex: repeat_enable;

uniform float _t: hint_range(0.0, 1.0, 0.1);
void fragment(){
	ALPHA = 0.0;
	//float _lifetime = COLOR.w;
	//vec4 n = texture(surface_noise_tex, UV - 0.3 * vec2(_lifetime));
	//float n_col = 1. - smoothstep(_lifetime, _lifetime + 0.01, n.r);
	//ALBEDO = vec3(n_col);
	//ALPHA = -10.0;
	//ALPHA = n_col;
	//ALPHA = n_col;
	//ALPHA_SCISSOR_THRESHOLD = 0.5;
	//ALPHA = 1. - n_col;
}