shader_type canvas_item;

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = 2. * UV - 1.;
	
	float vertical_rect = smoothstep(0., 0.05, sdBox(uv, vec2(0.1, 0.8)));
	float horizontal_rect = smoothstep(0., 0.05, sdBox(uv, vec2(0.8, 0.1)));
	float mask = vertical_rect * horizontal_rect;
	COLOR = vec4(vec3(1. - mask), 1.);
	//COLOR = vec4(vec3(), 1.);
	//COLOR = vec4(vec3(sdEllipse(vec2(uv.x, uv.x * uv.x), vec2(0.6, 0.1))), 1.);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
