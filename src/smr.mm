//
//  CSMR.m
//  8trd147-d2
//
//  Created by Etudiant on 2016-04-08.
//
//

#include "smr.h"

<<<<<<< e1ac64e66e88b29a6aac18ab5c1d10b09347a362
#define h 0.001

CSMR::CSMR(CMesh* _mesh)
=======
CSMR::CSMR(CDrap* _drap)
>>>>>>> smr
{
    drap = _drap;
    
<<<<<<< e1ac64e66e88b29a6aac18ab5c1d10b09347a362
}

CVect3D CRessort::F() const
{
    CVect3D xMinusY = (P0->pos) - (P1->pos);
    CVect3D forceRessort = -k * (Module(xMinusY) - longueur_repos ) * (xMinusY/Module(xMinusY));
    return forceRessort;
}

void CIntegrateur::step()
{

=======
    for(std::vector<CVertex*>::iterator it = (*drap).getVerties().begin(); it != (*drap).getVerties().end();it++)
    {
        
    }
    
    for(std::list<CTriangle*>::iterator it = (*drap).getTriangles().begin(); it != (*drap).getTriangles().end(); it++)
    {
        
    }
>>>>>>> smr
}