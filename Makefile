main: main.c3
	c3c compile -O0 -g main.c3 -o main -l raylib -l m -l dl -l pthread -l GL -l X11