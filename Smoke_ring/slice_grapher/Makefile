#-------------------------------------------------------------------
# class-hpc-smoke-ring: A simple sample field solver.
#
#    by Akira Kageyama, Kobe University, Japan.
#       email: sgks@mac.com
#
#    Copyright 2018 Akira Kageyama
#
#    This software is released under the MIT License.
#
#-------------------------------------------------------------------
#    src/constants.f90
#-------------------------------------------------------------------

.PHONY: link epsfigs clean view

.SUFFIXES:
.SUFFIXES: .f90 .o

FC = ifort

.f90.o:
	$(FC) $(FFLAGS) -c $<


#view: Workfiles/animation.gif
#	open -a Safari Workfiles/animation.gif

Workfiles/animation.gif: epsfigs
	cd Workfiles; \
        for i in `ls *.eps`; \
        do \
          echo converting $$i; \
          convert -alpha Remove -density 300x300 $$i $$i.gif; \
        done; \
        echo 'making animation.gif'; \
        convert -delay 10 *.eps.gif animation.gif

epsfigs: Workfiles nloop_list.txt gnuplot_data_generator
	for i in `awk '{print $$2}' nloop_list.txt`; \
        do \
          ./make_plotscript.sh $$i; \
          gnuplot 'Workfiles/plot.gp'; \
        done


Workfiles:
	mkdir -p Workfiles


nloop_list.txt: extract_nloop_list ../src/_data_slice
	./extract_nloop_list > nloop_list.txt

extract_nloop_list: link extract_nloop_list.o
	$(FC) $(FFLAGS) -o extract_nloop_list  \
		constants.o  \
		extract_nloop_list.o


gnuplot_data_generator: link gnuplot_data_generator.o
	$(FC) $(FFLAGS) -o gnuplot_data_generator  \
		constants.o  \
		ut.o  \
		grid.o  \
		turtle.o  \
		gnuplot_data_generator.o


link:
	ln -sf ../src/constants.f90 .
	ln -sf ../src/ut.f90 .
	ln -sf ../src/grid.f90 .
	$(FC) $(FFLAGS) -c constants.f90
	$(FC) $(FFLAGS) -c ut.f90
	$(FC) $(FFLAGS) -c grid.f90

gnuplot_data_generator.o: constants.o ut.o grid.o turtle.o
extract_nloop_list.o: constants.o
ut.o: constants.o
turtle.o: constants.o ut.o
grid.o:	constants.o ut.o


clean:
	rm -f *.o *.mod
	rm constants.f90 ut.f90 grid.f90  # Remove links
	rm -f gnuplot_data_generator extract_nloop_list nloop_list.txt
	rm -rf Workfiles
