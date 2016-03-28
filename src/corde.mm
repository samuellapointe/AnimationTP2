//
//  corde.m
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-28.
//
//

#include "corde.h"
#define BUFFER_OFFSET(i) ((char *)NULL + (i))

void CCorde::CreateCorde(double longeur, double transX, double transY)
{
    vertices.push_back(new CVertex(0, CPoint3D(transX,transY,0),0.0,0.0));
    vertices.push_back(new CVertex(1, CPoint3D(longeur + transX,transY,0),0.0,0.0));
    
    AllocVBOData();
}

void CCorde::Draw(GLint prog)
{
    attrib_position = glGetAttribLocation(prog, "pos");
    glBindVertexArray(vao_id);
    
    glEnableVertexAttribArray(attrib_position);
    
    glBindBuffer(GL_ARRAY_BUFFER, ogl_buf_vextex_id);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ogl_buf_index_id);
    
    glVertexAttribPointer(attrib_position, 3, GL_FLOAT, GL_FALSE, vertex_data_size(), BUFFER_OFFSET(0));
    
    glDrawArrays(GL_LINES, 0, 2);
    
    glDisableVertexAttribArray(attrib_position);
}
