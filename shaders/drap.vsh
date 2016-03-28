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

float f(float x, float y, float t)
{
    float value = sin(2.9 * x + t) * cos(1.4 * y + 2*t) * 0.2;
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
    vec4 new = pos;
    
    //Texture
    var_texcoord = texcoord;

    //Lumiere
    var_light_pos = normal_matrix*light_pos;
    
    //Angle du drap
    float angle = pow(2, (-0.25 * pow((-5+2*mod(simulation_time, 5)), 2))) - 0.25;
    
    //Limiter la vague pour que le bas soit plus affecté
    float modifier = ((new.y - 1.5)/(3 - 1.5)) * ((angle + 0.2)/(0.8 - 0.2));
    new.z = -modifier * f(new.x, new.y, simulation_time);
    
    vec4 translationBeforeRotation = vec4(0.0, -1.5, 0.0, 0); // Fixe l'extrémité pour la rotation.
    new += translationBeforeRotation;
    new = rotate(new, angle); // On rotationne autour de l'origine avec une extrémité fixée.
    new -= translationBeforeRotation; // On replace le maillage comme avant sa translation (centré à l'origine).
    
    vec4 translationToPosition = vec4(0.0, 4.5, 0.0, 0);
    new += translationToPosition; // On monte le drap à sa bonne position.
    
    // Calcul du vecteur V et de la position finale
    vec4 position_deplacee = modelview_proj_matrix * new;
    V = vec3(modelview_matrix*position_deplacee);
    gl_Position = position_deplacee;
    
    // Calcul de la nouvelle normale
    vec3 fx = vec3(new.x+h, new.y, modifier * f(new.x+h, new.y, simulation_time));
    vec3 fy = vec3(new.x, new.y+h, modifier * f(new.x, new.y+h, simulation_time));
    N = cross(fx, fy);
}


