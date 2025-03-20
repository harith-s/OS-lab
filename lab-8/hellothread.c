#include <stdio.h>
#include <pthread.h>

#define N 10000
int count = 0;
pthread_mutex_t lock;
typedef struct{
    int a;
} args;

void * threadfn(void * a){
    pthread_mutex_lock(&lock);
    args * arg = (args *)a;
    count += arg->a;
    pthread_mutex_unlock(&lock);
    return NULL;
}

int main(){
    pthread_t threads[N];
    for (int i = 0; i < N; i++){
        args a = {1};
        pthread_create(&threads[i], NULL, threadfn, &a);
    }
    for (int i = 0; i < N; i++){
        pthread_join(threads[i], NULL);
    }
    printf("Count: %d\n", count);
}