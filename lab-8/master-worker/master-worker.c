#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include <pthread.h>

int item_to_produce, curr_buf_size;
int curr_cons_pos;
int total_items, max_buf_size, num_workers, num_masters;
int item_to_consume;
int started;
int done = 0;
int master_behind_cons;
int *buffer;

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cv_prod = PTHREAD_COND_INITIALIZER;
pthread_cond_t cv_cons = PTHREAD_COND_INITIALIZER;



void print_produced(int num, int master) {

  printf("Produced %d by master %d\n", num, master);
}

void print_consumed(int num, int worker) {

  printf("Consumed %d by worker %d\n", num, worker);
  
}


//produce items and place in buffer
//modify code below to synchronize correctly
void *generate_requests_loop(void *data)
{
  int thread_id = *((int *)data);

  while(1)
  {
      pthread_mutex_lock(&lock);

      if(item_to_produce >= total_items) {
        pthread_cond_broadcast(&cv_cons);
        pthread_cond_broadcast(&cv_prod);
        pthread_mutex_unlock(&lock);
        done = 1;
	      break;
      }

      // check here in case two threads are woken up at the same time

      while (curr_buf_size >= curr_cons_pos && started && master_behind_cons && !done){
      // printf("master Waiting brdr...\n");

        pthread_cond_wait(&cv_prod, &lock);
      }
      started = 1;
      
      if(item_to_produce >= total_items) {
        pthread_cond_broadcast(&cv_cons);
        pthread_cond_broadcast(&cv_prod);
        pthread_mutex_unlock(&lock);
        done = 1;
	      break;
      }

      buffer[curr_buf_size] = item_to_produce;
      // printf("I wrote at position %d the value %d\n", curr_buf_size, item_to_produce);
      curr_buf_size++;
      pthread_cond_signal(&cv_cons);

      if (curr_buf_size == max_buf_size) 
      {  
        curr_buf_size = 0;
        master_behind_cons = 1;
        pthread_cond_broadcast(&cv_cons);
      }
      
      print_produced(item_to_produce, thread_id);
      item_to_produce++;
      pthread_mutex_unlock(&lock);
    }
  return 0;
}

//write function to be run by worker threads
//ensure that the workers call the function print_consumed when they consume an item

void *consume_item(void * data){
  int thread_id = *((int *)data);

  while(1){
    pthread_mutex_lock(&lock);

    if (done && curr_buf_size == curr_cons_pos && !master_behind_cons){
      pthread_cond_broadcast(&cv_prod);
      pthread_mutex_unlock(&lock);
      break;
    }
    

    while (curr_cons_pos >= curr_buf_size && !master_behind_cons && !done)
    {
        pthread_cond_wait(&cv_cons, &lock);
    }

    if (done && curr_buf_size == curr_cons_pos && !master_behind_cons){
      pthread_cond_broadcast(&cv_prod);
      pthread_mutex_unlock(&lock);
      break;
    }
    
    item_to_consume = buffer[curr_cons_pos];
    // printf("I consumed at position %d\t", curr_cons_pos);
    print_consumed(item_to_consume, thread_id);
    curr_cons_pos++;

    if (curr_cons_pos == max_buf_size) 
    {  
      curr_cons_pos = 0;
      master_behind_cons = 0;
      pthread_cond_signal(&cv_prod);

    }

    pthread_cond_signal(&cv_prod);
    pthread_mutex_unlock(&lock);
  }
}

int main(int argc, char *argv[])
{
  started = 0;
  curr_cons_pos = 0;
  int *master_thread_id;
  pthread_t *master_thread;
  item_to_produce = 0;
  curr_buf_size = 0;
  master_behind_cons = 0;
  
  int i;
  
   if (argc < 5) {
    printf("./master-worker #total_items #max_buf_size #num_workers #masters e.g. ./exe 10000 1000 4 3\n");
    exit(1);
  }
  else {
    num_masters = atoi(argv[4]);
    num_workers = atoi(argv[3]);
    total_items = atoi(argv[1]);
    max_buf_size = atoi(argv[2]);
  }
    

   buffer = (int *)malloc (sizeof(int) * max_buf_size);

   //create master producer threads
        pthread_cond_broadcast(&cv_prod);

   master_thread_id = (int *)malloc(sizeof(int) * num_masters);
   master_thread = (pthread_t *)malloc(sizeof(pthread_t) * num_masters);


   int * worker_thread_id = (int *) malloc(sizeof(int) * num_workers);
   pthread_t * worker_threads = (pthread_t *)malloc(sizeof(pthread_t) * num_workers);

  for (i = 0; i < max_buf_size; i++){
    buffer[i] = -1;
  }
  
   for (i = 0; i < num_masters; i++)
    master_thread_id[i] = i;
    
   for (i = 0; i < num_workers; i++)
    worker_thread_id[i] = i;

   for (i = 0; i < num_masters; i++)
     pthread_create(&master_thread[i], NULL, generate_requests_loop, (void *)&master_thread_id[i]);

   for (i = 0; i < num_workers; i++)
     pthread_create(&worker_threads[i], NULL, consume_item, (void *)&worker_thread_id[i]);
  
  //create worker consumer threads

  //wait for all threads to complete
  for (i = 0; i < num_masters; i++)
    {
      pthread_join(master_thread[i], NULL);
      printf("master %d joined\n", i);
    }
  
  for (i = 0; i < num_workers; i++)
    {
      pthread_join(worker_threads[i], NULL);
      printf("worker %d joined\n", i);
    }
  
  /*----Deallocating Buffers---------------------*/
  free(buffer);
  free(master_thread_id);
  free(master_thread);
  free(worker_thread_id);
  free(worker_threads);
  
  return 0;
}
