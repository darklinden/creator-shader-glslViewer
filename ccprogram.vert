uniform mat4 u_viewMatrix;
uniform mat4 u_projectionMatrix;

attribute vec4 a_position;
attribute vec2 a_texcoord;

varying vec2 v_uv;

vec4 vert() {
    v_uv = a_texcoord;
    return u_projectionMatrix * u_viewMatrix * a_position;
}

void main() {
    gl_Position = vert();
}