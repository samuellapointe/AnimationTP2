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
            if(i != (*drap).getResV() -1)
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
        
        if(i != (*drap).getResV() -1)
        {
            CParticule* top = particules[(i+1)*(*drap).getResH()-1];
            CParticule* below = particules[(i+2)*(*drap).getResH()-1];
        
            ressorts.push_back(new CRessort(top,below,reposV,100));
        }
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

void CIntegrateur::step(float simulationTime)
{
    /*
    // TEST - Afficher les positions de chaque particule
    std::cout << "\n\nTEST\n";
    int cptParticule = 0;
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        std::cout << "Particule " << cptParticule << "\n  1) " << (*it)->getPosition(0)[0] << " " << (*it)->getPosition(0)[1] << " " << (*it)->getPosition(0)[2] << "  2) " << (*it)->getPosition(0)[0] << " " << (*it)->getPosition(0)[1] << " " << (*it)->getPosition(0)[2]<< "\n\n";
        ++cptParticule;
    }
    */
    
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
    
    // TEST - Afficher les positions de chaque particule
    /*std::cout << "\n\nTEST particules\n";
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        std::cout << "Particule " << (*it)->getVertex()->idx << "\n  1) " << (*it)->getPosition(0)[0] << " " << (*it)->getPosition(0)[1] << " " << (*it)->getPosition(0)[2] << "  2) " << (*it)->getPosition(0)[0] << " " << (*it)->getPosition(0)[1] << " " << (*it)->getPosition(0)[2]<< "\n\n";
    }*/
    /*
    // TEST - Afficher la position des particules de chaque ressort
    std::cout << "\n\nTEST ressorts\n";
    int cptRessort = 0;
    for(std::vector<CRessort*>::iterator it = (smr->ressorts).begin(); it != (smr->ressorts).end(); it++)
    {
        std::cout << "Ressort " << cptRessort << ", particule " << (*it)->getP0()->getVertex()->idx << "\n  1) " << (*it)->getP0()->getPosition(0)[0] << " " << (*it)->getP0()->getPosition(0)[1] << " " << (*it)->getP0()->getPosition(0)[2] << "  2) " << (*it)->getP0()->getPosition(0)[0] << " " << (*it)->getP0()->getPosition(0)[1] << " " << (*it)->getP0()->getPosition(0)[2]<< "\n";
        
        std::cout << "Ressort " << cptRessort << ", particule " << (*it)->getP1()->getVertex()->idx << "\n  1) " << (*it)->getP1()->getPosition(0)[0] << " " << (*it)->getP1()->getPosition(0)[1] << " " << (*it)->getP1()->getPosition(0)[2] << "  2) " << (*it)->getP1()->getPosition(0)[0] << " " << (*it)->getP1()->getPosition(0)[1] << " " << (*it)->getP1()->getPosition(0)[2]<< "\n\n";
        
        ++cptRessort;
    }
    */
    // Pour chaque particule, obtention de la force interne (somme des forces exercées par les ressorts attachés.
    // Pour ce faire, à chaque ressort on ajoute sa force aux particules concernées.  La force est donc calculée une seule
    // fois par ressort.
    for(std::vector<CRessort*>::iterator it = (smr->ressorts).begin(); it != (smr->ressorts).end(); it++)
    {
        // Ajout de la force exercée par une particule voisine (reliée par un ressort)
        CVect3D forceRessort((*it)->F());
        (*it)->getP0()->setVelocity(1, (*it)->getP0()->getVelocity(1) + forceRessort);
        (*it)->getP1()->setVelocity(1, (*it)->getP1()->getVelocity(1) + forceRessort);
    }
    
    // Calcul de la nouvelle vélocité et position de chaque particule
    for(std::vector<CParticule*>::iterator it = (smr->particules).begin(); it != (smr->particules).end();it++)
    {
        if((*it)->getVertex()->idx >= (smr->drap)->getResH())
        {
            // Nouvelle vélocité
            CVect3D forcesExternesTemp = f_vent((*it)->getPosition(0), simulationTime);
            (*it)->setVelocity(1, (*it)->getVelocity(0) + (h * (1/(*it)->getMasse() * (forcesExternesTemp -(*it)->getVelocity(1)))));
        
            // Nouvelle position
            (*it)->setPosition(1, (*it)->getPosition(0) + (h * (*it)->getVelocity(1)));
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

    //Amplitude
    float ampx = 1;
    float ampy = 1;

    //Frequence
    float freqx = 1;
    float freqy = 1;

    //Variable de force globale
    float force = 3;

    float forceFinale = force * (ampx * sinf(freqx*(t*pos[0])) + ampy * cosf(freqy*(t*pos[0])));

    return forceFinale * direction;
}