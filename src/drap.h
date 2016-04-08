//
//  drap.h
//  8trd147-d2
//
//  Created by Etudiant on 2016-03-25.
//
//

#ifndef drap_h
#define drap_h

#include "mesh.h"

class CDrap : public CMesh {
public:
    CDrap() {
        CMesh();
        CreateDrap();
    }
    
private:
    void CreateDrap();
};

#endif /* drap_h */
