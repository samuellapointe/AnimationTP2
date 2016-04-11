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
    
}

CVect3D CRessort::F() const
{
    CVect3D xMinusY = (P0->pos) - (P1->pos);
    CVect3D forceRessort = -k * (Module(xMinusY) - longueur_repos ) * (xMinusY/Module(xMinusY));
    return forceRessort;
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