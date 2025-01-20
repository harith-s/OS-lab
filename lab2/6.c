#include  <stdio.h>
#include  <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char * argv[]){
    int N; 
    scanf("%d", &N); 
    for (int i = 0; i < N; i++){
        int r = fork();
        if (r == 0){
            printf("Child: %d\n", getpid());
        }
        else{
            int w = wait(NULL);
        }
    }
}