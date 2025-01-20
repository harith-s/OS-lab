#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

void sighandler(int s){
    if (s == SIGINT){
        printf("I will run forever MUHAHAHAHAHHAHAHAH!\n");
        return;
    }
}
int main(int argc, char * argv[]){
    while(1){
        signal(SIGINT, sighandler);
    }
}