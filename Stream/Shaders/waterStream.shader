shader_type spatial;

//render_mode cull_disabled;
render_mode world_vertex_coords;
//render_mode depth_test_disable;
render_mode unshaded;

uniform sampler2D ripples;
uniform sampler2D offsetUv;
uniform float margin = 0.1;
uniform float stream_speed = 0.4;
uniform vec4 foamColor : hint_color;
uniform vec4 waterColor : hint_color;
uniform vec2 distortionIntensity = vec2(0.1,0.3);

const float zFar = 600.0;
const float zNear = 0.8;
// Intensity of the effect is multiplied by the proximity to border
const float proximityToBorder = 1.2f;

float linearize(float depth) {

	depth = 2.0 * depth - 1.0;
    return 2.0 * zNear * zFar / (zFar + zNear - depth * (zFar - zNear));
}

vec2 bandEffect(vec2 src, float bands) {
	return vec2(floor(src.x*bands)/bands, floor(src.y*bands)/bands);
}
/*
vec3 bandEffect(vec3 src, float bands) {
	return vec3(floor(src.x*bands)/bands, floor(src.y*bands)/bands, floor(src.z*bands)/bands);
}
*/

void fragment() {
	vec2 textureOffset = texture(offsetUv, vec2(UV.x, UV.y + TIME * (stream_speed * 2.0))).rg;
	// Convert grayscale texture to red/green texture
	textureOffset = mix(vec2(1.0,0.0),vec2(0.0,1.0), textureOffset.x).rg;
	// Make it in the -1 to 1 range
	textureOffset = textureOffset * 2.0 - 1.0;
	// Distort based on intensity
	textureOffset *= distortionIntensity;
	// Banding effect
	//textureOffset = bandEffect(textureOffset, 10.0);
	
	// Get depth information	
	float zdepth = linearize(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	float zpos = linearize(FRAGCOORD.z);
	float intersection = 1.0-(zdepth-zpos)/2.0;
	
	// Base color is depth information
	vec3 color = mix(vec3(waterColor.rgb), vec3(foamColor.r,foamColor.g,foamColor.b), smoothstep(0.0,0.5,intersection)).rgb;
	
	// Add ripples	
	color *= texture(ripples, vec2(UV.x + textureOffset.x, UV.y + TIME * stream_speed + textureOffset.y)).rgb;
	// Banding effect
	//ripplesColor = bandEffect(ripplesColor, 10.0);
	//color *= ripplesColor.rgb;
	//color = mix(vec3(waterColor.rgb), vec3(foamColor.r,foamColor.g,foamColor.b), step(0.5,color)).rgb;
	
	// Distort 
	//color += texture(offsetUv, vec2(UV.x + textureOffset.x , UV.y + TIME * textureOffset.y)).rgb;
	ALBEDO = color;
	
	//ALBEDO = mix(vec3(waterColor.rgb), vec3(foamColor.rgb), color).rgb;
	//ALBEDO = vec3(texture(DEPTH_TEXTURE, SCREEN_UV).r);
	
} 