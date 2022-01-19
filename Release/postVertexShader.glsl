#version 330

in vec3 inPoint;
in vec2 inCoord;

uniform float shade_type;

out vec2 coord;

void main()
{
	coord = inCoord;
	gl_Position = vec4(inPoint, 1.0);
}
