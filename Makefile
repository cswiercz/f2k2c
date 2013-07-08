.SECONDARY=
.PHONY=clean

FC=gfortran
CC=gcc

matrices.o: matrices.f90
	$(FC) -c matrices.f90 -g -fbounds-check

ftest.o: ftest.f90
	$(FC) -c ftest.f90 -g -fbounds-check

ftest: matrices.o matrices_c_interface.o ftest.o
	$(FC) -o ftest matrices.o matrices_c_interface.o ftest.o -g -fbounds-check

ctest.o: ctest.c
	$(CC) -c ctest.c -g -fbounds-check

ctest: matrices.o ctest.o
	$(CC) -o ctest matrices.o ctest.o -lgfortran -g -fbounds-check

clean:
	rm -f *.o *.mod ftest
