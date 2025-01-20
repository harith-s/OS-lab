#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64
#define MAX_NUM_BG_PROCESSES 64
#define MAX_COMMANDS 10

/* Splits the string by space and returns the array of tokens
*
*/



pid_t fpid = 0;

void clearTokens(char ** tokens){
	for(int i=0;tokens[i]!=NULL;i++){
			free(tokens[i]);
		}
	free(tokens);
	return;
}
void checkForZombies(){
	int w = 1;

	while (w > 0){
		w = waitpid(-1, NULL, WNOHANG);
		if (w > 0) printf("Background Process %d is done.\n", w);
	}
	
	return;
}

int checkIfcanCreate(pid_t pids[], int size){
	for (int pindex = 0; pindex < size; pindex++){
		int w = waitpid(pids[pindex], NULL, WNOHANG);
		printf("Process is %d\n", w);
		if (w != 0) return pindex;
	}
	return -1;
	
}
void sighandler(int s){
	kill(fpid, SIGINT);
	return;
}

void killProcesses(pid_t pids[]){
	for (int i = 0; i < 64; i++){
		kill(pids[i], 9);
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
		if (strcmp("&&", tokens[i]) == 0){
			parsed_tokens[cmd_no] = command;
			command = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));
			cmd_no++;
			j = 0;
		}
		else {
			strcpy(command[j], tokens[i]);
			j++;
		}
	}
	parsed_tokens[cmd_no] = command;
	parsed_tokens[cmd_no + 1] = NULL;
	return parsed_tokens;


}

int main(int argc, char* argv[]) {

	pid_t pids[MAX_NUM_BG_PROCESSES];
	for (int j = 0; j < MAX_NUM_BG_PROCESSES; j++){
		pids[j] = 0;
	}
	int pindex = -1;

	char  line[MAX_INPUT_SIZE];            
	char  **tokens;              
	int i;

	signal(SIGINT, sighandler);
	while(1) {			
		/* BEGIN: TAKING INPUT */
		bzero(line, sizeof(line));
		char wd[100];
		getcwd(wd, 100);
		printf("%s$ ", wd);
		

		scanf("%[^\n]", line);
		getchar();

		checkForZombies();

		// Check if there is a valid index is present

		if (line[strlen(line) - 1] == '&'){
			pindex = checkIfcanCreate(pids, MAX_NUM_BG_PROCESSES);
			if (pindex == -1) {
				printf("Max background processes reached. Please wait.\n");
				continue;
			}

		}
		// printf("Command entered: %sremove this debug output later)\n", line);
		
		// Continue if no command is entered

		if (strlen(line) == 0) continue;


		line[strlen(line)] = '\n'; //terminate with new line
		tokens = tokenize(line);
		char *** commands = parseTokens(tokens);
       // Change directory
		for (int icmd = 0; commands[icmd] != NULL; icmd++){
			tokens = commands[icmd];
			if (strcmp(tokens[0], "cd") == 0){
				int err = chdir(tokens[1]);
				if (err == -1){
					printf("Changing directory failed. Please check the command.\n");
				}
			}
			// Exit command

			else if (strcmp(tokens[0], "exit") == 0 || strcmp(tokens[0], "q") == 0){
				clearTokens(tokens);
				killProcesses(pids);
				killpg(getpgid(getpid()), 9);

			}

			// All other commands

			else if (strcmp(line, "\n") != 0)
			{
				int r = fork();
				fpid = r;
				if (r == 0){
					if (line[strlen(line) - 2] == '&'){
						
						tokens[length(tokens) - 1] = NULL;
					}
					setpgid(0, 0);
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
				}
					
				
			}

		
			// Freeing the allocated memory	
			clearTokens(tokens);
		}
	}

	
	return 0;
}
