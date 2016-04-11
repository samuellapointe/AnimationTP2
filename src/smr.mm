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
    
    float reposH = float((*drap).getSize(0))/float((*drap).getResH());
    float reposV = float((*drap).getSize(1))/float((*drap).getResV());
    float reposD = sqrt(pow(reposH,2)+pow(reposD,2));
    
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
        ressorts.push_back(new CRessort(*it,std::next(*it,1),reposH,100));
        cpt++;
    }
    
}

CVect3D CRessort::F() const
{
    CVect3D xMinusY = (P0->getPosition(0)) - (P1->getPosition(0));
    CVect3D forceRessort = -k * (Module(xMinusY) - longueur_repos ) * (xMinusY/Module(xMinusY));
    return forceRessort;
}

CParticule* CRessort::getP0()
{
    return P0;
}

CParticule* CRessort::getP1()
{
    return P1;
}

void CIntegrateur::step()
{
    // Pour chaque particule
    for(std::list<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {/*
        // Interchanger la vitesse et la position
        CVect3D positionTemp = (*it)->getPosition(0);
        (*it)->setPosition(0, (*it)->getPosition(1));
        (*it)->setPosition(1, positionTemp);
        
        CVect3D vitesseTemp = (*it)->getVelocite(0);
        (*it)->setVelocite(0, (*it)->getVelocite(1));
        (*it)->setVelocite(1, vitesseTemp);*/
    }
    
    /* TODO À remplacer par une boucle sur les particules avec la liste d'adjascence
    // Pour chaque ressort
    for(std::list<CRessort*>::iterator it = (smr->ressorts).begin(); it != (smr->ressorts).end();it++)
    {
        // Ajout de la force exercée par une particule voisine (reliée par un ressort)
        CVect3D forceRessort((*it)->F());
        (*it)->getP0()->vel[1] += forceRessort;
        (*it)->getP1()->vel[1] += forceRessort;
    }
     */
    
    // Test de déplacement de point
    smr->drap->getVertices()[0]->operator+=(CVect3D(0.1, 0, 0));
    
    smr->drap->UpdateVBO();
}