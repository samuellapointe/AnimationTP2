//
//  CSMR.m
//  8trd147-d2
//
//  Created by Etudiant on 2016-04-08.
//
//

#include "smr.h"

#define h 0.001

CSMR::CSMR(CDrap* _drap)
{
    drap = _drap;
    
    float reposH = (*drap).getSize(0)/(*drap).getResH();
    float reposV = (*drap).getSize(1)/(*drap).getResV();
    float reposD = 
    
    int ligne = 1;
    int cpt = 0;
    std::list<CParticule*>::iterator it;
    
    for(std::vector<CVertex*>::iterator it = (*drap).getVertices().begin(); it != (*drap).getVertices().end();it++)
    {
        CVect3D velIni(0.0,0.0,0.0);
        particules.push_back(new CParticule(*it,**it,**it,velIni,velIni,1000.0));
    }
    
    for(it=particules.begin();cpt<14;it++)
    {
        ressorts.push_back(new CRessort(*it,std::next(*it,1,(*drap).getSize(0),100)))
    }
}

CVect3D CRessort::F() const
{
    /*CVect3D xMinusY = (P0->pos) - (P1->pos);
    CVect3D forceRessort = -k * (Module(xMinusY) - longueur_repos ) * (xMinusY/Module(xMinusY));
    return forceRessort;*/
}

void CIntegrateur::step()
{

    //for(std::vector<CVertex*>::iterator it = (*drap).getVerties().begin(); it != (*drap).getVerties().end();it++)
    {
        
    }
    
    //for(std::list<CTriangle*>::iterator it = (*drap).getTriangles().begin(); it != (*drap).getTriangles().end(); it++)
    {
        
    }
}