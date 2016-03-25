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
    CRectangle(int sizeH, int sizeV, int resH, int resV);
    
private:
    void CreateRectangle(int sizeH, int sizeV, int resH, int resV);

};

#endif /* rectangle_h */
