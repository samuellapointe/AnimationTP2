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
    float reposD = sqrt(pow(reposH,2)+pow(reposV,2));
    
    
    //Création des particules et les insérer dans la liste
    for(std::vector<CVertex*>::iterator it = (*drap).getVertices().begin(); it != (*drap).getVertices().end();it++)
    {
        CVect3D velIni(0.0,0.0,0.0);
        particules.push_back(new CParticule(*it,**it,**it,velIni,velIni,1000.0));
    }

    
    for(int i=0; i < (*drap).getResV();i++)
    {
        int orientation = i % 2;
        
        for(int j = 0; j < (*drap).getResH()-1; j++)
        {
            int index = (*drap).getResH()*i + j;
            
            //Changer l'orientation pour chaque triangle
            int localOrientation = (orientation + j) % 2;
            
            //On fait un carré partant du point actuel jusqu'au point inferieur droit
            
            CParticule* cornerTopLeft = particules[index];
            CParticule* cornerTopRight = particules[index+1];
            CParticule* cornerBottomLeft = particules[index+(*drap).getResH()+0];
            CParticule* cornerBottomRight = particules[index+(*drap).getResH()+1];
            
            ressorts.push_back(new CRessort(cornerTopLeft,cornerTopRight,reposH,100));
            if(i != (*drap).getResV())
            {
                ressorts.push_back(new CRessort(cornerTopLeft,cornerBottomLeft,reposV,100));
            
                //Composé de deux triangles, orientation variante
                if (localOrientation == 0) {
                    ressorts.push_back(new CRessort(cornerTopRight,cornerBottomLeft,reposD,100));
                } else {
                    ressorts.push_back(new CRessort(cornerTopLeft,cornerBottomRight,reposD,100));
                }
            }
        }
        
        CParticule* top = particules[i*(*drap).getResH()-1];
        CParticule* below = particules[(i+1)*(*drap).getResH()-1];
        
        ressorts.push_back(new CRessort(top,below,reposV,100));
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
    //for(std::list<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
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
    smr->drap->getVertices()[0]->operator+=(CVect3D(0, 0.01, 0));
    
    smr->drap->UpdateVBO();
}

CVect3D CIntegrateur::f_vent(const CPoint3D& pos, const float &t) {
    CVect3D direction = CVect3D(0, 0, 1); //Définit la direction du vent (et sa force de base)

    //Amplitude
    float ampx = 1;
    float ampy = 1;

    //Frequence
    float freqx = 1;
    float freqy = 1;

    //Variable de force globale
    float force = sin(t/100);

    float forceFinale = force * (ampx * sinf(freqx*(t*pos[0])) + ampy * cosf(freqy*(t*pos[0])));

    return forceFinale * direction;
}