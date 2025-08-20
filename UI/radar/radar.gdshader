shader_type canvas_item;

mat2 rot( float t){
	return mat2( vec2( cos(t), -sin(t)),
	             vec2( sin(t), cos(t)));
}
float circ( vec2 uv, float r, float blur){
    return smoothstep(r, r + blur, length(uv));
}

const vec3 base_blue = vec3(0.2, 0.67, 0.95);
const vec3 ally_clickies_col = vec3(0.8, 0.9, 0.1);
const vec3 enemy_clickies_col = vec3(0.9, 0.1, 0.1);
const float TIME_TO_FADE = 2.5;

//uniform float angle;
uniform float awareness_radius;

uniform vec2 ally_clicky_positions[3];
uniform vec2 enemy_clicky_positions[4];

//5/27/25
uniform float angle;
void fragment()
{
	//float angle = tt * TAU;
    vec2 uv = 2. * UV - 1.;
    // ---------------------------------------------------------
    // clickies; accumulate mask before rotation
    // ---------------------------------------------------------
    //float allies_mask  = 0.;
    //float enemies_mask = 0.;
    // allies  [0, 1, 2]
    // enemies [0, 1, 2, 3]
    //allies_mask  = circ(uv - ally_clicky_positions[0] / awareness_radius, 0.025, 0.05);
    //enemies_mask = circ(uv - enemy_clicky_positions[0] / awareness_radius, 0.025, 0.05);

	// --
    //for (int i = 1; i < ally_clicky_positions.length(); i++)
	//{
		//allies_mask  *= circ(uv - (ally_clicky_positions[i] / awareness_radius), 0.025, 0.05);
		//enemies_mask *= circ(uv - (enemy_clicky_positions[i] / awareness_radius), 0.025, 0.05);
    //}

    // add last enemy index
    //enemies_mask *= circ(uv - (enemy_clicky_positions[3] / awareness_radius), 0.025, 0.05);

    // clamp mask to remove potential artifacts
    //allies_mask  = clamp( allies_mask, 0., 1.);
    //enemies_mask = clamp( enemies_mask, 0., 1.);

    // ---------------------------------------------------------
     // float zero_to_one = 0.5 * (sin( TIME - PI / 2.) + 1.);
    float offset = -PI / 2.0; // calculations on cpu side are done w.r.t Vector2.RIGHT
    float a = angle;          // this should only require sending the negative of the angle as a uniform
    a += offset;
    uv = rot(a) * uv;
    // ---------------------------------------------------------
    float _time = 0.5 * mod(TIME, TIME_TO_FADE); // wave animation param

    // ---------------------------------------------------------
    // the radar wave
    // ---------------------------------------------------------
    float outer_radius = clamp(_time, 0., 0.95);
    float inner_radius = outer_radius - (0.05 + 0.05 * _time);
    float outer_bluriness = 0.01;
    float inner_bluriness = outer_bluriness * 10. * _time + 0.05;
    float outer_ring = circ(uv, outer_radius, outer_bluriness);
    float inner_ring = circ(uv, inner_radius, inner_bluriness);
    float radar_mask = (1. - outer_ring) * inner_ring * max(0., (0.75 - _time / TIME_TO_FADE));

    // ---------------------------------------------------------
    // -- outer ring and inner circle
    // ---------------------------------------------------------
    float inner_circ = 1. - smoothstep(0.25, 0.27, length(uv));       // center circle
    float outside_ring_circ = circ(uv, 0.95, 0.04); //smoothstep(0.95, 0.99, length(uv));
    float outer_circ = clamp( 1.5 * (1. - outside_ring_circ) * circ(uv, 0.94, 0.03), 0., 1.);
    float circs_mask = outer_circ + inner_circ;

    float f = abs(1.44 * -uv.x);                         // function, 1.44 was coefficient picked from block out sprite
    float fov_mask = smoothstep(f, f + 0.01, uv.y);
    fov_mask *= (1. - outside_ring_circ);             // erase everything in this mask outside the circle
    fov_mask *= (1. - length(uv));                    // gradient;

    vec3 radar_col = base_blue * (fov_mask + circs_mask) + radar_mask;

    // **********
    //radar_col *= allies_mask * enemies_mask;
    // **********

    float alpha_mask = ((1. - outside_ring_circ) - outer_circ) * (1. - circs_mask);  // this is for the intermediate area between center and outside ring

    // COLOR = vec4( vec3(radar_col), (fov_mask + circs_mask) + radar_mask + alpha_mask);

    // **********
    vec3 col = radar_col; //+ (1. - allies_mask) * ally_clickies_col + (1. - enemies_mask) * enemy_clickies_col;
    // **********
    COLOR = vec4( col,(fov_mask + circs_mask) +
                      radar_mask +
		      0.35 * alpha_mask); // +
		      //(1. - allies_mask)  * (radar_mask + alpha_mask) +
		      //(1. - enemies_mask) * (radar_mask + alpha_mask));
    // COLOR = vec4( vec3(uv.x), 1.);
}
