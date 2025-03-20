#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>


pthread_cond_t * cvs;
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
int count = 0;

void * threadfn(void * v){
    int thread_num = *((int *) v);
    int t = rand() % 10 + 1;
    // printf("Time I, the thread %d, am sleeping for  is %d\n", thread_num, t);
    sleep(t);
    pthread_mutex_lock(&lock);
    while(count < thread_num)
        pthread_cond_wait(&cvs[thread_num - 1], &lock);
    count++;
    pthread_cond_signal(&cvs[thread_num]);

    printf("I am thread %d\n", thread_num);
    pthread_mutex_unlock(&lock);

    return NULL;
}
int main(){
    int n;
    scanf("%d", &n);
    pthread_t threads[n];
    int args[n];

    cvs = malloc(n * sizeof(pthread_cond_t));

    for (int i = 0; i < n; i++){
        pthread_cond_init(&cvs[i], NULL);
    }

    for (int i = 0; i < n; i++){
        args[i] = i;
        // printf("created!\n");
        pthread_create(&threads[i], NULL, threadfn, &args[i]);
    }

    for (int i = 0; i < n; i++){
        pthread_join(threads[i], NULL);
    }

}