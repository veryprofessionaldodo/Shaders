shader_type spatial;

//render_mode cull_disabled;
render_mode world_vertex_coords;
//render_mode depth_test_disable;
render_mode unshaded;

uniform sampler2D ripples;
uniform float margin = 0.1;
uniform float stream_speed = 0.2;
uniform vec4 foamColor : hint_color;
uniform vec4 waterColor : hint_color;

const float zFar = 600.0;
const float zNear = 0.9;
// Intensity of the effect is multiplied by the proximity to border
const float proximityToBorder = 1.2f;

float linearize(float depth) {
	float z_n = 2.0 * depth - 1.0;
    return 2.0 * zNear * zFar / (zFar + zNear - z_n * (zFar - zNear));
}

void fragment() {
	// Test UVs
	
	float zdepth = linearize(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float zpos = linearize(FRAGCOORD.z);
	vec3 intersection = vec3(1.0-(zdepth-zpos)/2.0);
	intersection *= texture(ripples, vec2(UV.x, UV.y + TIME * stream_speed)).rgb;
	
	if (intersection.x > 0.0) {
		ALBEDO *= texture(ripples, vec2(UV.x, UV.y + TIME * stream_speed)).rgb;
	}
	//ALBEDO = vec3(FRAGCOORD.x);
	
	
	ALBEDO = mix(waterColor, foamColor, intersection.x).rgr;
	//ALBEDO = vec3(texture(DEPTH_TEXTURE, SCREEN_UV).r);
	
} 