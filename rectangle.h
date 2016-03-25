//
//  rectangle.h
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#ifndef rectangle_h
#define rectangle_h

#include "mesh.h"

class CRectangle : public CMesh {
public:
    CRectangle(int tailleHorizontale, int tailleVerticale, int resolutionHorizontale, int resolutionVerticale);
    
private:
    void CreateRectangle(int tailleHorizontale, int tailleVerticale, int resolutionHorizontale, int resolutionVerticale);

};

#endif /* rectangle_h */
