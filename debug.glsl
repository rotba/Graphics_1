	// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
    vec4 a = vec4(0,0,5.0,2.88);
    vec4 b = vec4(0,0,0.0,10.0);
    float c = dot(a , b);
    if(c < 29.0) {
        //white
        gl_FragColor = vec4(1.0,1.0,1.0,1.0);
    }else{
        //black
        gl_FragColor = vec4(0.0,0.0,0.0,0.0);
    }

}