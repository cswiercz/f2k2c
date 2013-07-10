###############################################################################
# f2c Makefile
###############################################################################
TARGETS=ftest ctest
FTESTOBJS=simple.o ftest.o
CTESTOBJS=simple.o ctest.o

.SECONDARY=
.PHONY=clean

FC=gfortran
CC=gcc

FFLAGS=-g -fbounds-check
CFLAGS=-g -fbounds-check
LFLAGS=

CLIBS=-lgfortran
CLIBDIRS=-L/usr/local/gfortran/lib


default: ctest
	@echo "[f2c] Make complete."

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

%.o: $.c
	$(CC) $(CFLAGS) -c $< -o $@

ftest: $(FTESTOBJS)
	@echo "[f2c] Fortran program test..."
	$(FC) $(FFLAGS) $(FTESTOBJS) -o $@
	@echo "[f2c] ...done."

ctest: $(CTESTOBJS)
	@echo "[f2c] Creating C program test..."
	$(CC) $(CLIBDIRS) $(CLIBS) $(CFLAGS) $(CTESTOBJS) -o $@
	@echo "[f2c] ...done."

clean:
	-rm -f *~ *.o *.mod $(TARGETS)
