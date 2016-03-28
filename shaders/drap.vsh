#version 410

uniform mat4 modelview_proj_matrix;
uniform mat4 modelview_matrix;

uniform mat3 normal_matrix;
uniform vec3 light_pos;
uniform vec3 cam_pos;

uniform float simulation_time;

in vec4     pos;
in vec2     texcoord;
in vec3     N0;

out vec2 var_texcoord;

out vec3 N;
out vec3 V;
out vec3 var_light_pos;

#define h 0.0001

/*
vec4 f(vec4 position, float t)
{
    vec4 value = vec4(position.x, (1*sin(position.x + t)) + position.y, position.z, position.w);
    return value;
}
*/
float f(float x, float y, float t)
{
    float value = 1*sin(x + t) + y;
    return value;
}
vec4 rotate(vec4 position, float angle)
{
    mat4 rotation;
    rotation[0] = vec4(1.0, 0.0, 0.0, 0.0);
    rotation[1] = vec4(0, cos(angle), sin(angle), 0);
    rotation[2] = vec4(0, -sin(angle), cos(angle), 0);
    rotation[3] = vec4(0, 0, 0, 1);
    
    position = position * rotation;
    return position;
}

void main (void)
{
    var_texcoord = texcoord;
    
    N = normalize(normal_matrix*N0);
    V = normalize(vec3(modelview_matrix*pos));
    var_light_pos = normal_matrix*light_pos;
    
    float angle = -pow(2, (-0.25 * pow((-5+2*simulation_time), 2))) - 0.25;
    
    vec4 position_deplacee = modelview_proj_matrix*rotate(pos, angle) + vec4(0, f(pos.x, pos.y, simulation_time), 0, 0);
    gl_Position = position_deplacee;
    
    V = normalize(vec3(modelview_matrix*position_deplacee));
    
    // Calcul de la nouvelle normale - Non fonctionnel
    vec4 fx = vec4(f(pos.x + h, pos.y, simulation_time), 1, 1, 0);
    vec4 fy = vec4(1, f(pos.x, pos.y + h, simulation_time), 1, 0);
    //vec4 fx = (f(vec4(pos.x + h, pos.y, pos.z, 0), simulation_time) - f(pos, simulation_time))/h;
    //vec4 fy = (f(vec4(pos.x, pos.y + h, pos.z, 0), simulation_time) - f(pos, simulation_time))/h;
    N = normalize(N + cross(fx.xyz, fy.xyz));
}


