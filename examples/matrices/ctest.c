#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <stdint.h>

int main(int *argc, char *argv) {

    // Initialize the matrix
    void *a_ptr;
    c_matrix(&a_ptr);
    c_setup(&a_ptr,10,10);


    // Check that the values of the matrix entries are all zero
    int i=0, j=0;
    double val = 1.0;
    for (j=0; j<10; j++){
        for (i=0; i<10; i++){
            c_get_val(&val,&a_ptr,i,j);
            if (val!=0.0) {
                printf("A(%d,%d)=%lf, should be zero!\n",i,j,val);
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


    // Multiply the matrix by a vector
    double *x = (double *)malloc( 10 * sizeof(double) );
    double *y = (double *)malloc( 10 * sizeof(double) );
    for (i=0; i<10; i++) {
        x[i] = 1.0;
        y[i] = 0.0;
    }

    c_matvec(&a_ptr,x,y,10,10);

    for (i=0; i<10; i++) {
        printf("%lf\n",y[i]);
    }

    return 0;
}




