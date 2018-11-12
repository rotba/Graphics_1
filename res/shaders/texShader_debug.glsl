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

#define MAX_NUM_OF_VECS 20
#define DEBUG false 

vec4[MAX_NUM_OF_VECS] calc_average_vec();
vec4 interpolate_vecs(vec4 src_line, vec4 dst_line);
vec2 morph_pixel(vec4 orig_lines[MAX_NUM_OF_VECS], vec4 average_vecs[MAX_NUM_OF_VECS]);
vec2 perpendicular(vec2 pq);
float calc_dist_point_line(vec2 point, vec4 line, float u, float v);
vec4[MAX_NUM_OF_VECS] convert_to_normalized(vec4[MAX_NUM_OF_VECS] lines);


void main()
{
	if(DEBUG && false){
		if( sizes[2] ==195.0 ){
			//success - green
			gl_FragColor = vec4(0.0,1.0,0.0,0.0);
		}else{
			//fail - red
			gl_FragColor = vec4(1.0,0.0,0.0,0.0);
		}
	}
	vec4 average_vecs[] = calc_average_vec();
	vec4 normed_src_lines[] = convert_to_normalized(src_lines);
	vec4 normed_dst_lines[] = convert_to_normalized(dst_lines);
	vec4 normed_average_vecs[] = convert_to_normalized(average_vecs);
	if(DEBUG && false){
		if( (80.0/195.0 < normed_src_lines[0].x && normed_src_lines[0].x < 90.0/195.0) &&
			(160.0/228.0 < normed_src_lines[0].y && normed_src_lines[0].y < 170.0/228.0)){
			//success - green
			gl_FragColor = vec4(0.0,1.0,0.0,0.0);
		}else{
			//fail - red
			gl_FragColor = vec4(1.0,0.0,0.0,0.0);
		}
	}
	//checks the normalized average vector
	if(DEBUG && false){
		if( (78.0/195.0 < normed_average_vecs[0].x && normed_average_vecs[0].x < 80.0/195.0) 
			&&(167.0/228.0 < normed_average_vecs[0].y && normed_average_vecs[0].y < 170.0/228.0)
			&&(127.0/195.0 < normed_average_vecs[0].z && normed_average_vecs[0].z < 129.0/195.0)
			&&(164.0/228.0 < normed_average_vecs[0].w && normed_average_vecs[0].w < 166.0/228.0)
			){
			//success - green
			gl_FragColor = vec4(0.0,1.0,0.0,0.0);
		}else{
			//fail - red
			gl_FragColor = vec4(1.0,0.0,0.0,0.0);
		}
	}
	vec2 x_src=morph_pixel(normed_src_lines,normed_average_vecs);
	vec2 x_dst=morph_pixel(normed_dst_lines, normed_average_vecs);
	gl_FragColor = time *texture(texture1,x_dst ) + (1-time)*texture(texture2,x_src);	
}

