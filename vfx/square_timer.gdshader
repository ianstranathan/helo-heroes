shader_type canvas_item;


void vertex() {
	// Called for every vertex the material is visible on.
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}
float rect_ring_sdf(vec2 uv, vec2 bd, float t)
{
	return abs(sdBox(uv, bd)) - t;
}

uniform float progress: hint_range(0.0, 1.0, 0.1);
void fragment() {
	vec2 uv = 2. * UV - 1.;
	//float r = 0.78;
	float _ring_thickness = 0.05;
	float _timer_mask = 1. - smoothstep(0., 0.03, rect_ring_sdf(uv, vec2(0.9), _ring_thickness));
	//float fuel_mask = 1. - smoothstep(0., 0.03, ring_sdf(uv, r + 0.15, _ring_thickness / 2.0));
//
	vec2 progress_uv = 2. * UV - 1.;
	float theta = atan(progress_uv.y, progress_uv.x) / PI; // [-1., 1.]
	theta = 0.5 * (theta + 1.0);
	float progress_mask = 1. - smoothstep(progress, progress + 0.005, theta);
	
	_timer_mask *= progress_mask;
	
	COLOR = vec4(vec3(_timer_mask), 1.);
}
