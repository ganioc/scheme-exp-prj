# The configure script fills in these values
CC=gcc
CFLAGS=-D_THREAD_SAFE -I/usr/local/Cellar/guile/3.0.4/include/guile/3.0 -I/usr/local/opt/gmp/include -I/usr/local/opt/readline/include -I/usr/local/opt/bdw-gc/include
LIBS=-L/usr/local/Cellar/guile/3.0.4/lib -L/usr/local/opt/bdw-gc/lib -lguile-3.0 -lgc

sample: sample.o
	${CC} sample.o ${LIBS} -o sample
sample.o: sample.c
	${CC} -c ${CFLAGS} sample.c
