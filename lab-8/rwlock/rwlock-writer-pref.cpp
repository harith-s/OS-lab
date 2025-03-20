#include "rwlock.h"

void InitalizeReadWriteLock(struct read_write_lock * rw)
{
  pthread_mutex_init(&rw->lock, NULL);
  pthread_mutex_init(&rw->rwlock, NULL);

  pthread_cond_init(&rw->creader, NULL);
  pthread_cond_init(&rw->cwriter, NULL);

  rw->nreaders = 0;
  rw->writing = 0;
  rw->started = 0;
}

void ReaderLock(struct read_write_lock * rw)
{
  pthread_mutex_lock(&rw->rwlock);

  while(rw->writing == 1 || rw->nwriters > 0){
    pthread_cond_wait(&rw->creader, &rw->rwlock);
  }

  if (rw->nreaders == 0){
    pthread_mutex_lock(&rw->lock);
  }
  rw->nreaders++;
  pthread_mutex_unlock(&rw->rwlock);


}

void ReaderUnlock(struct read_write_lock * rw)
{
  pthread_mutex_lock(&rw->rwlock);

  rw->nreaders--;
  if (rw->nreaders == 0){
    pthread_mutex_unlock(&rw->lock);
    pthread_cond_signal(&rw->cwriter);
  }
  pthread_mutex_unlock(&rw->rwlock);
}

void WriterLock(struct read_write_lock * rw)
{
  pthread_mutex_lock(&rw->rwlock);
  rw->nwriters++;

  while(rw->nreaders != 0 || rw->writing){

    pthread_cond_wait(&rw->cwriter, &rw->rwlock);
  }
  rw->writing = 1;
  
  pthread_mutex_lock(&rw->lock);

  pthread_mutex_unlock(&rw->rwlock);

}

void WriterUnlock(struct read_write_lock * rw)
{

  pthread_mutex_lock(&rw->rwlock);
  rw->nwriters--;
  rw->writing = 0;
  pthread_mutex_unlock(&rw->lock);

  pthread_cond_signal(&rw->cwriter);
  pthread_cond_broadcast(&rw->creader);
  
  pthread_mutex_unlock(&rw->rwlock);

}
