#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char * argv[]){
    if (argc != 3){
        printf("Incorrect number of arguments\n");
        exit(1);
    }
    int r = fork();
    if (r == 0){
        char * args[2];
        args[0] = argv[1];
        args[1] = argv[2];
        printf("Avinash is an apple\n");
        int err = execvp(argv[1], args);
        printf("Avinash is aaaaaan apple\n");

        if (err == -1){
            printf("Exec failed\n");
            exit(1);
        }
    }
    else if (r > 0){
        int w = wait(NULL);
        printf("Command successfully completed\n");
        exit(0);
    }
}