//
//  drap.mm
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#include "drap.h"


void CDrap::CreateDrap() {
    //coins opposés
    CPoint3D depart = CPoint3D(-2, 6, 0);
    CPoint3D arrivee = CPoint3D(2, 3, 0);
    int resV = 40;
    int resH = 30;
    
    float xmin = HUGE_VAL, xmax = -HUGE_VAL, ymin = HUGE_VAL, ymax=-HUGE_VAL;
    
    //Pour chaque ligne de points
    for (int i = 0; i < resV; i++) {
        //Pour chaque point sur cette ligne
        for (int j = 0; j < resH; j++) {
            //Créer le sommet
            int index = resH*i + j;
            float x = depart[0] + ((arrivee[0]-depart[0])/(resH-1))*j;
            float y = depart[1] + ((arrivee[1]-depart[1])/(resV-1))*i;
            float z = depart[2];
            vertices.push_back(new CVertex(index, CPoint3D(x, y, z), 0.0, 0.0));
            
            if ( xmin > x ) xmin = x;
            if ( ymin > y ) ymin = y;
            if ( xmax < x ) xmax = x;
            if ( ymax < y ) ymax = y;
        }
    }
    
    // Coordonnées uv de base.
    for (int i=0; i<vertices.size(); i++ )
    {
        float x = 0.0;
        float y = 0.0;

        x = (*vertices[i])[0];
        y = (*vertices[i])[1];

        
        float u = (x-xmin)/(xmax - xmin);
        float v = (y-ymin)/(ymax - ymin);
        
        vertices[i]->u = u;
        vertices[i]->v = v;
    }
    
    //Pour chaque ligne, sauf la dernière
    for (int i = 0; i < resV-1; i++) {
        //Changer l'orientation de départ pour chaque ligne
        int orientation = i % 2;
        
        //Pour chaque point sur cette ligne, sauf le dernier
        for (int j = 0; j < resH-1; j++) {
            int index = resH*i + j;
            
            //Changer l'orientation pour chaque triangle
            int localOrientation = (orientation + j) % 2;
            
            //On fait un carré partant du point actuel jusqu'au point inferieur droit
            
            CVertex* cornerTopLeft = vertices[index];
            CVertex* cornerTopRight = vertices[index+1];
            CVertex* cornerBottomLeft = vertices[index+resH+0];
            CVertex* cornerBottomRight = vertices[index+resH+1];
            
            //Composé de deux triangles, orientation variante
            if (localOrientation == 0) {
                triangles.push_back(new CTriangle(cornerTopLeft, cornerBottomLeft, cornerTopRight));
                triangles.push_back(new CTriangle(cornerTopRight, cornerBottomLeft, cornerBottomRight));
            } else {
                triangles.push_back(new CTriangle(cornerTopLeft, cornerBottomLeft, cornerBottomRight));
                triangles.push_back(new CTriangle(cornerTopLeft, cornerBottomRight, cornerTopRight));
            }
            
        }
    }
    
    
    UpdateNormals();
    AllocVBOData();
}