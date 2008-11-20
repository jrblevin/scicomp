F03 = gfortran

TARGETS = binenc_test

all: $(TARGETS)

%.o: %.f03
	$(F03) -std=f2003 -c $<

binenc_test: binenc_mod.o binenc_test.o
	$(F03) -std=f2003 -o $@ $^

clean:
	-rm -f *.mod *.o $(TARGETS)
