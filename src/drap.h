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
    int getResH() { return resH; };
    int getResV() { return resV; };
    int getSize(int idx) { return size[idx]; }
    
private:
    void CreateDrap();
    int resH, resV, size[2];
};

#endif /* drap_h */
