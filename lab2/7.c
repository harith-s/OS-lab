#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char * argv[]){
    int r = fork();
    if (r == 0){
        sleep(1000);
        exit(0);
    }
    else if (r > 0){
        sleep(2);
        kill(r, SIGINT);
        printf("Killed the process: %d. It was taking tooo long\n", r);
    }
}
