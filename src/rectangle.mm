//
//  rectangle.mm
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#include "rectangle.h"

CRectangle::CRectangle(int sizeH, int sizeV, int resH, int resV) {
    CMesh();
    CreateRectangle(sizeH, sizeV, resH, resV);
    
}

void CRectangle::CreateRectangle(int sizeH, int sizeV, int resH, int resV) {
    //coins opposés, le centre est au point 0.
    CPoint3D depart = CPoint3D(-sizeH/2, 0, -sizeV/2);
    CPoint3D arrivee = CPoint3D(sizeH/2, 0, sizeV/2);
    
    //Pour chaque ligne de points
    for (int i = 0; i < resV; i++) {
        //Pour chaque point sur cette ligne
        for (int j = 0; j < resH; j++) {
            //Créer le sommer
            int index = resV*i + j;
            int x = depart[0] + ((arrivee[0]-depart[0])/(resH-1))*j;
            int y = depart[1];
            int z = depart[2] + ((arrivee[2]-depart[2])/(resV-1))*i;
            vertices.push_back(new CVertex(index, CPoint3D(x, y, z), 0.0, 0.0));
        }
    }
    
    //Pour chaque ligne, sauf la dernière
    for (int i = 0; i < resV-1; i++) {
        //Changer l'orientation de départ pour chaque ligne
        int orientation = i % 2;
        
        //Pour chaque point sur cette ligne, sauf le dernier
        for (int j = 0; j < resH-1; j++) {
            int index = resV*i + j;
            
            //Changer l'orientation pour chaque triangle
            int localOrientation = (orientation + j) % 2;
            
            //On fait un carré partant du point actuel jusqu'au point inferieur droit
            CVertex* cornerTopLeft = vertices[index];
            CVertex* cornerTopRight = vertices[index+1];
            CVertex* cornerBottomLeft = vertices[index+resH];
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