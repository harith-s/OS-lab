#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include <pthread.h>
#include "zemaphore.h"

#define NUM_THREADS 3
#define NUM_ITER 10

zem_t zem0;
zem_t zem1;
zem_t zem2;


void *justprint(void *data)
{
  int thread_id = *((int *)data);

  for(int i=0; i < NUM_ITER; i++)
    {
      if (thread_id == 0){
        zem_down(&zem0);
        printf("This is thread %d\n", thread_id);
        zem_up(&zem1);
      }
      else if (thread_id == 1){
        zem_down(&zem1);
        printf("This is thread %d\n", thread_id);
        zem_up(&zem2);
      }
      
      else if (thread_id == 2){
        zem_down(&zem2);
        printf("This is thread %d\n", thread_id);
        zem_up(&zem0);
      }

      
    }
  return 0;
}

int main(int argc, char *argv[])
{

  zem_init(&zem0, 1);
  zem_init(&zem1, 0);
  zem_init(&zem2, 0);

  pthread_t mythreads[NUM_THREADS];
  int mythread_id[NUM_THREADS];

  
  for(int i =0; i < NUM_THREADS; i++)
    {
      mythread_id[i] = i;
      pthread_create(&mythreads[i], NULL, justprint, (void *)&mythread_id[i]);
    }
  
  for(int i =0; i < NUM_THREADS; i++)
    {
      pthread_join(mythreads[i], NULL);
    }
  
  return 0;
}
