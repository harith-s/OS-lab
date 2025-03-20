#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>


pthread_cond_t cv = PTHREAD_COND_INITIALIZER;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
int count = 0;
int num_threads = 10;

void * threadfn(void * v){
    int thread_num = *((int *) v);
    while (1){
        pthread_mutex_lock(&lock);
        while(count % num_threads != thread_num)
            pthread_cond_wait(&cv, &lock);
        count++;
        pthread_cond_broadcast(&cv);

        printf("%d\n", thread_num);
        pthread_mutex_unlock(&lock);
    }

    return NULL;
}
int main(){
    int n;
    scanf("%d", &n);
    pthread_t threads[n];
    int args[n];
    num_threads = n;

    for (int i = 0; i < n; i++){
        args[i] = i;
        // printf("created!\n");
        pthread_create(&threads[i], NULL, threadfn, &args[i]);
    }

    for (int i = 0; i < n; i++){
        pthread_join(threads[i], NULL);
    }

}