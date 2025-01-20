#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX_INPUT_SIZE 1024
#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64

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

bool checkIfcanCreate(int pindex, pid_t pids[])
void sighandler(int s){
	kill(fpid, SIGINT);
	return;
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

int main(int argc, char* argv[]) {

	pid_t pids[64];
	int pindex = 0;

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

		if (line[strlen(line) - 2] == '&'){
			if (!checkIfcanCreate()) continue;
		}
		// printf("Command entered: %sremove this debug output later)\n", line);
		/* END: TAKING INPUT */
		if (strlen(line) == 0) continue;
		line[strlen(line)] = '\n'; //terminate with new line
		tokens = tokenize(line);



       //do whatever you want with the commands, here we just print them
	    if (strcmp(tokens[0], "cd") == 0){
			int err = chdir(tokens[1]);
			if (err == -1){
				printf("Changing directory failed. Please check the command.\n");
			}
		}

		else if (strcmp(tokens[0], "exit") == 0){
			clearTokens(tokens);
			killpg(getpgid(getpid()), 9);

		}
		else if (strcmp(line, "\n") != 0)
		{
			int shell_pid = getpid();

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
				pindex++;
			}
				
			
		}
		}
       
		// Freeing the allocated memory	
		clearTokens(tokens);

	
	return 0;
}
