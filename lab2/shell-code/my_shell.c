#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <stdbool.h>	

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64
#define MAX_NUM_PROCESSES 64
#define MAX_COMMANDS 10
#define MAX_HISTORY 50

/* Splits the string by space and returns the array of tokens
*
*/



bool interrupt = false;

void clearTokens(char ** tokens){
	for(int i=0;tokens[i]!=NULL;i++){
			free(tokens[i]);
		}
	free(tokens);
	return;
}
void checkForZombies(bool bg [], bool active [], pid_t pids []){

	for (int i = 0; i < MAX_NUM_PROCESSES; i++){
		if (active[i] && bg[i]){
			int w = waitpid(pids[i], NULL, WNOHANG);
			if (w > 0) printf("Background process %d is finished.\n", pids[i]);
		}
	}
	
	return;
}

void reapParallel(bool bg [], bool active [], pid_t pids []){
	for (int i = 0; i < MAX_NUM_PROCESSES; i++){
		if (active[i] && bg[i] == false){
			int w = waitpid(pids[i], NULL, 0);
			if (w > 0) printf("Process %d is done.\n", w);
			else printf("Process exited abnormally.\n");
			active[i] = false;
			bg[i] = false;
			pids[i] = 0;
		}
	}
}

int reapSingle(bool bg[], bool active[], pid_t pids[]){
	for (int i = 0; i < MAX_NUM_PROCESSES; i++){
		if (active[i] && bg[i] == false){
			int w = waitpid(pids[i], NULL, 0);
			if (w > 0) printf("Process %d is done.\n", w);
			else printf("Process exited abnormally.\n");
			active[i] = false;
			bg[i] = false;
			pids[i] = 0;
			return i;

		}
	}
}
int checkIfcanCreate(bool active[], int size){
	for (int pindex = 0; pindex < size; pindex++){
		if (!active[pindex]) return pindex;
	}
	return -1;
	
}

void sighandler(int s){
	// printf("%d\n", fpid);
	interrupt = true;
	return;
}

void killProcesses(pid_t pids[]){
	for (int i = 0; i < 64; i++){
		kill(pids[i], SIGTERM);
	}
}
char **tokenize(char *line)
{
  char **tokens = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));
  char *token = (char *)malloc(MAX_TOKEN_SIZE * sizeof(char));
  int i, tokenIndex = 0, tokenNo = 0;

  for(i =0; i < strlen(line); i++){

    char readChar = line[i];

    if (readChar == ' ' || readChar == '\n' || readChar == '\t'){
      token[tokenIndex] = '\0';
      if (tokenIndex != 0){
	tokens[tokenNo] = (char*)malloc(MAX_TOKEN_SIZE*sizeof(char));
	strcpy(tokens[tokenNo++], token);
	tokenIndex = 0; 
      }
    } else {
      token[tokenIndex++] = readChar;
    }
  }
 
  free(token);
  tokens[tokenNo] = NULL ;
  return tokens;
}

int length(char ** tokens){
	int i;
	for (i = 0; i < MAX_NUM_TOKENS; i++){
		if (tokens[i] == NULL) break;
	}
	return i;
}

char *** parseTokens(char** tokens){
	char ***parsed_tokens = (char ***)malloc(MAX_COMMANDS * sizeof(char **));
  	char **command = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));

	int j = 0;
	int cmd_no = 0;
	for (int i = 0; tokens[i] != NULL; i++){
		if (strcmp("&&", tokens[i]) == 0 || strcmp("&&&", tokens[i]) == 0){
			parsed_tokens[cmd_no] = command;
			command = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));
			cmd_no++;
			j = 0;
		}
		else {
			command[j] = (char *)malloc(sizeof(tokens[i]));
			strcpy(command[j], tokens[i]);
			j++;
		}
	}
	parsed_tokens[cmd_no] = command;
	parsed_tokens[cmd_no + 1] = NULL;
	return parsed_tokens;


}
bool checkParallel(char ** tokens){
	for (int i = 0; tokens[i] != NULL; i++){
		if (strcmp(tokens[i], "&&&") == 0) return false;
	}
	return true;
}

