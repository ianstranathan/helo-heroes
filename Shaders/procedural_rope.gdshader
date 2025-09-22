shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float plot(vec2 st, float pct, float th){
  return  smoothstep( pct-th, pct, st.y) -
          smoothstep( pct, pct+th, st.y);
}

uniform vec4 lighter_col: source_color;
uniform vec4 darker_col: source_color;
void fragment() {
	vec2 uv = 2. * UV - 1.;
	uv.y *= -1.;
	uv.y = asin(uv.y);
	float fn = uv.x;
	float mask = plot(fract(uv) - 0.5, fn, 0.1);
	COLOR = vec4(vec3(mask), 1.);
	//COLOR = vec4(vec3(length(uv)), 1.);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
