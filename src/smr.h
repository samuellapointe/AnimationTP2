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

class CParticule{
public:
    CParticule(CVertex* _v, CPoint3D _p0, CPoint3D _p1, CVect3D _vel0, CVect3D _vel1, float _masse)
    {
        vertex = _v;
        pos[0] = _p0;
        pos[1] = _p1;
        vel[0] = _vel0;
        vel[1] = _vel1;
        masse = _masse;
    }
    
    std::list<CParticule*> particulesAdj; //Liste des particules connectées à celle-ci
    CVertex* vertex; //Le sommet du mesh associé à cette particule
    
public:
    CPoint3D pos[2];
    CVect3D vel[2];
    float masse;//test
};


class CRessort{
public:
    CRessort(CParticule* _p0, CParticule* _p1, float _repos, float _k)
    {
        P0 = _p0;
        P1 = _p1;
        longueur_repos = _repos;
        k = _k;
    }
    
    CParticule *P0,*P1;
    float longueur_repos;
    float k; //Constante de Hooke.
    
public:
    CVect3D F() const; // Calcul de la force du ressort.
};


class CSMR{
private:
    CMesh* mesh;
    std::list<CParticule*> particules;
    std::list<CRessort*> ressorts;
    
public:
    CSMR(CMesh* _mesh);
    ~CSMR();
    
};


class CIntegrateur{
    CSMR* smr;
    
    void step();
    
};

#endif /* CSMR_h */
