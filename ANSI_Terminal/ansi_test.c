#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

#define MENU_COLOR "\x1b[44m"

#define CUR_UP	"\x1b[1A"
#define CUR_DOWN "\x1b[1B"
#define CUR_LEFT "\x1b[1D"
#define CUR_RIGHT "\x1b[1C"

void fill_screen(int, int);
void move_cursor(int, int);

int main(void) {
	unsigned int cols, lines;

	//cols = atoi(getenv("COLUMNS"));
	//rows = atoi(getenv("LINES"));
	cols = 130;
	lines = 31;
	printf(MENU_COLOR);
	
	fill_screen(lines,cols);

	move_cursor(0,0);
	printf(MENU_COLOR "\t\t\tHere is some blue text! \n");

	sleep(30);
	printf(ANSI_COLOR_RESET);
	
	return 0;
}

void fill_screen(int lines, int cols) {
	for (int row=0;row<lines; row++){
		for (int col=0; col<cols; col++) {
			printf(" ");
		}
		printf("\n");
	}
}
void move_cursor(int line, int col) {
	printf("\x1b[%d;%dH",line,col);

}
