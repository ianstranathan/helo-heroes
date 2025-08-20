// NOTE: Shader automatically converted from Godot Engine 4.4.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode unshaded, cull_back;

//void vertex() {
	////UV = UV * uv1_scale.xy + uv1_offset.xy;
//
	//// Billboard Mode: Enabled
	//MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			//MAIN_CAM_INV_VIEW_MATRIX[0],
			//MAIN_CAM_INV_VIEW_MATRIX[1],
			//MAIN_CAM_INV_VIEW_MATRIX[2],
			//MODEL_MATRIX[3]);
	//MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
//}

uniform sampler2D noise_tex: repeat_enable;

const float func_disp = 0.0225;
const float period_disp = 50.1;//46.5;

float energy(vec3 v){
	return (v.r + v.g + v.b) / 3.;
}

uniform float wind_dir = -1.;
const vec2 sprite_dims = vec2(128, 128);
void fragment() {
	vec2 _uv = 2. * UV - 1.;

	vec2 uv = sprite_dims * UV;//FRAGCOORD.xy;
	vec2 res = sprite_dims;//1.0 / SCREEN_PIXEL_SIZE;
	vec2 v = (2.*uv - res)/res.y;
	float t = 2. * TIME * wind_dir;
    float c = 5.;
	float tc = t * c;

	uv /= res * vec2(6.,1.2);
    uv.x -= tc * func_disp;
	uv.y += cos(uv.x * period_disp + tc) * .05;
	vec4 tex = texture(noise_tex, uv, 3.5);

	v /= 5.;
	v.x /= 2.;
	v.x -= tc * func_disp;
	//v.y += sin(uv.x * period_disp + tc) * .05;

	tex += texture(noise_tex, 2. * v - vec2(0.1 * TIME, 0.), 2.75)*.7;
	tex = smoothstep(tex+0.5, tex, vec4(.71));

	ALBEDO = 2. * vec3(1.);
	ALPHA = smoothstep(0., 1., 1. - length( _uv)) * smoothstep(0., 1., 1. - tex.r);
}
