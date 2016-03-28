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
    CRectangle(double sizeH, double sizeV, int resH, int resV, bool draps = false){
        CMesh();
        CreateRectangle(sizeH, sizeV, resH, resV, draps);
    }
    
private:
    void CreateRectangle(double sizeH, double sizeV, int resH, int resV, bool draps);

};

#endif /* rectangle_h */
