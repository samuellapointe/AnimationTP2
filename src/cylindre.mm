//
//  cylindre.m
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#include "cylindre.h"
#include "math.h"


void CCylindre::CreateCylindre(double hauteur, double rayon, int nbCote, double transX){
    CPoint3D pointMilieuHaut = CPoint3D(transX,hauteur,0);
    CPoint3D pointMilieuBas = CPoint3D(transX,0,0);
    
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
        double z = rayon*leSin;
        double yH = hauteur;
        double yB = 0;
        
        vertices.push_back(new CVertex(indexH, CPoint3D(x,yH,z),0.0,0.0));
        vertices.push_back(new CVertex(indexB, CPoint3D(x,yB,z),0.0,0.0));
    }
    //Création des sommets au centre du cylindre (En haut et en bas)
    vertices.push_back(new CVertex((nbCote*2), pointMilieuHaut, 0.0, 0.0));
    vertices.push_back(new CVertex((nbCote*2)+1, pointMilieuBas, 0.0, 0.0));
    
    //Création des triangles situés sur le dessus du cylindre (sauf le dernier)
    for(int i = 0; i < nbCote-1;i++)
    {
        CVertex* v0 = vertices[i*2];
        CVertex* v1 = vertices[nbCote*2];
        CVertex* v2 = vertices[i*2+2];
        
        triangles.push_back(new CTriangle(v0,v1,v2));
    }
    //Création du dernier triangle situé sur le dessus du cylindre
    CVertex* vHaut0 = vertices[nbCote*2-2];
    CVertex* vHaut1 = vertices[nbCote*2];
    CVertex* vHaut2 = vertices[0];
    
    triangles.push_back(new CTriangle(vHaut0,vHaut1,vHaut2));
    
    
    //Création des triangles au centre du cylindre (sauf le dernier)
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
    
    //Création des deux derniers triangles au centre du cylindre (Fermeture du cylindre)
    CVertex* vCentre0 = vertices[(nbCote*2)-2];
    CVertex* vCentre1 = vertices[(nbCote*2)-1];
    CVertex* vCentre2 = vertices[0];
    CVertex* vCentre3 = vertices[1];
    
    triangles.push_back(new CTriangle(vCentre2,vCentre1,vCentre0));
    triangles.push_back(new CTriangle(vCentre1,vCentre2,vCentre3));
    
    
    
    //Création des triangles situés en dessous du cylindre (sauf le dernier)
    for(int i = 0; i < nbCote-1;i++)
    {
        CVertex* v0 = vertices[i*2+1];
        CVertex* v1 = vertices[(nbCote*2)+1];
        CVertex* v2 = vertices[i*2+3];
        
        triangles.push_back(new CTriangle(v2,v1,v0));
    }
    //Création du dernier triangle situé en dessous du cylindre
    CVertex* vBas0 = vertices[nbCote*2-1];
    CVertex* vBas1 = vertices[(nbCote*2)+1];
    CVertex* vBas2 = vertices[1];
    
    triangles.push_back(new CTriangle(vBas2,vBas1,vBas0));
    
    
    
    UpdateNormals();
    AllocVBOData();
}