//
//  rectangle.mm
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#include "rectangle.h"

CRectangle::CRectangle(int tailleHorizontale, int tailleVerticale, int resolutionHorizontale, int resolutionVerticale) {
    CMesh();
    CreateRectangle(tailleHorizontale, tailleVerticale, resolutionHorizontale, resolutionVerticale);
    
}

void CRectangle::CreateRectangle(int sizeX, int sizeY, int resX, int resY) {
    //Taille du mesh
    int tailleVerticale = sizeX;
    int tailleHorizontale = sizeY;
    
    //Nombre de triangles
    int resolutionVerticale = resX;
    int resolutionHorizontale = resY;
    
    //Coins opposés, le centre est au point 0.
    CPoint3D depart = CPoint3D(-tailleHorizontale/2, 0, -tailleVerticale/2);
    CPoint3D arrivee = CPoint3D(tailleHorizontale/2, 0, tailleVerticale/2);
    
    for (int i = 0; i < resolutionVerticale; i++) {
        for (int j = 0; j < resolutionHorizontale; j++) {
            int index = resolutionVerticale*i + j;
            int x = depart[0] + ((arrivee[0]-depart[0])/(resolutionHorizontale-1))*j;
            int y = depart[1];
            int z = depart[2] + ((arrivee[2]-depart[2])/(resolutionVerticale-1))*i;
            vertices.push_back(new CVertex(index, CPoint3D(x, y, z), 0.0, 0.0));
        }
    }
    
    for (int i = 0; i < resolutionVerticale-1; i++) {
        for (int j = 0; j < resolutionHorizontale-1; j++) {
            int index = resolutionVerticale*i + j;
            
            CVertex* coinSupGauche = vertices[index];
            CVertex* coinSupDroit = vertices[index+1];
            CVertex* coinInfGauche = vertices[index+resolutionHorizontale];
            CVertex* coinInfDroit = vertices[index+resolutionHorizontale+1];
            
            if (index % 2 == 0) {
                triangles.push_back(new CTriangle(coinSupGauche, coinInfGauche, coinSupDroit));
                triangles.push_back(new CTriangle(coinSupDroit, coinInfGauche, coinInfDroit));
            } else {
                triangles.push_back(new CTriangle(coinSupGauche, coinInfGauche, coinInfDroit));
                triangles.push_back(new CTriangle(coinSupGauche, coinInfDroit, coinSupDroit));
            }
        }
    }
    
    
    UpdateNormals();
    AllocVBOData();
}