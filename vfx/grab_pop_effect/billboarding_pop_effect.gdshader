// NOTE: Shader automatically converted from Godot Engine 4.4.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode unshaded, cull_back;

uniform float t: hint_range(0.0, 1.0, 0.01);
uniform float _vertex_scale = 1.0;
void vertex()
{
	VERTEX.xy *= _vertex_scale;
	// Billboard Mode: Enabled
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
			MAIN_CAM_INV_VIEW_MATRIX[0],
			MAIN_CAM_INV_VIEW_MATRIX[1],
			MAIN_CAM_INV_VIEW_MATRIX[2],
			MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

//float ring(float domain, float _thickness, float inner_rad)
//{
	//float _outer_rad = inner_rad + _thickness;
	//float mask = (1. -  smoothstep(_outer_rad, _outer_rad + 0.03, domain))
	             //* smoothstep(inner_rad, inner_rad + 0.03, domain);
	//return mask;
//}

float EaseInSine(float x)
{
    return 1.0 - cos((x * PI) / 2.0);
}
float EaseOutSine(float x)
{
    return sin((x * PI) / 2.0);
}
float EaseInQuad(float x)
{
   return x * x;
}
float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

float ring_sdf(vec2 p, float r)
{
	return abs(sdCircle(p, r) - r);
}
float ring(vec2 uv, float r, float thickness){
	return 1. - smoothstep(thickness, thickness + 0.01, ring_sdf(uv, r));
}
void fragment()
{
	vec2 uv = 2. * UV - 1.;
	float mask = ring(uv, EaseOutSine(t), 0.15);
	ALBEDO = vec3(1.5);
	ALPHA = 1. - smoothstep(0.95, 0.97, length(uv));
	ALPHA *= mask * 0.7; // just want a little transparency
}
