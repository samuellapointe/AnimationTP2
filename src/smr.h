//
//  CSMR.h
//  8trd147-d2
//
//  Created by Etudiant on 2016-04-08.
//
//

#ifndef CSMR_h
#define CSMR_h

#include <list>
#include <vector>
#include "mesh.h"

class CSMR{
    CMesh* mesh;
    list<CParticule*> particules;
    list<CRessort*> ressorts;
    
    
    
};

class CParticule{
    CVertex* vertex; //Le sommet du mesh associé à cette particule
    CPoint3D pos[2];
    CVect3D vel[2];
    float masse;
    
    
    
    
};

class CRessort{
    CParticule *P0,*P1;
    float longueur_repos;
    float k; //Constante de Hooke.
    
    CVect3D F() const; // Calcul de la force du ressort.
};

class CIntegrateur{
    CSMR* smr;
    
    void step();
    
};

#endif /* CSMR_h */
