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

#define h = 0.00001

vec4 f(vec4 position, float t)
{
    vec4 value = vec4(position.x, (0.1*sin(position.x + t)) + position.y, position.z, position.w);
    return value;
}

void main (void)
{
    var_texcoord = texcoord;
    
    N = normalize(normal_matrix*N0);
    V = normalize(vec3(modelview_matrix*pos));
    var_light_pos = normal_matrix*light_pos;
    
    vec4 position_deplacee = modelview_proj_matrix*pos;
    gl_Position	= f(position_deplacee, simulation_time);
    
    // Calcul de la nouvelle normale - Non fonctionnel
    /*vec4 fx = (f(vec4(position_deplacee.x + h, position_deplacee.y, position_deplacee.z, position_deplacee.w), simulation_time) - f(position_deplacee, simulation_time))/h;
    vec4 fy = (f(vec4(position_deplacee.x, position_deplacee.y + h, position_deplacee.z, position_deplacee.w), simulation_time) - f(position_deplacee, simulation_time))/h;
    N = cross(fx, fy);*/
}


