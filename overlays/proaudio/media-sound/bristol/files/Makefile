include ../Makefile.autodefs
#
# If you want to recompile all this lot then you have a few choices on for the
# bindings. The default is static, as defined here. You can change this to
# dynamic, but then you will get pretty much the same code as the distribution.
#
# Management of the ALSA support is painful. I either need a dummy library,
# which I do not want to have to maintain, or I need some intelligent library
# selection. Hm, I don't like "intelligent" solutions, since they usually
# miss too many possible clauses.
#
#BINDING	=static
BINDING	=dynamic

#
DESTDIR		=
INCPATH		= -I../include -I. -I/usr/local/include ${JACKINC}
BINDIR		=

LIBSDIR		= -L/usr/lib -L/usr/local/lib -L../../slab/libslabaudio -L../libbristol -L../libbristolmidi -L../libbristol ${JACKLD}
#LIBS		= -lbristol -lbristolmidi -lslabaudio -lc -lm ${LIBASOUND} -lpthread
#LIBS		= -lc -lm ${LIBASOUND} -lpthread -Xlinker -Bstatic -lbristol -lbristolmidi -lslabaudio
#LIBS		= -lc -lm -lpthread -Xlinker -Bstatic -lbristol -lbristolmidi -lslabaudio
#LIBS		= -lc -lm -lpthread -lasound -lbristol -lbristolmidi -lslabaudio -ljack
LIBS		= -lc -lm -lpthread ${LIBASOUND} -lbristol -lbristolmidi -lslabaudio ${JACKLIB}
LDFLAGS		= ${LIBSDIR} -Xlinker -B${BINDING} ${LIBS}

CC			=	cc -g -fPIC
DEPEND		=	makedepend
INSTALL		=	install -c

#
# FEATURES include:
#
FEATURES	= ${JACK}
#FEATURES	= -D_REENTRANT -DDEBUG -DBRISTOL_DBG

CFLAGS		= ${DEFINES} ${FEATURES} ${INCPATH}
MFLAGS		= -I.

#
# Header files
#
HDRS		= bristol.h

# Source files
#
SRC8	=${SRC9} bristoljack.c
SRC7	=${SRC8} bristolmixer.c bristolprophet52.c bristolobx.c bristolpoly.c
SRC6	=${SRC7} bristolvox.c vox.c sdco.c sdcoutils.c bristolsampler.c
SRC5	=${SRC6} vibrachorus.c thesermon.c bristolexplorer.c filter2.c lfo.c
SRC4	=${SRC5} bristoldx.c hpf.c junodco.c bristoljuno.c dimensionD.c expdco.c
SRC3	=${SRC4} bristolsystem.c bristolhammond.c bristolprophet.c prophetdco.c
SRC2	=${SRC3} filter.c noise.c hammond.c audioEngine.c resonator.c dxop.c
SRC1	=${SRC2} midihandlers.c bristolmm.c midinote.c envelope.c dca.c rotary.c
BRISTOLSRC=${SRC1} bristolmain.c dco.c midithread.c audiothread.c soundManager.c

#
# Object files
#
OBJ8	=${OBJ9} bristoljack.o
OBJ7	=${OBJ8} bristolmixer.o bristolprophet52.o bristolobx.o bristolpoly.o
OBJ6	=${OBJ7} bristolvox.o vox.o sdco.o sdcoutils.o bristolsampler.o
OBJ5	=${OBJ6} vibrachorus.o thesermon.o bristolexplorer.o filter2.o lfo.o
OBJ4	=${OBJ5} bristoldx.o hpf.o junodco.o bristoljuno.o dimensionD.o expdco.o
OBJ3	=${OBJ4} bristolsystem.o bristolhammond.o bristolprophet.o prophetdco.o
OBJ2	=${OBJ3} filter.o noise.o hammond.o audioEngine.o resonator.o dxop.o
OBJ1	=${OBJ2} midihandlers.o bristolmm.o midinote.o envelope.o dca.o rotary.o
BRISTOLOBJ=${OBJ1} bristolmain.o dco.o midithread.o audiothread.o soundManager.o

PROGS	= bristol

all:	${PROGS}

bristol: ${BRISTOLOBJ}
	${CC} ${CFLAGS} ${BRISTOLOBJ} -o bristol ${LDFLAGS}

install: ${PROGS}
	cp ${PROGS} ../../../bin

clean:
	@rm -f *~ core ${PROGS} ${BRISTOLOBJ}

lint:
	lint -bac ${DEFINES} ${BRISTOLSRC}

depend:
	${DEPEND} ${INCPATH} ${MFLAGS} ${BRISTOLSRC}

# DO NOT DELETE THIS LINE -- mkdep uses it.

