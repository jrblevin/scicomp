F03 = gfortran
F03_FLAGS = -std=f2003 -O3 -Wall
F03_DEBUG = -g -std=f2003 -Wall -ggdb -fbounds-check -Wconversion

TARGETS = binenc_test

all: $(TARGETS)

%.o: %.f03
	$(F03) $(F03_FLAGS) -c $<

binenc_test: binenc_mod.o binenc_test.o
	$(F03) $(F03_FLAGS) -o $@ $^

clean:
	-rm -f *.mod *.o $(TARGETS)
