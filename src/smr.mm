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
    
    float reposH = Module(*(*drap).getVertices()[1] - *(*drap).getVertices()[0]);
    float reposV = Module(*(*drap).getVertices()[(*drap).getResH()] - *(*drap).getVertices()[0]);
    float reposD = Module(*(*drap).getVertices()[(*drap).getResH() + 1] - *(*drap).getVertices()[0]);
    
    int k = 1000000;
    
    //Création des particules et les insérer dans la liste
    for(std::vector<CVertex*>::iterator it = (*drap).getVertices().begin(); it != (*drap).getVertices().end();it++)
    {
        CVect3D velIni(0.0,0.0,0.0);
        particules.push_back(new CParticule(*it,**it,**it,velIni,velIni,5.0));
    }

    
    for(int i=0; i < (*drap).getResV();i++)
    {
        for(int j = 0; j < (*drap).getResH()-1; j++)
        {
            int index = (*drap).getResH()*i + j;
            
            //On fait un carré partant du point actuel jusqu'au point inferieur droit
            
            CParticule* cornerTopLeft = particules[index];
            CParticule* cornerTopRight = particules[index+1];
            CParticule* cornerBottomLeft = particules[index+(*drap).getResH()];
            CParticule* cornerBottomRight = particules[index+(*drap).getResH()+1];
            
            ressorts.push_back(new CRessort(cornerTopLeft,cornerTopRight,reposH,k));
            if(i != (*drap).getResV() -1)
            {
                ressorts.push_back(new CRessort(cornerTopLeft,cornerBottomLeft,reposV,k));
                ressorts.push_back(new CRessort(cornerTopRight,cornerBottomLeft,reposD,k));
                ressorts.push_back(new CRessort(cornerTopLeft,cornerBottomRight,reposD,k));
            }
        }
        
        if(i != (*drap).getResV() -1)
        {
            CParticule* top = particules[(i+1)*(*drap).getResH()-1];
            CParticule* below = particules[(i+2)*(*drap).getResH()-1];
        
            ressorts.push_back(new CRessort(top,below,reposV,k));
        }
    }
    
    for(int i = 0; i < (*drap).getResV()-2;i++)
    {
        for(int j=0; j < (*drap).getResH()-2;j++)
        {
            int index = (*drap).getResH()*i + j;
            
            CParticule* cornerTopLeft = particules[index];
            CParticule* cornerTopRight = particules[index+2];
            CParticule* cornerBottomLeft = particules[index+(2*(*drap).getResH())];
            CParticule* cornerBottomRight = particules[index+(2*(*drap).getResH())+2];
            
            ressorts.push_back(new CRessort(cornerTopLeft,cornerTopRight,2*reposH,k));
            ressorts.push_back(new CRessort(cornerTopLeft,cornerBottomLeft,2*reposV,k));
            ressorts.push_back(new CRessort(cornerTopRight,cornerBottomLeft,2*reposD,k));
            ressorts.push_back(new CRessort(cornerTopLeft,cornerBottomRight,2*reposD,k));
            
            if(i == (*drap).getResV() -2)
                ressorts.push_back(new CRessort(cornerBottomLeft,cornerBottomRight,2*reposH,k));
        }
        
        CParticule* top = particules[(i+1)*(*drap).getResH()-1];
        CParticule* below = particules[(i+3)*(*drap).getResH()-1];
        
        ressorts.push_back(new CRessort(top,below,2*reposV,k));
    }
    
}

CVect3D CRessort::F(CParticule* p0) const
{
    CParticule* p1;
    
    if (p0 == P0) {
        p1 = P1;
    } else {
        p1 = P0;
    }
    
    CVect3D xMinusY = (p1->getPosition(0)) - (p0->getPosition(0));
    CVect3D forceRessort = (-k) * ((Module(xMinusY) - longueur_repos ) * (xMinusY/Module(xMinusY)));
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

void CIntegrateur::step(float simulationTime)
{
    // Pour chaque particule
    //CVect3D positionTemp;
    //CVect3D vitesseTemp;
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        // Interchanger les vitesses et les positions
        //positionTemp = (*it)->getPosition(0);
        (*it)->setPosition(0, (*it)->getPosition(1));
        //(*it)->setPosition(1, CPoint3D(0,0,0));
        
        //vitesseTemp = (*it)->getVelocity(0);
        (*it)->setVelocity(0, (*it)->getVelocity(1));
        //(*it)->setVelocity(1, CVect3D(0,0,0));
    }
    

    // Pour chaque particule, obtention de la force interne (somme des forces exercées par les ressorts attachés.
    // Pour ce faire, à chaque ressort on ajoute sa force aux particules concernées.  La force est donc calculée une seule
    // fois par ressort.
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        CParticule * p = (*it);
        for(int i = 0; i < p->getRessorts().size(); i++) {
            p->addForce((p->getRessorts()[i])->F(p));
        }
    }
    
    // Calcul de la nouvelle vélocité et position de chaque particule
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        std::vector<int>pointsFixes;
        pointsFixes.push_back(1);
        pointsFixes.push_back(2);
        pointsFixes.push_back((smr->drap->getResH())-2);
        pointsFixes.push_back((smr->drap->getResH())-3);
        if(!(std::find(pointsFixes.begin(),pointsFixes.end(),(*it)->getVertex()->idx) != pointsFixes.end()))
        {
            // Nouvelle vélocité
            CVect3D forcesExternesTemp = f_vent((*it)->getPosition(0), simulationTime);
            CVect3D vel = (*it)->getVelocity(0) + (h * (1/(*it)->getMasse() * (forcesExternesTemp -(*it)->getForce())));
            (*it)->setVelocity(1, vel);
        
            // Nouvelle position
            (*it)->setPosition(1, (*it)->getPosition(0) + (h * (*it)->getVelocity(1)));
            
            (*it)->resetForce();
        }
    }
    
    // Mise à jour du maillage du drap selon la position des particules du système masses-ressorts
    CVect3D deplacementPosition;
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        deplacementPosition = (*it)->getPosition(1) - (*it)->getPosition(0);
        smr->drap->getVertices()[(*it)->getVertex()->idx]->operator+=(deplacementPosition);
    }
    
    // Test de déplacement de point
    //smr->drap->getVertices()[0]->operator+=(CVect3D(0, 0.01, 0));
    smr->drap->UpdateNormals();
    smr->drap->UpdateVBO();
}

CVect3D CIntegrateur::f_vent(const CPoint3D& pos, const float &t) {
    CVect3D direction = CVect3D(0, 0, 1); //Définit la direction du vent (et sa force de base)
    CVect3D gravite = CVect3D(0, -500, 0);

    //Amplitude
    float ampx = 2;
    float ampy = 2;

    //Frequence
    float freqx = 3;
    float freqy = 3;

    //Variable de force globale
    float force = 300;

    float forceFinale = force + (ampx * sinf(freqx*(t+pos[0])) + ampy * cosf(freqy*(t+pos[1])));
    //if (forceFinale < 0) forceFinale = 0;

    return forceFinale * direction + gravite;
}