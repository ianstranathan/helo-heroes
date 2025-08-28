shader_type canvas_item;

mat2 rot( float t){
	return mat2( vec2( cos(t), -sin(t)),
	             vec2( sin(t), cos(t)));
}
float circ( vec2 uv, float r, float blur){
    return smoothstep(r, r + blur, length(uv));
}

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}
float ring_sdf(vec2 uv, float r, float t)
{
	return abs(sdCircle(uv, r)) - t;
}
//float ring(vec2 uv, float r, float thickness){
	//return 1. - smoothstep(thickness, thickness + 0.01, ring_sdf(uv, r));
//}
const vec3 base_blue = vec3(0.2, 0.67, 0.95);
uniform float awareness_radius;
uniform float angle;

uniform float progress: hint_range(0.0, 1.0, 0.1) = 1.0;
void fragment()
{
    vec2 uv = 2. * UV - 1.;
    float offset = -PI / 2.0; // calculations on cpu side are done w.r.t Vector2.RIGHT
    float a = angle;          // this should only require sending the negative of the angle as a uniform
    a += offset;
    uv = rot(a) * uv;
    // ---------------------------------------------------------
    // common
    // ---------------------------------------------------------
	float r = 0.78; // just playing around, trying to make it fit on UV
    // ---------------------------------------------------------
    // the radar wave
    // ---------------------------------------------------------
	float w_r  = mod(0.4 * TIME, r);// the waves radius
	float w = smoothstep(w_r, w_r + 0.1, length(uv)) * (1. - smoothstep(w_r + 0.09, w_r + 0.1, length(uv)));

    // ---------------------------------------------------------
    // -- outer ring and inner circle
    // ---------------------------------------------------------
	float inner_circ_rad = 0.15;
    float inner_circ = 1. - smoothstep(inner_circ_rad, inner_circ_rad + 0.02, length(uv));       // center circle
    float outside_ring_circ = circ(uv, r, 0.04);
    float outer_circ = clamp( 1.5 * (1. - outside_ring_circ) * circ(uv, r - 0.01, 0.03), 0., 1.);
    float circs_mask = outer_circ + inner_circ;

    float f = abs(1.44 * -uv.x);                      // abs(1.44x) looks ok in desmos
    float fov_mask = smoothstep(f, f + 0.01, uv.y);
    fov_mask *= (1. - outside_ring_circ);             // erase everything in this mask outside the circle
    fov_mask *= (1. - length(uv));                    // gradient;


    float alpha_mask = ((1. - outside_ring_circ) - outer_circ) * (1. - circs_mask);  // this is for the intermediate area between center and outside ring
    w *= alpha_mask;
	vec3 col = base_blue * (fov_mask + circs_mask) + 0.8 *w;

    COLOR = vec4( col,(fov_mask + circs_mask) +
                      w +
		     		 0.35 * alpha_mask);

	float _ring_thickness = 0.1;
	float fuel_mask = 1. - smoothstep(0., 0.03, ring_sdf(uv, r + 0.15, _ring_thickness / 2.0));

	vec2 progress_uv = 2. * UV - 1.;
	float theta = atan(progress_uv.y, progress_uv.x) / PI; // [-1., 1.]
	// we want it to go to [0., 1.]
	// add one |-> [0., 2.]
	// divide by two
	// for future me: uv.x was made negative to switch atan
	// and theta was made negative to switch sides
	theta = 0.5 * (theta + 1.0);
	float progress_mask = 1. - smoothstep(progress, progress + 0.005, theta);
	//COLOR = vec4(vec3(fuel_mask * progress_mask), 1.);
	fuel_mask *= progress_mask;

	// sin func is just to give some blinking
	vec3 progress_col = mix(vec3(1., 0., 0.) + 0.7 * abs(sin(TIME * 1./ ( 0.5 * (progress + 0.1)))),
							vec3(0., 0.6 + progress, 0.),
							progress);
	// step func is just to clear the alpha when it's really close to zero (otherwise)
	// you have a small residual slice
	COLOR += vec4(progress_col * fuel_mask, fuel_mask * step(0.01, progress));
}
