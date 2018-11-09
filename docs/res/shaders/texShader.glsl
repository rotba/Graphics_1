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
	int num_of_vecs = 20;
	vec4 average_vecs[] = calc_average_vec();
	gl_FragColor = time *morph_pixel(src_lines,average_vecs) + (1 - 1)*morph_pixel(src_lines, average_vecs);	
}

#Calculate the set of the "average" vectors of the current output picture
vec4[] calc_average_vec()
{
	int num_of_vecs = sizes[0];
    vec4 ans[num_of_vecs];
	for(int i=0; i<num_of_vecs; i++){
        ans[i] = interpolate_vecs(src_lines[i], dst_lines[i]);
    }
    return ans;
}

#ans is a avg vector src_line and dst_line
vec4 interpolate_vecs(vec4 src_line, vec4 dst_line)
{
	vec4 ans;
    ans[0] = time*src_line[0]+(1-time)dst_line[0];
    ans[1] = time*src_line[1]+(1-time)dst_line[1];
    ans[2] = time*src_line[2]+(1-time)dst_line[2];
    ans[3] = time*src_line[3]+(1-time)dst_line[3];
    return ans;
}
#ans is a avg vector src_line and dst_line
vec4 morph_pixel(vec4 src_line, vec4 average_vecs)
{
    int num_of_vecs = sizes[0];
	vec2 uv_array[num_of_vecs];
    for(int i=0; i<num_of_vecs]; i++){
        vec2 uv_i;
        uv_i[0] =average_vecs[0]-average_vecs[2]
        uv_array[i] = uv_i;
    }
    
    return ans;
}