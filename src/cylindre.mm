//
//  cylindre.m
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#include "cylindre.h"
#include "math.h"

CCylindre::CCylindre(double hauteur, double rayon, int nbCote, double transX, double transY, double transZ){
    CMesh();
    CreateCylindre(hauteur, rayon, nbCote, transX, transY, transZ);
}

void CCylindre::CreateCylindre(double hauteur, double rayon, int nbCote, double transX, double transY, double transZ){
    CPoint3D pointMilieuHaut = CPoint3D(transX,hauteur+transY,transZ);
    CPoint3D pointMilieuBas = CPoint3D(transX,transY,transZ);
    
    //L'angle qu'il faut se déplacer pour aller à un autre point du cercle dépendament du nombre de côtés
    double delta = 360/nbCote;
    
    for(int i = 0; i < nbCote;i++)
    {
        //Création des sommets du haut et bas
        int indexH = i*2;
        int indexB = i*2+1;
        double leCos = cos((delta*i)*(M_PI/180));
        double leSin = sin((delta*i)*(M_PI/180));
        double x = rayon*leCos+transX;
        double z = rayon*leSin+transZ;
        double yH = hauteur+transY;
        double yB = transY;
        
        vertices.push_back(new CVertex(indexH, CPoint3D(x,yH,z),0.0,0.0));
        vertices.push_back(new CVertex(indexB, CPoint3D(x,yB,z),0.0,0.0));
    }
    
    for(int i = 0; i < nbCote-1; i++)
    {
        CVertex* v0 = vertices[i*2];
        CVertex* v1 = vertices[i*2+1];
        CVertex* v2 = vertices[i*2+2];
        CVertex* v3 = vertices[i*2+3];
        
        if(i%2 == 0)
        {
           triangles.push_back(new CTriangle(v2,v1,v0));
            triangles.push_back(new CTriangle(v1,v2,v3));
        }
        else
        {
           triangles.push_back(new CTriangle(v3,v1,v0));
            triangles.push_back(new CTriangle(v0,v2,v3));
        }
    }
    CVertex* v0 = vertices[(nbCote*2)-2];
    CVertex* v1 = vertices[(nbCote*2)-1];
    CVertex* v2 = vertices[0];
    CVertex* v3 = vertices[1];
    
    triangles.push_back(new CTriangle(v2,v1,v0));
    triangles.push_back(new CTriangle(v1,v2,v3));
    
    
    UpdateNormals();
    AllocVBOData();
}