shader_type spatial;
render_mode cull_disabled;
render_mode world_vertex_coords;

uniform float wind;
uniform sampler2D noise; 

vec2 displacement(vec2 pos) {
	//pos.x = pos.x;
	pos.y += abs(1.0f/(pos.x/5.0f +1.0f)) - 0.8f;
	return pos;
}

void vertex() {
	//VERTEX.xy = displacement(VERTEX.xy);
}

void fragment() {
	// Foam 
	
	// Stripes 
	//ALBEDO = UV.;
	ALBEDO = texture(noise, UV + vec2(TIME,0)).rgb + WORLD_MATRIX[0].xyz * VERTEX.xyz;
	//ALBEDO = texture(noise, UV + vec2(TIME,0)).rgb;	
}

