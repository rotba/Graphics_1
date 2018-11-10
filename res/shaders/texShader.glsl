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
vec4 morph_pixel(vec4 orig_lines[], vec4 average_vecs[])
{
    int num_of_vecs = sizes[0];
	vec2 dsum;
    float weightsum = 0;
    float a = coeffs[1];
    float b = coeffs[2];
    float p = coeffs[3];
    for(int i=0; i<num_of_vecs]; i++){
        vec2 q_i=vec2(average_vecs[i][0],average_vecs[i][1]);
    	vec2 p_i=vec2(average_vecs[i][2],average_vecs[i][3]);
        float u_i=((uv-p_i)*(q_i-p_i))/(pow((q_i[0]-p_i[0]),2)+pow((q_i[1]-p_i[1]),2));
        float v_i=((uv-p_i)*perpendicular(q_i-p_i))/(sqrt( pow(q_i[0]-p_i[0],2) + pow((q_i[1]-p_i[1]),2)));
        uv_i[0] =()
		vec2 displacment_i = vec2(uv.x-x_i_tag.x, uv.y-x_i_tag.y);
        float dist_i = calc_dist_point_vec(uv, orig_lines[i]); 
		//problem
        float length_i = distance(orig_lines[i].xy,orig_lines[i].zw);
		//problem
        float weight_i = pow(pow(length_i,p)/(a+dist_i),b);
        dsum = dsum + displacment_i*weight;
        weightsum = weightsum + weight;
     
    }
    return uv+dsum/weightsum;
}

# Returns the perpendicular vector to pq
vec4 perpendicular(vec4 pq)
{
    float b_leg=pq[2]=pq[0];
    float hypo=distance(pq.xy,pq.zw);
    float cos_teta=b_leg/hypo;
    float teta=acos(cos_teta);
    float teta_ans=teta-90.0;
    float x=cos(teta_ans)*hypo+pq[0];
    float y=cos(teta_ans)*hypo+pq[1]; 
    return vec4(pq[0],pq[1],x,y);
}