//Calculate the set of the "average" vectors of the current output picture
vec4[MAX_NUM_OF_VECS] calc_average_vec()
{
	if(DEBUG && false){
		if(sizes[0]!= 2){
			gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		}else{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
	}
	int num_of_vecs = int(coeffs[0]);
    vec4 ans[MAX_NUM_OF_VECS];
	for(int i=0; i<num_of_vecs; i++){
        ans[i] = interpolate_vecs(src_lines[i], dst_lines[i]);
    }
	if(DEBUG && false){
		if(ans[0].x!= 100.0){
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}else if(ans[0].y!= 10.0){
			gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		}else if(ans[0].z!= 100.0){
			gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		}else if(ans[0].w!= 100.0){
			gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		}else{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
	}
	return ans;
}

//ans is a avg vector src_line and dst_line
vec4 interpolate_vecs(vec4 src_line, vec4 dst_line)
{
	if(DEBUG && false){
		if(src_line.x!= 80.0){
			gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		}else if(dst_line.x!= 120.0){
			gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		//}else if(time!=0.5){
			//gl_FragColor = vec4(0.0,0.0,0.0,0.0);
		}else{
			gl_FragColor = vec4(1.0,1.0,1.0,1.0);
		}
	}
	
	vec4 ans;
    ans[0] = time*src_line[0]+(1-time)*dst_line[0];
    ans[1] = time*src_line[1]+(1-time)*dst_line[1];
    ans[2] = time*src_line[2]+(1-time)*dst_line[2];
    ans[3] = time*src_line[3]+(1-time)*dst_line[3];
    return ans;
}
//ans is a avg vector src_line and dst_line
vec2 morph_pixel(vec4 orig_lines[MAX_NUM_OF_VECS], vec4 average_vecs[MAX_NUM_OF_VECS])
{
    int num_of_vecs = int(coeffs[0]);
	vec2 dsum = vec2(0.0, 0.0);
    float weightsum = 0;
    float a = coeffs[1];
    float b = coeffs[2];
    float p = coeffs[3];
    for(int i=0; i<num_of_vecs; i++){
        vec2 q_i=vec2(average_vecs[i][0],average_vecs[i][1]);
    	vec2 p_i=vec2(average_vecs[i][2],average_vecs[i][3]);
        vec2 p_i_tag= vec2(orig_lines[i][2],orig_lines[i][3]);
        vec2 q_i_tag= vec2(orig_lines[i][0],orig_lines[i][1]);
        float u_i=(dot((uv-p_i),(q_i-p_i)))/(pow((q_i[0]-p_i[0]),2)+pow((q_i[1]-p_i[1]),2));
        float v_i=( dot( (uv-p_i) , perpendicular(q_i-p_i) ))/( sqrt( pow(q_i[0]-p_i[0],2) + pow((q_i[1]-p_i[1]),2) ) );
        vec2 x_i_tag = p_i_tag + u_i*(q_i_tag-p_i_tag) + (v_i*perpendicular(q_i_tag-p_i_tag))/(sqrt(pow(q_i[0]-p_i[0],2) + pow((q_i[1]-p_i[1]),2)));
		vec2 displacment_i = x_i_tag-uv;
        float dist_i = calc_dist_point_line(uv, average_vecs[i], u_i, v_i); 
        float length_i = distance(average_vecs[i].xy,average_vecs[i].zw);
        float weight_i = pow(pow(length_i,p)/(a+dist_i),b);
        dsum = dsum + displacment_i*weight_i;
        weightsum = weightsum + weight_i;
    }
    return uv+dsum/weightsum;
}

//Returns the perpendicular vector to pq
vec2 perpendicular(vec2 pq)
{
    vec3 pq_3d = vec3(pq.x, pq.y, 0.0);
    vec3 z = vec3(0.0, 0.0, 1.0);
    vec3 perp = cross(pq_3d, z);
    return perp.xy;
}

//Returns the perpendicular vector to pq
vec4 perpendicular_complicated(vec4 pq)
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

//Calculates the shortest distance between point and line
float calc_dist_point_line(vec2 point, vec4 line, float u, float v)
{
	float ans;
	if(u > 1){
		ans = distance(point, line.zw);
	}else if(u >0 && u < 1){
		ans  = v;
	}else{
		ans = distance(point, line.xy);
	}
	return ans;
}

//Transforms lines to be normalized by the size of the frame to be between 0 to 1
vec4[MAX_NUM_OF_VECS] convert_to_normalized(vec4[MAX_NUM_OF_VECS] lines)
{
	int num_of_vecs = int(coeffs[0]);;
	vec4 ans[MAX_NUM_OF_VECS];
	for(int i=0; i<num_of_vecs; i++){
        ans[i][0] = (lines[i][0]-1)/(sizes[2]-1);
		ans[i][1] = (lines[i][1]-1)/(sizes[3]-1);
		ans[i][2] = (lines[i][2]-1)/(sizes[2]-1);
		ans[i][3] = (lines[i][3]-1)/(sizes[3]-1);
    }
	
	return ans;
}