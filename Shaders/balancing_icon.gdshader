shader_type spatial;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float within = 1.0;

void fragment() {
	vec2 uv = 2. * UV - 1.;
	uv *= 0.95;
	float bg_alpha_square = 1. - smoothstep(0., 0.01, sdBox(uv, vec2(0.875, 0.875)));
	
	float mask_d = abs(sdBox(uv, vec2(0.875, 0.875))) - 0.05;
	float mask = 1. - smoothstep(0., 0.01, mask_d);
	float rails = 1. - smoothstep(0., 0.01, sdBox(fract(10. * uv) - vec2(0.5), vec2(0.25, 0.25)));
	
	vec3 col = step(0.1, within) * vec3(0., 1., 0.) + (1. - step(0.1, within)) * vec3(1., 0., 0.);
	
	float perforated = mask * rails;
	float _alpha = 0.33 * (1. - perforated) + 1.0 * perforated;
	ALBEDO = 2. * col * bg_alpha_square;
	ALPHA = _alpha * bg_alpha_square;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
