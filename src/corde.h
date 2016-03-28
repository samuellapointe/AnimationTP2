//
//  corde.h
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-28.
//
//

#ifndef corde_h
#define corde_h

#include "mesh.h"

class CCorde : public CMesh {
public:
    CCorde(double longeur, double transX, double transY){
        CMesh();
        CreateCorde(longeur, transX, transY);
    }
    
private:
    void CreateCorde(double longeur, double transX, double transY);
    void Draw(GLint prog);
};

#endif /* corde_h */
