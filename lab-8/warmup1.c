#include <stdio.h>
#include <pthread.h>

#define n_threads 10
int count = 0;
pthread_mutex_t lock;


void * threadfn(void * v){
    pthread_mutex_lock(&lock);
    for (int i = 0; i < 1000; i++){
        count++;
    }
    pthread_mutex_unlock(&lock);
    return NULL;
}

int main(){
    pthread_t threads[n_threads];
    for (int i = 0; i < n_threads; i++){
        pthread_create(&threads[i], NULL, threadfn, NULL);
    }
    for (int i = 0; i < n_threads; i++){
        pthread_join(threads[i], NULL);
    }
    printf("Count: %d\n", count);
}