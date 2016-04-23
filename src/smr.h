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
#include "drap.h"

class CRessort;
enum typeRessort{structural,sheer,flexion};
class CParticule{
public:
    CParticule(CVertex* _v, CPoint3D _p0, CPoint3D _p1, CVect3D _vel0, CVect3D _vel1, float _masse, bool _fixe)
    {
        vertex = _v;
        pos[0] = _p0;
        pos[1] = _p1;
        vel[0] = _vel0;
        vel[1] = _vel1;
        masse = _masse;
        force = CVect3D(0, 0, 0);
        fixe = _fixe;
    }
    
    void ajouterParticulesAdj(CParticule* _part);
    float getMasse() { return masse; }
    CPoint3D getPosition(int index){ return pos[index]; }
    CVect3D getVelocity(int index) { return vel[index]; }
    CVertex* getVertex() { return vertex; }
    void setPosition(int index, CPoint3D position) { pos[index] = position; }
    void setVelocity(int index, CVect3D velocity) { vel[index] = velocity; }
    void addForce(CVect3D force) {this->force += force;};
    CVect3D getForce() {return this->force;};
    void resetForce() {this->force = CVect3D(0, 0, 0);};
    void addRessort(CRessort* ressort) {this->ressorts.push_back(ressort);};
    std::vector<CRessort*> getRessorts(){return ressorts;};
    bool getFixe() {return fixe;};
    
private:
    CPoint3D pos[2];
    CVect3D vel[2];
    CVect3D force;
    float masse;
    CVertex* vertex; //Le sommet du mesh associé à cette particule
    bool fixe;
    std::vector<CRessort*> ressorts; //Liste des particules connectées à celle-ci
};


class CRessort{
private:
    CParticule *P0,*P1;
    float longueur_repos;
    float k; //Constante de Hooke.
    typeRessort type;
    
public:
    CRessort(CParticule* _p0, CParticule* _p1, float _repos, float _k,typeRessort _type)
    {
        P0 = _p0;
        P1 = _p1;
        longueur_repos = _repos;
        k = _k;
        P0->addRessort(this);
        P1->addRessort(this);
        type = _type;
    }
    
    CParticule* getP0();
    CParticule* getP1();
    
public:
    CVect3D F(CParticule* p0) const; // Calcul de la force du ressort.
    typeRessort getType() {return type;};
    float getLongueurRepos() {return longueur_repos;};
};


class CSMR{
public:
    CSMR(CDrap* _drap);
    ~CSMR();
    
    CDrap* drap;
    std::vector<CParticule*> particules;
    std::vector<CRessort*> ressorts;
    

    
};


class CIntegrateur{
public:
    CIntegrateur(CSMR* _smr){ smr = _smr; }
    CSMR* smr;
    
    void step(float simulationTime);
    CVect3D f_vent(const CPoint3D& pos, const float &t);
    
};

#endif /* CSMR_h */
