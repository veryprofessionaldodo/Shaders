shader_type spatial;
render_mode cull_disabled;

uniform vec3 scale = vec3(0.0,0.0,0.0);
varying vec3 vertex_world_coords;

void vertex() {
	vertex_world_coords = VERTEX;
	//VERTEX.x += sin(TIME + VERTEX.y) * VERTEX.y;
}

void fragment() {
	
	ALBEDO = vec3(vertex_world_coords.y);
	
}