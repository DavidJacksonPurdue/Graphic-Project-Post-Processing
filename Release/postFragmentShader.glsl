// Blur example adapted from 
// - https://github.com/Overv/Open.GL/blob/master/content/articles-en/framebuffers.md

#version 330

in vec2 coord;

uniform float shade_type;
uniform sampler2D textureData;        

vec4 blur() {
	float depth = texture(textureData, coord).a;
	vec4 sum = vec4(0.0);
	float blurSizeH = (depth * depth * depth) / 170.0 ; //Only need horizontal blur because box only move horizontally
	for (int x = -4; x <= 4; x++) 
	{
		for (int y = -4; y <= 4; y++) 
		{
			sum += texture(textureData, vec2(coord.x + x * blurSizeH, coord.y)) / (81);
		}
	}
	return sum;
}

vec4 sepia() {
	vec4 inputcolor = texture(textureData, coord);
	inputcolor.x = (inputcolor.x * 0.393) + (inputcolor.y * 0.769) + (inputcolor.z * 0.189);
	inputcolor.y = (inputcolor.x * 0.349) + (inputcolor.y * 0.686) + (inputcolor.z * 0.168);
	inputcolor.z = (inputcolor.x * 0.272) + (inputcolor.y * 0.543) + (inputcolor.z * 0.131);
	return inputcolor;
}

vec4 swirl() {
	vec2 cent = vec2(0.5, 0.5);
	float dist = abs(distance(coord, cent));
	float angle = 3.1415926535897932384626/(0.1 + 720 * dist * dist);
	if (dist <= 0.5) {
		vec2 coordplus = vec2((cent.x + (coord.x - cent.x) * cos(angle) - (coord.y - cent.y) * sin(angle)), (cent.y + (coord.x - cent.x) * sin(angle) + (coord.y - cent.y) * cos(angle)));
		return texture(textureData, coordplus);
	}
	else {
		return texture(textureData, coord);
	}
}

vec4 sketch() {
	mat3 kernel = mat3(0, -1, 0, -1, 8, -1, 0, -1, 0);
	vec4[9] region;
	region[0] = texture(textureData, coord + vec2(-2, -2));
	region[1] = texture(textureData, coord + vec2(0, -2));
	region[2] = texture(textureData, coord + vec2(2, -2));
	region[3] = texture(textureData, coord + vec2(-2, 0));
	region[4] = texture(textureData, coord + vec2(0, 0));
	region[5] = texture(textureData, coord + vec2(2, 0));
	region[6] = texture(textureData, coord + vec2(-2, 2));
	region[7] = texture(textureData, coord + vec2(0, 2));
	region[8] = texture(textureData, coord + vec2(2, 2));
	mat3[3] matrixRegion;
	for (int i = 0; i < 3; i++) {
		matrixRegion[i] = mat3(region[0][i], region[1][i], region[2][i], region[3][i], region[4][i], 
							   region[5][i], region[6][i], region[7][i], region[8][i]);
	}
	vec4 final_color;
	for (int i = 0; i < 3; i++) {
		mat3 color_channel = matrixCompMult(kernel, matrixRegion[i]);
		float val = color_channel[0][0] + color_channel[1][0] + color_channel[2][0] + color_channel[0][1] +
					color_channel[1][1] + color_channel[2][1] + color_channel[0][2] + color_channel[1][2] + color_channel[2][2];
		final_color[i] = val;
	}
	final_color.x = final_color.x;
	final_color.y = final_color.y;
	final_color.z = final_color.z;
	//This turns background white
	if (final_color.x == 0) {
		final_color.x = 1;
	}
	if (final_color.y == 0) {
		final_color.y = 1;
	}
	if (final_color.z == 0) {
		final_color.z = 1;
	}
	//This normalizes colors to be exclusively black and white
	if (final_color.x < 0.34 || final_color.y < 0.34 || final_color.z < 0.34) {
		final_color.x = 0;
		final_color.y = 0;
		final_color.z = 0;
	}
	else {
		final_color.x = 1;
		final_color.y = 1;
		final_color.z = 1;
	}
	final_color.a = 1.0;
	return final_color;
}

void main()
{
	if (shade_type == 1) {
		gl_FragColor = sepia();
		gl_FragColor.a = 1.0;
	}
	else if (shade_type == 2) {
		gl_FragColor = blur();
		gl_FragColor.a = 1.0;
	}
	else if (shade_type == 3) {
		gl_FragColor = swirl();
		gl_FragColor.a = 1.0;
	}
	else if (shade_type == 4) {
		gl_FragColor = sketch();
	}
	else {
		gl_FragColor = texture(textureData, coord);
		gl_FragColor.a = 1.0;
	}
}
