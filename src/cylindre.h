//
//  cylindre.h
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#ifndef cylindre_h
#define cylindre_h

#include "mesh.h"

class CCylindre : public CMesh {
public:
    CCylindre(double hauteur, double rayon, int nbCote, double transX, double transY, double transZ){
        CMesh();
        CreateCylindre(hauteur, rayon, nbCote, transX, transY, transZ);
    }
    
private:
    void CreateCylindre(double hauteur, double rayon, int nbCote, double transX, double transY, double transZ);
};

#endif /* cylindre_h */
