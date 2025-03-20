#include <stdio.h>
#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <fcntl.h>              /* Obtain O_* constant definitions */
#include <unistd.h>


int main(){
    int pipefd[2];
    pipe(pipefd);


    int ret = fork();
    if (ret == 0){
        close(pipefd[1]);
        char buffer[30];
        read(pipefd[0], buffer, 30);
        printf("%s\n", buffer);
        close(pipefd[0]);

    }
    else{
        close(pipefd[0]);
        char * buffer = "dei dubukku";
        write(pipefd[1], buffer, 11);
        close(pipefd[1]);
    }

}