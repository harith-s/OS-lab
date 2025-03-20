#include <stdio.h>
#include <pthread.h>

// typedef struct {
//     int thread_num;
// } my_arg;

void * print_thread(void * arguments){
    int * arg = (int *) arguments;
    printf("I am thread %d\n", *arg);
    return NULL;
}
int main(){
    int n;
    scanf("%d", &n);
    pthread_t threads[n];
    int args[n];
    for (int i = 0; i < n; i++){
        args[i] = i + 1;
        pthread_create(&threads[i], NULL, print_thread, &args[i]);
    }
    // for (int i = 0; i < n; i++){
    //     printf("thread number : %d\n", args[i].thread_num);
    // }
    for (int i = 0; i < n; i++){
        pthread_join(threads[i], NULL);
    }   
    printf("I am the main thread, the greatest of them all\n");
}