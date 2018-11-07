#version 330 

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float time;
uniform vec4 coeffs;
uniform vec4 src_lines[20];
uniform vec4 dst_lines[20];
uniform ivec4 sizes; 

in vec2 uv;
in vec3 position1;



void main()
{
	gl_FragColor = time *texture(texture1,uv ) + (1 - 1)*texture(texture2,uv);	
}