int main(int argc, char* argv[]) {

	pid_t pids[MAX_NUM_PROCESSES];
	bool bg[MAX_NUM_PROCESSES];
	bool active[MAX_NUM_PROCESSES];
	char *** commands[MAX_HISTORY];



	for (int j = 0; j < MAX_NUM_PROCESSES; j++){
		pids[j] = 0;
		bg[j] = false;
		active[j] = false;
	}
	int pindex = -1;

	char  line[MAX_INPUT_SIZE];            
	char  **tokens;              
	int i;
	bool serial = true;

	signal(SIGINT, sighandler);
	while(1) {	

		serial = true;		
		/* BEGIN: TAKING INPUT */
		bzero(line, sizeof(line));
		char wd[100];
		getcwd(wd, 100);
		printf("%s$ ", wd);
		

		scanf("%[^\n]", line);
		getchar();

		checkForZombies(bg, active, pids);

		// Check if there is a valid index is present

		pindex = checkIfcanCreate(active, MAX_NUM_PROCESSES);
		if (pindex == -1) {
			printf("Max processes reached. Please wait.\n");
			continue;
		}

		
		// printf("Command entered: %sremove this debug output later)\n", line);
		
		// Continue if no command is entered

		if (strlen(line) == 0) continue;


		line[strlen(line)] = '\n'; //terminate with new line
		tokens = tokenize(line);

		serial = checkParallel(tokens);
		
		char *** commands = parseTokens(tokens);
       
	   // Serial execution
		if (serial) {
			for (int icmd = 0; commands[icmd] != NULL; icmd++){
				if (interrupt) {interrupt = false; break;}
				// if (strcmp(tokens[0], "^[[A")) printf("Caught you\n");
				tokens = commands[icmd];
				if (strcmp(tokens[0], "cd") == 0){
					int err = chdir(tokens[1]);
					if (err == -1){
						printf("Changing directory failed. Please check the command.\n");
					}
				}
				// Exit command

				else if (strcmp(tokens[0], "exit") == 0 || strcmp(tokens[0], "q") == 0){
					for (;commands[icmd] != NULL; icmd++){
						free(commands[icmd]);
					}
					killProcesses(pids);
					killpg(getpgid(getpid()), SIGTERM);

				}

				// All other commands

				else if (strcmp(line, "\n") != 0)
				{
					int r = fork();
					if (r == 0){
						if (line[strlen(line) - 2] == '&'){
							tokens[length(tokens) - 1] = NULL;
							setpgid(0, 0);
						}
						
						execvp(tokens[0], tokens);
						printf("Error: No such command found.\n");

						exit(1);
					}
					else if (line[strlen(line) - 2] != '&'){

						int w = waitpid(r, NULL, 0);

					}
					else if (line[strlen(line) - 2] == '&' && r > 0) 
					{
						printf("Created background process with pid %d\n", r);
						pids[pindex] = r;
						bg[pindex] = true;
						active[pindex] = true;
					}
					
				}

			
				// Freeing the allocated memory	
				clearTokens(tokens);
			}
		}
		else {
			for (int icmd = 0; commands[icmd] != NULL; icmd++){
				fflush(stdout);
				tokens = commands[icmd];
				int r = fork();

				if (r == 0) {
					if (strcmp(tokens[length(tokens) - 1],"&") == 0){

						tokens[length(tokens) - 1] = NULL;
						setpgid(0, 0);
					}
						
					execvp(tokens[0], tokens);
					printf("Error: No such command found.\n");
					exit(1);
				}
				else if (r > 0){
					if (strcmp(tokens[length(tokens) - 1],"&") != 0){
						pids[pindex] = r;
						bg[pindex] = false;
						active[pindex] = true;
					}
					else{
						printf("Created background process with pid %d\n", r);
						pids[pindex] = r;
						bg[pindex] = true;
						active[pindex] = true;
					}
				}
				pindex = checkIfcanCreate(active, MAX_NUM_PROCESSES);
				if (pindex == -1) {
					pindex = reapSingle(bg, active, pids);
				}
			}
			reapParallel(bg, active, pids);
			clearTokens(tokens);
		}
		free(commands);
	}

	
	return 0;
}


