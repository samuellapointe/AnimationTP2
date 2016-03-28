//
//  corde.m
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-28.
//
//

#include "corde.h"

void CCorde::CreateCorde(double longeur, double transX, double transY){
    vertices.push_back(new CVertex(0, CPoint3D(transX,transY,0),0.0,0.0));
    vertices.push_back(new CVertex(1, CPoint3D(transX+longeur,transY,0),0.0,0.0));
    
    CVertex* v0 = vertices[0];
    CVertex* v1 = vertices[1];
    
    triangles.push_back(new CTriangle(v0,v1,v0));
    AllocVBOData();
}
