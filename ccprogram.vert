uniform mat4 u_viewMatrix;
uniform mat4 u_projectionMatrix;

attribute vec4 a_position;

varying vec2 v_uv;

#define decimation(value, presicion) (floor(value * presicion)/presicion)

vec4 vert() {
    v_uv = a_position.xy;
    return u_projectionMatrix * u_viewMatrix * a_position;
}

void main() {
    gl_Position = vert();
}