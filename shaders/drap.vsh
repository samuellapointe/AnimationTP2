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

#define h 0.001

vec4 f(vec4 position, float t)
{
    vec4 value = vec4(position.x, (1*sin(position.x + t)) + position.y, position.z, position.w);
    return value;
}

void main (void)
{
    var_texcoord = texcoord;
    
    N = normalize(normal_matrix*N0);
    V = normalize(vec3(modelview_matrix*pos));
    var_light_pos = normal_matrix*light_pos;
    
    vec4 position_deplacee = modelview_proj_matrix*f(pos, simulation_time);
    gl_Position = position_deplacee;
    
    // Calcul de la nouvelle normale - Non fonctionnel
    vec4 fx = (f(vec4(pos.x + h, pos.y, 0, 0), simulation_time) - f(pos, simulation_time))/h;
    vec4 fy = (f(vec4(pos.x, pos.y + h, -100, 0), simulation_time) - f(pos, simulation_time))/h;
    N = normalize(cross(fx.xyz, fy.xyz));
}


