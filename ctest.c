#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>

int main(int *argc, char *argv) {

    // Initialize the matrix
    void *a_ptr;
    c_init(&a_ptr,10,10);


    // Check that the values of the matrix entries are all zero
    int i=0, j=0;
    double val = 1.0;
    for (j=0; j<10; j++){
        for (i=0; i<10; i++){
            c_get_val(&val,&a_ptr,i,j);
            if (val!=0.0) {
                printf("Entry %d %d is not zero!\n",i,j);
            }
        }
    }


    // Set some of the matrix entries
    for (j=0; j<10; j++){
        for (i=0; i<10; i++){
            c_set_val(&a_ptr,exp(-abs(i-j)),i,j);
        }
    }


    // Check that the matrix entries were set properly
    for (j=0; j<10; j++) {
        for (i=0; i<10; i++) {
            c_get_val(&val,&a_ptr,i,j);
            if ( abs(val-exp(-abs(i-j)))>1e-16 ) {
                printf("%d %d : %g\n",i,j,val-exp(-abs(i-j)) );
            }
        }
    }

    return 0;
}
