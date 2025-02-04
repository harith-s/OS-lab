#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

#define MAX_HISTORY 100
#define MAX_COMMAND_LENGTH 256

// Global variables for history
char history[MAX_HISTORY][MAX_COMMAND_LENGTH];
int history_count = 0;

// Enable raw mode for terminal input
void enableRawMode() {
    struct termios raw;

    tcgetattr(STDIN_FILENO, &raw);
    raw.c_lflag &= ~(ECHO | ICANON);  // Disable canonical mode and echo
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
}

// Disable raw mode
void disableRawMode() {
    struct termios original;

    tcgetattr(STDIN_FILENO, &original);
    original.c_lflag |= (ECHO | ICANON);  // Restore canonical mode and echo
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &original);
}

// Clear the current line in the terminal
void clearLine() {
    printf("\r\033[K"); // Move to the beginning of the line and clear it
}

// Process user input and arrow key navigation
void processInput() {
    char buffer[MAX_COMMAND_LENGTH];
    int history_index = history_count; // Start at the latest history entry

    while (1) {
        printf("> ");
        fflush(stdout);

        int index = 0;
        char c;

        while (1) {
            c = getchar();

            if (c == '\n') {
                buffer[index] = '\0'; // Null-terminate the command
                printf("\n");

                // Save the command to history if it's not empty
                if (strlen(buffer) > 0) {
                    strncpy(history[history_count % MAX_HISTORY], buffer, MAX_COMMAND_LENGTH);
                    history_count++;
                }
                break;
            } else if (c == 27) { // Detect the start of an escape sequence
                char seq[3];
                seq[0] = getchar(); // Read '['
                seq[1] = getchar(); // Read 'A', 'B', etc.
                seq[2] = '\0';

                if (seq[0] == '[' && seq[1] == 'A') { // Up-arrow key
                    if (history_index > 0) {
                        history_index--;
                        clearLine();
                        printf("> %s", history[history_index]);
                        fflush(stdout);
                        strcpy(buffer, history[history_index]);
                        index = strlen(buffer);
                    }
                }
            } else if (c == 127 || c == '\b') { // Backspace
                if (index > 0) {
                    index--;
                    buffer[index] = '\0';
                    printf("\b \b");
                    fflush(stdout);
                }
            } else {
                buffer[index++] = c;
                putchar(c);
            }
        }

        // Exit loop if the command is "exit"
        if (strcmp(buffer, "exit") == 0) {
            break;
        }
    }
}

int main() {
    enableRawMode();
    processInput();
    disableRawMode();
    return 0;
}
